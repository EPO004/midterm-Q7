`timescale 1ns/1ps
module evalpost #(parameter LEN, parameter N)(
    input reg [8*LEN-1:0] infix_expr,
    output reg signed [N-1:0] result,
    output reg overflow
);
    wire [8*LEN-1:0] postfix_expr;
    reg clk, rst;
    reg [2:0] opcode;
    reg signed [N-1:0] input_data;
    wire signed [N-1:0] output_data;
    reg signed [N-1:0] temp_data;
    wire wire_overflow, success;
    integer i, j, digits, is_neg, tmp_index;

    infix2postfix #(LEN) uut1 (
        .infix_expr(infix_expr),
        .postfix_expr(postfix_expr)
    );
    STACK_BASED_ALU #(N, LEN) uut2 (
        .clk(clk),
        .rst(rst),
        .opcode(opcode),
        .input_data(input_data),
        .output_data(output_data),
        .overflow(wire_overflow),
        .success(success)
    );
    always #10 clk = ~clk;
    initial begin
        rst = 1;
        clk = 0;
        opcode = 3'b000;
        overflow = 0;
        #200 rst = 0;
        $display("Postfix expression: %s", postfix_expr);
        for (i = 8*LEN-8; i >= 0; i = i - 8) begin
            if (postfix_expr[i+:8] == 0) begin
                break;
            end

            if (postfix_expr[i+:8] == "+" || postfix_expr[i+:8] == "*") begin
                opcode = (postfix_expr[i+:8] == "+") ? 3'b100 : 3'b101;
                #20; 
                temp_data = output_data;
                if (wire_overflow) begin
                    overflow = 1;
                end
                opcode = 3'b111;
                #20; 
                opcode = 3'b111;
                #20; 
                input_data = temp_data;
                opcode = 3'b110;
                #20; 
                opcode = 3'b000;
            end else if (postfix_expr[i+:8] == " ") begin
                continue;

            end else begin
                is_neg = 0;
                digits = 0;
                input_data = 0;
                tmp_index = i;
                for (j = i; j >= 0; j = j - 8) begin
                    if (postfix_expr[j+:8] == " " || postfix_expr[j+:8] == "+" || postfix_expr[j+:8] == "*") begin
                        i = i + 8;
                        break;
                    end else if (postfix_expr[j+:8] == "-") begin
                        is_neg = 1;
                    end else begin
                        digits = digits + 1;
                    end
                    i = i - 8;
                end
                digits = digits - 1;
                if (is_neg) begin
                    tmp_index = tmp_index - 8;
                end
                for (j = tmp_index; digits >= 0; j = j - 8) begin
                    input_data = input_data * 10 + (postfix_expr[j+:8] - "0");
                    digits = digits - 1;
                end
                if (is_neg) begin
                    input_data = -input_data;
                end
                opcode = 3'b110;
                #20; 
                opcode = 3'b000;
            end
        end
        result = temp_data;
    end
endmodule
