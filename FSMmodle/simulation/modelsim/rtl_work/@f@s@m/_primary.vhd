library verilog;
use verilog.vl_types.all;
entity FSM is
    generic(
        IDLE            : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        Start           : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        Stop            : vl_logic_vector(0 to 1) := (Hi1, Hi0);
        Clear           : vl_logic_vector(0 to 1) := (Hi1, Hi1)
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        A               : in     vl_logic;
        K1              : out    vl_logic;
        K2              : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of Start : constant is 1;
    attribute mti_svvh_generic_type of Stop : constant is 1;
    attribute mti_svvh_generic_type of Clear : constant is 1;
end FSM;
