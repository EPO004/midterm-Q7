`timescale 1ns / 1ps
module stack #(
    parameter N = 8, 
    parameter MAX_SIZE = 16 
)(
    input wire clk,
    input wire rst,
    input wire push,
    input wire pop,
    input wire signed [N-1:0] data_in,
    output reg signed [N-1:0] data_out,
    output reg full,
    output reg empty
);
    localparam LOG2_MAX_SIZE = $clog2(MAX_SIZE);
    reg signed [N-1:0] memory [0:MAX_SIZE-1];
    reg [LOG2_MAX_SIZE-1:0] top_index;
    initial begin
        top_index = 0;
        full = 0;
        empty = 1;
        data_out = 0; 
    end
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top_index <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            if (push && !full) begin
                memory[top_index] <= data_in;
                top_index <= top_index + 1;
                if (top_index + 1 == MAX_SIZE) begin
                    full <= 1;
                end
                empty <= 0;
            end else if (pop && !empty) begin
                top_index <= top_index - 1;
                data_out <= memory[top_index - 1];
                if (top_index - 1 == 0) begin
                    empty <= 1;
                end
                full <= 0;
            end
        end
    end
endmodule
