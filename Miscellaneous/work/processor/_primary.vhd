library verilog;
use verilog.vl_types.all;
entity processor is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        instruction     : in     vl_logic_vector(12 downto 0);
        A               : out    vl_logic
    );
end processor;
