//******************************************************
//COPYRIGHT(c)2016,SouthChina university of technology
//ALL rights reserved.
//IP LIB INDEX :
//IP Name		:
//
//File name		:FSM.v
//Module name 	:FSM
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
module FSM (
					  //INPUT
				clk,
				rst,
				A,
					  //OUTPUT
				K1,
					K2
					  );
//********************************************************
//DEFINE PARAMETER //
//********************************************************
parameter IDLE = 2'b00,
				Start = 2'b01,
				Stop = 2'b10,
				Clear = 2'b11;

//********************************************************
//DEFINE INPUT //
//********************************************************
input clk,rst,A;
//********************************************************
//DEFINE OUTPUT //
//********************************************************
output K2,K1;
//********************************************************
//OUTPUT ATRIBUTE //
//********************************************************
//REGS
reg K2,K1;
reg [1:0] Cstate,Nstate;

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

//-------- check state change in every clk posedge --------//
// nonblock assignment must be used to tranmit state
always @(posedge clk)
begin 
	if(!rst)	
		Cstate <= IDLE;
	else
		Cstate <= Nstate;
end

//-------- logic generating next state --------//
// use block assignment in this block
always @(Cstate, A)
begin 
	case(Cstate)
		IDLE: if(A) 
					Nstate = Start;
				else
					Nstate = IDLE;
		Start: if(!A)
					Nstate = Stop;
				 else 
					Nstate = Start;
		Stop: if(A)
					Nstate = Clear;
				 else 
					Nstate = Stop;
		Clear: if(!A)
					Nstate = IDLE;
				 else 
					Nstate = Clear;
		default: Nstate = 2'bxx;
	endcase
end

//-------- logic generating output --------//
// use block assignment if there are no any sequantial logic
always @(Cstate , rst , A)
begin 
	if(!rst)	K1 = 0;
	else 
		if(Cstate == Clear && !A)
			K1 = 1;
		else 
			K1 = 0;
end

always @(Cstate , rst , A)
begin 
	if(!rst) K2 = 0;
	else 
		if(Cstate == Stop && A)
			K2 = 1;
		else K2 = 0;
end



//********************************************************//
endmodule










