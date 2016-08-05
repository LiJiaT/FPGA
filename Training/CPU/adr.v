/*
This module is designe for choosing the output form PC(program counting) address and data(port) address.
In every command, the first four clock use for reading command in ROM ,the address will be PC address, and the later four clock use for read or write data into RAM or port, the address will be IR_addr.
The control signal provided by a 8 devided signal form clock.
*/


module adr(addr,fetch,ir_addr,pc_addr);
output [12:0] addr;
input [12:0] ir_addr,pc_addr;
input fetch;

assign addr = fetch? pc_addr:ir_addr; 

endmodule 