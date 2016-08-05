module accum(accum,data,ena,clk,rst);
input [7:0] data ;
output [15:0] accum;
input ena,clk,rst;

reg [7:0] accum;

always @(posedge clk)
begin 
	if(rst)
		accum <= 8'b0000_0000;
	else 
		if(ena)
			accum <= data;
end

endmodule 