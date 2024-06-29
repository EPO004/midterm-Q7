`timescale 1ns/1ps

module evalpost_tb;

    parameter LEN = 100; 
    parameter N = 16;   

    reg [8*LEN-1:0] infix_expr;
    wire signed [N-1:0] result;
    wire overflow;

    evalpost #(.LEN(LEN), .N(N)) uut (
        .infix_expr(infix_expr),
        .result(result),
        .overflow(overflow)
    );

    task padding;
        input integer str_len;
        begin
            integer i;
            for (i = 0; i < str_len; i = i + 1) begin
                infix_expr = {infix_expr, "\0"};
            end
        end
    endtask

    initial begin
        infix_expr = "2 * 3 + (10 + 4 + 3) * -20 + (6 + 5)";
        padding(64);
        $display("Infix expression: %s", infix_expr);
        #1000 $display("result: %d, overflow: %d", result, overflow);
        
        $stop;
    end

endmodule
