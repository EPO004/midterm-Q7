`timescale 1ns / 1ps
module infix2postfix #(parameter LEN = 16)(
    input reg [8*LEN-1:0] infix_expr,  
    output reg [8*LEN-1:0] postfix_expr
);
    reg [7:0] stack_in;
    wire [7:0] stack_out;
    reg stack_push, stack_pop, stack_clk, rst;
    wire full, empty;
    integer out_idx;          
    integer i; 

    Stack#(8, LEN) stack_inst (
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
        stack_push = 0;
        stack_pop = 0;
        stack_clk = 0;
        rst = 1;
        #10 stack_clk = 1;
        #10 stack_clk = 0;
        out_idx = 8*LEN - 8;
        rst = 0;
    end

    initial begin
        postfix_expr = {LEN{"\0"}};

        #100
        for (i = 8*LEN - 8; i >= 0; i = i - 8) begin
            if (infix_expr[i+:8] == 0) begin
                break;
            end else if ((infix_expr[i+:8] != "+") && (infix_expr[i+:8] != "*") && (infix_expr[i+:8] != "(") && (infix_expr[i+:8] != ")")) begin
                postfix_expr[out_idx+:8] = infix_expr[i+:8];
                out_idx = out_idx - 8;
            end else if (infix_expr[i+:8] == "(") begin
                stack_push = 1;
                stack_in = infix_expr[i+:8];
                #1 stack_clk = 1;
                #1 stack_clk = 0;
                stack_push = 0;
            end else if (infix_expr[i+:8] == ")") begin
                stack_pop = 1;
                #1 stack_clk = 1;
                #1 stack_clk = 0;
                stack_pop = 0;
                while (!empty && stack_out != "(") begin
                    postfix_expr[out_idx+:8] = stack_out;
                    out_idx = out_idx - 8;
                    stack_pop = 1;
                    #1 stack_clk = 1;
                    #1 stack_clk = 0;
                    stack_pop = 0;
                end
            end else begin
                if (empty) begin
                    stack_push = 1;
                    stack_in = infix_expr[i+:8];
                    #1 stack_clk = 1;
                    #1 stack_clk = 0;
                    stack_push = 0;
                end else begin
                    stack_pop = 1;
                    #1 stack_clk = 1;
                    #1 stack_clk = 0;
                    stack_pop = 0;
                    stack_push = 1;
                    stack_in = stack_out;
                    #1 stack_clk = 1;
                    #1 stack_clk = 0;
                    stack_push = 0;
                    
                    while (!empty && ((infix_expr[i+:8] == "+" && (stack_out == "+" || stack_out == "*")) || (infix_expr[i+:8] == "*" && stack_out == "*"))) begin
                        stack_pop = 1;
                        #1 stack_clk = 1;
                        #1 stack_clk = 0;
                        stack_pop = 0;
                        postfix_expr[out_idx+:8] = stack_out;
                        out_idx = out_idx - 8;
                        if (empty) begin
                            break;
                        end
                        stack_pop = 1;
                        #1 stack_clk = 1;
                        #1 stack_clk = 0;
                        stack_pop = 0;
                        stack_push = 1;
                        stack_in = stack_out;
                        #1 stack_clk = 1;
                        #1 stack_clk = 0;
                        stack_push = 0;
                    end
                    
                    stack_push = 1;
                    stack_in = infix_expr[i+:8];
                    #1 stack_clk = 1;
                    #1 stack_clk = 0;
                    stack_push = 0;
                end
            end
        end
        while (!empty) begin
            stack_pop = 1;
            #1 stack_clk = 1;
            #1 stack_clk = 0;
            stack_pop = 0;
            postfix_expr[out_idx+:8] = stack_out;
            out_idx = out_idx - 8;
        end
    end
endmodule
