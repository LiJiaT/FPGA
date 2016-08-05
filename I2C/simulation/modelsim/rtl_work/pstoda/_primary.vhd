library verilog;
use verilog.vl_types.all;
entity pstoda is
    generic(
        ready           : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        start           : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1);
        bit1            : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0);
        bit2            : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0);
        bit3            : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0);
        bit4            : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0);
        bit5            : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0);
        stop            : vl_logic_vector(0 to 7) := (Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        IDLE            : vl_logic_vector(0 to 7) := (Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0)
    );
    port(
        sclk            : in     vl_logic;
        rst             : in     vl_logic;
        data            : in     vl_logic_vector(3 downto 0);
        ack             : out    vl_logic;
        scl             : out    vl_logic;
        sda             : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ready : constant is 1;
    attribute mti_svvh_generic_type of start : constant is 1;
    attribute mti_svvh_generic_type of bit1 : constant is 1;
    attribute mti_svvh_generic_type of bit2 : constant is 1;
    attribute mti_svvh_generic_type of bit3 : constant is 1;
    attribute mti_svvh_generic_type of bit4 : constant is 1;
    attribute mti_svvh_generic_type of bit5 : constant is 1;
    attribute mti_svvh_generic_type of stop : constant is 1;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
end pstoda;
