library verilog;
use verilog.vl_types.all;
entity ALU_BASED_STACK is
    generic(
        N               : vl_notype;
        MAX_SIZE        : vl_notype
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        opcode          : in     vl_logic_vector(2 downto 0);
        input_data      : in     vl_logic_vector;
        output_data     : out    vl_logic_vector;
        overflow        : out    vl_logic;
        success         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of N : constant is 5;
    attribute mti_svvh_generic_type of MAX_SIZE : constant is 5;
end ALU_BASED_STACK;
