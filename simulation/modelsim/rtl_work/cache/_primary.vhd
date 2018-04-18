library verilog;
use verilog.vl_types.all;
entity cache is
    generic(
        size            : integer := 1024;
        index_size      : integer := 10
    );
    port(
        data            : in     vl_logic_vector(31 downto 0);
        addr            : in     vl_logic_vector(31 downto 0);
        wr              : in     vl_logic;
        clk             : in     vl_logic;
        response        : out    vl_logic;
        is_missrate     : out    vl_logic;
        \out\           : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of size : constant is 1;
    attribute mti_svvh_generic_type of index_size : constant is 1;
end cache;
