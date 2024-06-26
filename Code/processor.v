// instruction[12:11] = opcode, instruction[10:9] = reg_no, instruction[8:0] = address
// opcodes : 00 = add, 01 = mul, 10 = load, 11 = store
module processor (
    input wire clk,
    input wire rst,
    input wire [12:0] instruction,
    output wire [511:0] A [0:3])
;
wire [1023:0] alu_result;
wire [511:0] memory_result;
ALU inst1 (
    .opcode(instruction[11]),
    .A1(A[0]),
    .A2(A[1]),
    .alu_result(alu_result)
    );
register_file inst2 (
    .clk(clk),
    .rst(rst),
    .write_en(~(instruction[12] & instruction[11])),
    .load_en(instruction[12] & ~instruction[11]),
    .dst_reg(instruction[10:9]),
    .load_data(memory_result),
    .alu_result(alu_result),
    .A(A)
    );
memory inst3 (
    .clk(clk),
    .rst(rst),
    .write_en(instruction[12] & instruction[11]),
    .input_data(A[instruction[10:9]]),
    .address(instruction[8:0]),
    .output_data(memory_result)
    );
endmodule