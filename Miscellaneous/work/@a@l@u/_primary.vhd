library verilog;
use verilog.vl_types.all;
entity ALU is
    port(
        opcode          : in     vl_logic;
        A1              : in     vl_logic_vector(511 downto 0);
        A2              : in     vl_logic_vector(511 downto 0);
        alu_result      : out    vl_logic_vector(1023 downto 0)
    );
end ALU;
