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

    initial begin
        seed = 123456;
        $urandom(seed);

        clk = 0;
        rst = 0;

        repeat (3) begin
            number1 = {N{1'b0}};
            number2 = {N{1'b0}};
            number3 = {N{1'b0}};
            number4 = {N{1'b0}};

            for (i = 0; i < N; i = i + 1) begin
                number1[i] = $urandom % 2;
                number2[i] = $urandom % 2;
                number3[i] = $urandom % 2;
                number4[i] = $urandom % 2;
            end

            $display("Generated 4 random values: %d, %d, %d, %d", $signed(number1), $signed(number2), $signed(number3), $signed(number4));

            input_data = number1;
            $display("Stack push: %d", $signed(input_data));
            opcode = 3'b110;
            #20; 

            input_data = number2;
            $display("Stack push: %d", $signed(input_data));
            opcode = 3'b110;
            #20; 

            input_data = number3;
            $display("Stack push: %d", $signed(input_data));
            opcode = 3'b110;
            #20; 

            input_data = number4;
            $display("Stack push: %d", $signed(input_data));
            opcode = 3'b110;
            #20; 

            result = number4 + number3;
            truncated_result = result;
            $display("Addition of top two stack values: %d + %d = %d (expected), truncated to %d bits = %d", 
                     $signed(number4), $signed(number3), $signed(result), N, $signed(truncated_result));
            opcode = 3'b100;
            #20; 
            $display("Addition result: %d, Overflow: %b", $signed(output_data), overflow);

            $display("Stack pop, expecting: %d", $signed(number4));
            opcode = 3'b111;
            #20; 
            $display("Popped value: %d", $signed(output_data));

            $display("Stack pop, expecting: %d", $signed(number3));
            opcode = 3'b111;
            #20; 
            $display("Popped value: %d", $signed(output_data));

            result = number1 * number2;
            truncated_result = result;
            $display("Multiplication of top two stack values: %d * %d = %d (expected), truncated to %d bits = %d", 
                     $signed(number1), $signed(number2), $signed(result), N, $signed(truncated_result));
            opcode = 3'b101;
            #20; 
            $display("Multiplication result: %d, Overflow: %b", $signed(output_data), overflow);
        end

        $finish;
    end

endmodule
