library verilog;
use verilog.vl_types.all;
entity stack is
    generic(
        N               : integer := 8;
        MAX_SIZE        : integer := 16
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        push            : in     vl_logic;
        pop             : in     vl_logic;
        data_in         : in     vl_logic_vector;
        data_out        : out    vl_logic_vector;
        full            : out    vl_logic;
        empty           : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of N : constant is 1;
    attribute mti_svvh_generic_type of MAX_SIZE : constant is 1;
end stack;
