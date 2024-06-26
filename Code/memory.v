module memory (
    input wire clk,
    input wire rst,
    input wire write_en,
    input wire [511:0] input_data,
    input wire [8:0] address,
    output reg [511:0] output_data
);
    reg signed [31:0] memory [0:511];
    reg [9:0] end_addr;
    integer i;
    always @(negedge clk or negedge rst) begin
        if (!rst) begin
            for (i = 0; i < 512; i = i + 1) begin
                memory[i] <= 32'b0;
            end
        end else if (write_en) begin
            end_addr = address + 16;
            for (i = address; i < end_addr; i = i + 1) begin
                if (i < 512) begin
                    memory[i] <= input_data[(i - address) * 32 +: 32];
                end
            end
        end
    end
    always @(posedge clk) begin
        output_data <= 512'b0;
        end_addr = address + 16;
        for (i = address; i < end_addr; i = i + 1) begin
            if (i < 512) begin
                output_data[(i - address) * 32 +: 32] <= memory[i];
            end
        end
    end
endmodule
