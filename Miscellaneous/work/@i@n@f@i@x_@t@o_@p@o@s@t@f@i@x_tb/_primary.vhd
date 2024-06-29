library verilog;
use verilog.vl_types.all;
entity INFIX_TO_POSTFIX_tb is
    generic(
        LEN             : integer := 100
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of LEN : constant is 1;
end INFIX_TO_POSTFIX_tb;
