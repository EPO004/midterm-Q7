library verilog;
use verilog.vl_types.all;
entity infix2postfix is
    generic(
        LEN             : integer := 16
    );
    port(
        infix_expr      : in     vl_logic_vector;
        postfix_expr    : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of LEN : constant is 1;
end infix2postfix;
