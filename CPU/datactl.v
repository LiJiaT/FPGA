/*
This module is design for controling the output of accmulator.
The databus can only be occypied by accmulator when the data need to be sent to RAM area or ports. The data_ena signal origined form datactl_ena form CPU.
*/

module datactl(data ,in , data_ena);
input [7:0] in;
output [7:0] data;
input data_ena;

assign data = (data_ena)?in:8'bzzzz_zzzz;

endmodule 