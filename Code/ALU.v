module ALU (
    input wire opcode,
    input wire [511:0] A1,
    input wire [511:0] A2,
    output reg [1023:0] alu_result
);
integer i;
reg signed [31:0] A1_part, A2_part;
reg signed [63:0] alu_part;
reg overflow;
always @(*) begin
    case (opcode)
        1'b0: begin
            for (i = 0; i < 16; i = i + 1) begin
                A1_part = A1[i * 32 +: 32];
                A2_part = A2[i * 32 +: 32];
                alu_part = A1_part + A2_part;
                overflow = (~A1_part[31] & ~A2_part[31] & alu_part[31]) |
                           (A1_part[31] & A2_part[31] & ~alu_part[31]);
                if (overflow) begin
                    if (alu_part[32]) begin
                        alu_part[63:33] <= 31'b1;
                    end
                    else if (alu_part[31]) begin
                        alu_part[63:32] <= 32'b1;
                    end
                end
                alu_result[i * 64 +: 64] = alu_part;
            end
        end
        1'b1: begin
            for (i = 0; i < 16; i = i + 1) begin
                A1_part = A1[i * 32 +: 32];
                A2_part = A2[i * 32 +: 32];

                alu_part = A1_part * A2_part;
                alu_result[i * 64 +: 64] = alu_part;
            end
        end
    endcase
end
endmodule
