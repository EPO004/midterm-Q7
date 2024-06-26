library verilog;
use verilog.vl_types.all;
entity memory is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        write_en        : in     vl_logic;
        input_data      : in     vl_logic_vector(511 downto 0);
        address         : in     vl_logic_vector(8 downto 0);
        output_data     : out    vl_logic_vector(511 downto 0)
    );
end memory;
