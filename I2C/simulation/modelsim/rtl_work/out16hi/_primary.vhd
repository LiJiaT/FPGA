library verilog;
use verilog.vl_types.all;
entity out16hi is
    generic(
        ready           : vl_logic_vector(0 to 5) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        sbit0           : vl_logic_vector(0 to 5) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1);
        sbit1           : vl_logic_vector(0 to 5) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi0);
        sbit2           : vl_logic_vector(0 to 5) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi0);
        sbit3           : vl_logic_vector(0 to 5) := (Hi0, Hi0, Hi1, Hi0, Hi0, Hi0);
        sbit4           : vl_logic_vector(0 to 5) := (Hi0, Hi1, Hi0, Hi0, Hi0, Hi0)
    );
    port(
        scl             : in     vl_logic;
        sda             : in     vl_logic;
        outhigh         : out    vl_logic_vector(15 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ready : constant is 1;
    attribute mti_svvh_generic_type of sbit0 : constant is 1;
    attribute mti_svvh_generic_type of sbit1 : constant is 1;
    attribute mti_svvh_generic_type of sbit2 : constant is 1;
    attribute mti_svvh_generic_type of sbit3 : constant is 1;
    attribute mti_svvh_generic_type of sbit4 : constant is 1;
end out16hi;
