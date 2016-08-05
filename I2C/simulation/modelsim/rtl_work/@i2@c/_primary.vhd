library verilog;
use verilog.vl_types.all;
entity I2C is
    port(
        data            : in     vl_logic_vector(3 downto 0);
        sclk            : in     vl_logic;
        rst             : in     vl_logic;
        outhigh         : out    vl_logic_vector(15 downto 0);
        ack             : out    vl_logic
    );
end I2C;
