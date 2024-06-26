module register_file (
    input wire clk,
    input wire rst,
    input wire write_en,
    input wire load_en,
    input wire [1:0] dst_reg,
    input reg [511:0] load_data,
    input reg [1023:0] alu_result,
    output reg [511:0] A [0:3]
);
integer i;
always @(negedge clk or negedge rst) begin
    if (!rst) begin
        // Initialize register values
        A[0] <= 512'hFFFFFFFF_FFFFFFFF_FFFFFFFF_7FFFFFFF_7FFFFFFF_7FFFFFFF_80000000_80000000_80000000_00000000_00000000_00000000_00000001_00000001_00000001_00000001;
        A[1] <= 512'hFFFFFFFF_7FFFFFFF_80000000_FFFFFFFF_7FFFFFFF_80000000_FFFFFFFF_7FFFFFFF_80000000_FFFFFFFF_7FFFFFFF_80000000_FFFFFFFF_7FFFFFFF_80000000_00000001;
        A[2] <= 512'b0;
        A[3] <= 512'b0;
    end else if (write_en) begin
        if (load_en) begin
            A[dst_reg] <= load_data;
        end else begin
            for (i = 0; i < 16; i = i + 1) begin
                A[2][i * 32 +: 32] <= alu_result[i * 64 +: 32];
                A[3][i * 32 +: 32] <= alu_result[i * 64 + 32 +: 32];
            end
        end
    end
end
endmodule
