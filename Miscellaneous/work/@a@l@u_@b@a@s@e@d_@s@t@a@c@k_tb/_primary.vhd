library verilog;
use verilog.vl_types.all;
entity ALU_BASED_STACK_tb is
    generic(
        N               : integer := 4;
        MAX_SIZE        : integer := 1024
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of N : constant is 1;
    attribute mti_svvh_generic_type of MAX_SIZE : constant is 1;
end ALU_BASED_STACK_tb;
