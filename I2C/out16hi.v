//******************************************************
//COPYRIGHT(c)2016,SouthChina university of technology
//ALL rights reserved.
//IP LIB INDEX :
//IP Name		:
//
//File name		:out16hi.v
//Module name 	:out16hi
//Full name		:
//
//Author 		:LeeJT
//Email			:1164880972@qq.com
//Data			:
//Version		:
//
//Abstract		:
//Called by		:Son Module
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
module out16hi (
					  //INPUT
					scl,	//I2C clock signal	
					sda,	//I2C data signal
					  //OUTPUT
					outhigh	//otuput 16 bits signal
					  );
//********************************************************
//DEFINE PARAMETER //
//********************************************************
//five segment state machine
parameter ready = 6'b00_0000,
				sbit0 = 6'b00_0001,
				sbit1 = 6'b00_0010,
				sbit2 = 6'b00_0100,
				sbit3 = 6'b00_1000,
				sbit4 = 6'b01_0000;
				

//********************************************************
//DEFINE INPUT //
//********************************************************
input scl,
		sda;
//********************************************************
//DEFINE OUTPUT //
//********************************************************
output [15:0] outhigh;
//********************************************************
//OUTPUT ATRIBUTE //
//********************************************************
//REGS
reg [15:0] outhigh;
reg [5:0] mstate;
reg [3:0] pdata,		//input data judgment register
			 pdatebuf;	//data receive register 
reg StartFlag,			//start data receiving flag	
		EndFlag;			//data receiving finish flag

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

//Set the StartFlag to 1 when reveive the start signal
always @(negedge sda)
begin 
	if(scl)
	begin 
		StartFlag <= 1'b1;
	end
	else if (EndFlag)
		StartFlag <= 1'b0;
end

//set the endFlag to 1 when receive the end signal
always @(posedge sda)
begin 
	if(scl)
	begin 
		EndFlag <= 1'b1;
		pdatebuf <= pdata;
	end
	else 
	EndFlag <= 1'b0;
end


//transform the input 4bits data input 16 bits output
always @(pdatebuf)
begin 
	case (pdatebuf)
		4'b0001: outhigh = 16'b0000_0000_0000_0001;
		4'b0010: outhigh = 16'b0000_0000_0000_0010;	
		4'b0011: outhigh = 16'b0000_0000_0000_0100;	
		4'b0100: outhigh = 16'b0000_0000_0000_1000;	
		4'b0101: outhigh = 16'b0000_0000_0001_0000;	
		4'b0110: outhigh = 16'b0000_0000_0010_0000;	
		4'b0111: outhigh = 16'b0000_0000_0100_0000;	
		4'b1000: outhigh = 16'b0000_0000_1000_0000;	
		4'b1001: outhigh = 16'b0000_0001_0000_0000;	
		4'b1010: outhigh = 16'b0000_0010_0000_0000;	
		4'b1011: outhigh = 16'b0000_0100_0000_0000;	
		4'b1100: outhigh = 16'b0000_1000_0000_0000;	
		4'b1101: outhigh = 16'b0001_0000_0000_0000;	
		4'b1110: outhigh = 16'b0010_0000_0000_0000;	
		4'b1111: outhigh = 16'b0100_0000_0000_0000;		
		4'b0000: outhigh = 16'b1000_0000_0000_0000;					
	endcase 
end


always @(posedge scl)
begin 
	if (StartFlag)				//data transmit begin 
		case (mstate)
			sbit0:begin 		//receive the MSB of data
					mstate <= sbit1;
					pdata[3] <= sda;
					$display("I am in sdabit0.");
			end			
			sbit1:begin 		//reveive the 4th bit of data
					mstate <= sbit2;
					pdata[2] <= sda;
					$display("I am in sdabit1.");
			end
			sbit2:begin 		//receive the 3rd bit of data 
					mstate <= sbit3;
					pdata[1] <= sda;
					$display("I am in sdabit2.");
			end
			sbit3:begin 		//receive the LSB of data
					mstate <= sbit4;
					pdata[0] <= sda;
					$display("I am in sdabit3.");
			end
			sbit4:begin 		//stop state 
					mstate <= sbit0;
					$display("I am in sdastop.");
			end
			default: mstate <= sbit0;
			
		endcase 
	else mstate <= sbit0;
end



//********************************************************//
endmodule










