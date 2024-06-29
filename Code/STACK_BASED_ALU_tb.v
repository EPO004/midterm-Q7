`timescale 1ns / 1ps

`define N 4

module STACK_BASED_ALU_tb;
    parameter N = 4;
    parameter MAX_SIZE = 1024;

    reg clk;
    reg rst;
    reg [2:0] opcode;
    reg signed [N-1:0] input_data;
    reg signed [N-1:0] number1;
    reg signed [N-1:0] number2;
    reg signed [N-1:0] number3;
    reg signed [N-1:0] number4;
    reg signed [N-1:0] truncated_result;
    reg signed [2*N-1:0] result;
    integer seed, i;

    wire signed [N-1:0] output_data;
    wire overflow;
    wire success;

    STACK_BASED_ALU #(N, MAX_SIZE) uut (
        .clk(clk),
        .rst(rst),
        .opcode(opcode),
        .input_data(input_data),
        .output_data(output_data),
        .overflow(overflow),
        .success(success)
    );

    always #10 clk = ~clk;

    task initialize;
        begin
            clk = 0;
            rst = 0;
            seed = 123456;
            $urandom(seed);
        end
    endtask

    task generate_random_numbers;
        output signed [N-1:0] num1, num2, num3, num4;
        begin
            num1 = 0;
            num2 = 0;
            num3 = 0;
            num4 = 0;

            for (i = 0; i < N; i = i + 1) begin
                num1[i] = $urandom % 2;
                num2[i] = $urandom % 2;
                num3[i] = $urandom % 2;
                num4[i] = $urandom % 2;
            end
            $display("Generated 4 random values: %d, %d, %d, %d", $signed(num1), $signed(num2), $signed(num3), $signed(num4));
        end
    endtask

    task push_to_stack;
        input signed [N-1:0] value;
        begin
            input_data = value;
            opcode = 3'b110;
            #20;
            $display("Stack push: %d", $signed(input_data));
        end
    endtask

    task pop_from_stack;
        input signed [N-1:0] expected_value;
        begin
            opcode = 3'b111;
            #20;
            $display("Stack pop, expecting: %d", $signed(expected_value));
            $display("Popped value: %d", $signed(output_data));
        end
    endtask

    task perform_addition;
        input signed [N-1:0] val1, val2;
        begin
            result = val1 + val2;
            truncated_result = result;
            $display("Addition of top two stack values: %d + %d = %d (expected), truncated to %d bits = %d", 
                     $signed(val1), $signed(val2), $signed(result), N, $signed(truncated_result));
            opcode = 3'b100;
            #20;
            $display("Addition result: %d, Overflow: %b", $signed(output_data), overflow);
        end
    endtask

    task perform_multiplication;
        input signed [N-1:0] val1, val2;
        begin
            result = val1 * val2;
            truncated_result = result;
            $display("Multiplication of top two stack values: %d * %d = %d (expected), truncated to %d bits = %d", 
                     $signed(val1), $signed(val2), $signed(result), N, $signed(truncated_result));
            opcode = 3'b101;
            #20;
            $display("Multiplication result: %d, Overflow: %b", $signed(output_data), overflow);
        end
    endtask

    initial begin
        initialize;

        repeat (3) begin
            generate_random_numbers(number1, number2, number3, number4);

            push_to_stack(number1);
            push_to_stack(number2);
            push_to_stack(number3);
            push_to_stack(number4);

            perform_addition(number4, number3);

            pop_from_stack(number4);
            pop_from_stack(number3);

            perform_multiplication(number1, number2);
        end

        $finish;
    end

endmodule
