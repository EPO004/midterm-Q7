`timescale 1ns / 1ps
module STACK_BASED_ALU #(parameter N, parameter MAX_SIZE)(
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
        if (opcode == 3'b110) begin
            if (!full) begin
                stack_push = 1;
                stack_in = input_data;
                #1 stack_clk = 1;
                #1 stack_clk = 0;
                stack_push = 0;
                success = 1;
            end 
        end else if (opcode == 3'b111) begin
            if (!empty) begin
                stack_pop = 1;
                #1 stack_clk = 1;
                #1 stack_clk = 0;
                output_data = stack_out;
                stack_pop = 0;
                success = 1;
            end
        end else if (opcode == 3'b100 || opcode == 3'b101) begin
            if (!empty) begin
                stack_pop = 1;
                #1 stack_clk = 1;
                #1 stack_clk = 0;
                top = stack_out;
                stack_pop = 0;
                if (!empty) begin
                    stack_pop = 1;
                    #1 stack_clk = 1;
                    #1 stack_clk = 0;
                    top_next = stack_out;
                    stack_pop = 0;
                    success = 1;
                    if (opcode == 3'b100) begin
                        output_data = top + top_next;
                        overflow = (~top[N-1] & ~top_next[N-1] & output_data[N-1]) | (top[N-1] & top_next[N-1] & ~output_data[N-1]);
                    end else begin
                        output_data = top * top_next;
                        result = top * top_next;
                        truncated_result = top * top_next;
                        if (result != truncated_result) begin
                            overflow = 1;
                        end
                    end
                    stack_push = 1;
                    stack_in = top_next;
                    #1 stack_clk = 1;
                    #1 stack_clk = 0;
                    stack_push = 0;
                    stack_push = 1;
                    stack_in = top;
                    #1 stack_clk = 1;
                    #1 stack_clk = 0;
                    stack_push = 0;
                end else begin
                    stack_push = 1;
                    stack_in = top;
                    #1 stack_clk = 1;
                    #1 stack_clk = 0;
                    stack_push = 0;
                end
            end
        end 
    end
endmodule
