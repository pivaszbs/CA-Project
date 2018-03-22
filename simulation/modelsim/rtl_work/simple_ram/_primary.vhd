library verilog;
use verilog.vl_types.all;
entity simple_ram is
    port(
        data            : in     vl_logic_vector(31 downto 0);
        addr            : in     vl_logic_vector(4 downto 0);
        wr              : in     vl_logic;
        clk             : in     vl_logic;
        enable          : in     vl_logic;
        q               : out    vl_logic_vector(31 downto 0)
    );
end simple_ram;
