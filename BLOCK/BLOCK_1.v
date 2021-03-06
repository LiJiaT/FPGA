`timescale 1ns/1ns
`include "./block.v"
`include "./non_blocking.v"

module BLOCK;
wire [3:0] b1,c1,b2,c2;
reg [3:0] a;
reg clk;

non_blocking non_blocking(clk,a,b2,c2);
block block(clk,a,b1,c1);

initial 
begin 
	clk =0;
	forever #50 clk = ~clk;
end

initial 
begin 
	a = 4'h3;
	#100 a= 4'h7;
	#100 a = 4'hf;
	#100 a = 4'ha;
	#100 a = 4'h2;
	#100 a = 4'h5;
	#100 stop;

end