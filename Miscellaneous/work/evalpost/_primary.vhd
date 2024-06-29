library verilog;
use verilog.vl_types.all;
entity evalpost is
    generic(
        LEN             : vl_notype;
        N               : vl_notype
    );
    port(
        infix_expr      : in     vl_logic_vector;
        result          : out    vl_logic_vector;
        overflow        : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of LEN : constant is 5;
    attribute mti_svvh_generic_type of N : constant is 5;
end evalpost;
