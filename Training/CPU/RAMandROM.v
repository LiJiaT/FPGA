module ram(data , addr, ena, read, write);
inout [7:0] data;
input [9:0] addr;
input ena ;
input read,write;

reg [7:0] ram [10'h3ff:0];

assign data = (read &&ena)? ram [addr] : 8'hzz;

always @(posedge write)
ram[addr] <= data;

endmodule 


module rom (data,addr,read, ena);
input [12:0] addr;
output[7:0] data ;
input read, ena;

reg [7:0] memory [13'h1fff:0];
wire [7:0] data;

assign data = (read && ena) ? memory[addr]:8'bzzzz;


endmodule 