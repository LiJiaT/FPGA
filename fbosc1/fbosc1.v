//******************************************************
//COPYRIGHT(c)2016,SouthChina university of technology
//ALL rights reserved.
//IP LIB INDEX :
//IP Name		:
//
//File name		:fbosc1.v
//Module name 	:fbosc1
//Full name		:
//
//Author 		:LeeJT
//Email			:1164880972@qq.com
//Data			:
//Version		:
//
//Abstract		:
//Called by		:Father Module
//
//Modification history
//--------------------------------------------------------
// //
// $LOG$
//
//********************************************************

//********************************************************
//DEFINE MODULE PORT //
//********************************************************
//

/*
The project fbosc1 and fbosc2 are design for understanding difference between block and unblock assignment.
When the rst signal is "1", the output y1 and y2 are assign to be 0 and 1 respectively. 
When the rst negedge happen, the two assignment command "y2 = y1 and y1 = y2" will be excutided in the same time, so shows the difference.
I concluded form these trainings that lobck assignment command will caculate the reslut and assign to the output at same clock, 
during which other commands cannot assign the output, so it is called 'bolck'. The unblock assignment caculate the value in one clock 
and assign the value in an another. 
Another important point is if there are not posedge or negedge behind always command, the cirtuit generated for block and unblock assignment are the same, 
but function are different. So it is very important to use negedge and posedge in unblock assignment commands.
*/
module fbosc1 (
					  //INPUT
						clk,
						rst,
					  //OUTPUT
						y1,
						y2
					  );
//********************************************************
//DEFINE PARAMETER //
//********************************************************


//********************************************************
//DEFINE INPUT //
//********************************************************
input clk, rst;
//********************************************************
//DEFINE OUTPUT //
//********************************************************
output y1, y2;
//********************************************************
//OUTPUT ATRIBUTE //
//********************************************************
//REGS
reg y1, y2;

//WIRES



//********************************************************
//MODULE  REGISTERS/WIRES DEFINE //
//********************************************************




//********************************************************
//INSTANCE MODULE //
//********************************************************



//********************************************************
//MAIN CODE //
//********************************************************
always @(clk, rst)
begin 
	if(rst) y2 =1;
	else y2 = y1;
end


always @(clk, rst)
begin 
	if(rst) y1 =0;
	else y1 = y2;
end

/*
In this cirtuit, there is a generated buffer in front of Y1 signal. So there will be a delay for Y1 assign to be Y2(the first always module),
it means the output will be both 0 at the end.
*/

//********************************************************//
endmodule










