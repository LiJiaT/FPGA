library verilog;
use verilog.vl_types.all;
entity fbosc1 is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        y1              : out    vl_logic;
        y2              : out    vl_logic
    );
end fbosc1;
