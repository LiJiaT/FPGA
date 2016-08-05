/*
This program is design for providing command address.
In serial process case, CPU will read command for 0 address in ROM. Every command takes two clock to process and the pc_addr will add 2 and move to next command.
In JUM case, the CPU will output a load_pc signal, this module then put the ir_addr into pc_addr instead of adding the pc_addr.
*/

module couter (pc_addr,ir_addr,load, clock, rst);
output [2:0] pc_addr;
input [12:0] ir_addr;
input load,clock,rst;

reg[12:0] pc_addr;

always @(posedge clock, posedge rst)
begin
	if(rst)
		pc_addr <= 13'b0_0000_0000_0000;
	else 
		if(load)
			pc_addr <= ir_addr;
		else 
			pc_addr <= pc_addr + 1;
end


endmodule 