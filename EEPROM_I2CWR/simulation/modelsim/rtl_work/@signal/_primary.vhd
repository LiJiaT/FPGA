library verilog;
use verilog.vl_types.all;
entity \Signal\ is
    port(
        RESET           : out    vl_logic;
        CLK             : out    vl_logic;
        RD              : out    vl_logic;
        WR              : out    vl_logic;
        ADDR            : out    vl_logic_vector(10 downto 0);
        ACK             : in     vl_logic;
        DATA            : inout  vl_logic_vector(7 downto 0)
    );
end \Signal\;
