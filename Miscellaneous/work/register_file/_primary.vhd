library verilog;
use verilog.vl_types.all;
entity register_file is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        write_en        : in     vl_logic;
        load_en         : in     vl_logic;
        dst_reg         : in     vl_logic_vector(1 downto 0);
        load_data       : in     vl_logic_vector(511 downto 0);
        alu_result      : in     vl_logic_vector(1023 downto 0);
        A               : out    vl_logic
    );
end register_file;
