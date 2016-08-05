//******************************************************
//COPYRIGHT(c)2016,SouthChina university of technology
//ALL rights reserved.
//IP LIB INDEX :I2C
//IP Name		:
//
//File name		:I2C.v
//Module name 	:I2C
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
//This project including module pstoda and module out16hi. 
//Module pstoda receive 4 bits data and turn the data into serial formatat then transmit them to out16hi using I2C contact. 
//Module out16hi reseive messages form I2C and turn them into relative 16 bits output.

//********************************************************
//DEFINE MODULE PORT //
//********************************************************
//
module I2C (
					  //INPUT
					data,	//4bit data  input 
					sclk,	//clock using in the I2C
					rst,	//reset
					  //OUTPUT
					outhigh,	//16 bits output 
					ack		//data request 
					  );
//********************************************************
//DEFINE PARAMETER //
//********************************************************


//********************************************************
//DEFINE INPUT //
//********************************************************
input [3:0] data;
input sclk;
input rst;

//********************************************************
//DEFINE OUTPUT //
//********************************************************
output [15:0] outhigh; 
output ack;
//********************************************************
//OUTPUT ATRIBUTE //
//********************************************************
//REGS

//WIRES
wire 	scl,		//  I2C clock wire inside
		sda;		//  I2C data wire inside


//********************************************************
//MODULE  REGISTERS/WIRES DEFINE //
//********************************************************
pstoda A(.sclk(sclk),.rst(rst),.data(data),.ack(ack),.scl(scl),.sda(sda));
out16hi B(.scl(scl),.sda(sda),.outhigh(outhigh));



//********************************************************
//INSTANCE MODULE //
//********************************************************



//********************************************************
//MAIN CODE //
//********************************************************



//********************************************************//
endmodule










