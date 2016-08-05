module non_blocking(clk,a,b,c);
input clk;
output [3:0] b,c;
input [3:0] a;

reg [3:0] b,c;

always @(posedge clk)
begin 
	b<= a;
	c<=b;
end

endmodule 