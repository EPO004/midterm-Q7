`timescale 1ns / 1ps

module STACK_BASED_ALU #(parameter N, parameter MAX_SIZE) (
    input wire clk,
    input wire rst,
    input wire [2:0] opcode,
    input wire signed [N-1:0] input_data,
    output reg signed [N-1:0] output_data,
    output reg overflow,
    output reg success
);

    wire full, empty;
    reg stack_clk, stack_push, stack_pop;
    reg signed [N-1:0] stack_in, top, top_next;
    wire signed [N-1:0] stack_out;

    reg signed [N-1:0] truncated_result;
    reg signed [2*N-1:0] result;

    Stack#(N, MAX_SIZE) stack_inst (
        .clk(stack_clk),
        .rst(rst),
        .push(stack_push),
        .pop(stack_pop),
        .data_in(stack_in),
        .data_out(stack_out),
        .full(full),
        .empty(empty)
    );

    initial begin
        stack_clk = 0;
        stack_push = 0;
        stack_pop = 0;
    end

    always @(posedge clk) begin
        success = 0;
        overflow = 0;
        output_data = 'bz;

        if (opcode == 3'b110 && !full) begin
            stack_push = 1;
            stack_in = input_data;
            stack_clock_pulse();
            stack_push = 0;
            success = 1;

        end else if (opcode == 3'b111 && !empty) begin
            stack_pop = 1;
            stack_clock_pulse();
            output_data = stack_out;
            stack_pop = 0;
            success = 1;

        end else if ((opcode == 3'b100 || opcode == 3'b101) && !empty) begin
            perform_stack_operation(opcode);
        end
    end

    task stack_clock_pulse();
        begin
            #1 stack_clk = 1;
            #1 stack_clk = 0;
        end
    endtask

    task perform_stack_operation(input [2:0] operation);
        begin
            stack_pop = 1;
            stack_clock_pulse();
            top = stack_out;
            stack_pop = 0;

            if (!empty) begin
                stack_pop = 1;
                stack_clock_pulse();
                top_next = stack_out;
                stack_pop = 0;
                success = 1;

                if (operation == 3'b100) begin
                    perform_addition();
                end else if (operation == 3'b101) begin
                    perform_multiplication();
                end

                push_to_stack(top_next);
                push_to_stack(top);
            end else begin
                push_to_stack(top);
            end
        end
    endtask

    task perform_addition();
        begin
            output_data = top + top_next;
            overflow = (~top[N-1] & ~top_next[N-1] & output_data[N-1]) | (top[N-1] & top_next[N-1] & ~output_data[N-1]);
        end
    endtask

    task perform_multiplication();
        begin
            result = top * top_next;
            truncated_result = top * top_next;
            output_data = truncated_result;
            if (result != truncated_result) begin
                overflow = 1;
            end
        end
    endtask

    task push_to_stack(input signed [N-1:0] data);
        begin
            stack_push = 1;
            stack_in = data;
            stack_clock_pulse();
            stack_push = 0;
        end
    endtask

endmodule
