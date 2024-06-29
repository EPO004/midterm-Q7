library verilog;
use verilog.vl_types.all;
entity evalpost_tb is
    generic(
        LEN             : integer := 100;
        N               : integer := 16
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of LEN : constant is 1;
    attribute mti_svvh_generic_type of N : constant is 1;
end evalpost_tb;
