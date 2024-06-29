`timescale 1ns / 1ps

`define N 4

module STACK_BASED_ALU_tb;
    parameter N = 4;
    parameter MAX_SIZE = 1024;

    reg clk;
    reg rst;
    reg [2:0] opcode;
    reg signed [N-1:0] input_data;
    reg signed [N-1:0] random_data1;
    reg signed [N-1:0] random_data2;
    reg signed [N-1:0] random_data3;
    reg signed [N-1:0] random_data4;
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
            random_data1 = {N{1'b0}};
            random_data2 = {N{1'b0}};
            random_data3 = {N{1'b0}};
            random_data4 = {N{1'b0}};

            for (i = 0; i < N; i = i + 1) begin
                random_data1[i] = $urandom % 2;
                random_data2[i] = $urandom % 2;
                random_data3[i] = $urandom % 2;
                random_data4[i] = $urandom % 2;
            end

            $display("Generated 4 random values: %d, %d, %d, %d", $signed(random_data1), $signed(random_data2), $signed(random_data3), $signed(random_data4));

            // Push 4 values onto the stack
            input_data = random_data1;
            $display("Stack push: %d", $signed(input_data));
            opcode = 3'b110;
            #20; // wait for one clock cycle

            input_data = random_data2;
            $display("Stack push: %d", $signed(input_data));
            opcode = 3'b110;
            #20; // wait for one clock cycle

            input_data = random_data3;
            $display("Stack push: %d", $signed(input_data));
            opcode = 3'b110;
            #20; // wait for one clock cycle

            input_data = random_data4;
            $display("Stack push: %d", $signed(input_data));
            opcode = 3'b110;
            #20; // wait for one clock cycle

            // Add the top two elements
            result = random_data4 + random_data3;
            truncated_result = result;
            $display("Addition of top two stack values: %d + %d = %d (expected), truncated to %d bits = %d", 
                     $signed(random_data4), $signed(random_data3), $signed(result), N, $signed(truncated_result));
            opcode = 3'b100;
            #20; // wait for one clock cycle
            $display("Addition result: %d, Overflow: %b", $signed(output_data), overflow);

            // Pop top two values
            $display("Stack pop, expecting: %d", $signed(random_data4));
            opcode = 3'b111;
            #20; // wait for one clock cycle
            $display("Popped value: %d", $signed(output_data));

            $display("Stack pop, expecting: %d", $signed(random_data3));
            opcode = 3'b111;
            #20; // wait for one clock cycle
            $display("Popped value: %d", $signed(output_data));

            // Multiply the top two elements
            result = random_data1 * random_data2;
            truncated_result = result;
            $display("Multiplication of top two stack values: %d * %d = %d (expected), truncated to %d bits = %d", 
                     $signed(random_data1), $signed(random_data2), $signed(result), N, $signed(truncated_result));
            opcode = 3'b101;
            #20; // wait for one clock cycle
            $display("Multiplication result: %d, Overflow: %b", $signed(output_data), overflow);
        end

        $finish;
    end

endmodule
