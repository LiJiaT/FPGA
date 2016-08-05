//******************************************************
//COPYRIGHT(c)2016,SouthChina university of technology
//ALL rights reserved.
//IP LIB INDEX :
//IP Name		:
//
//File name		:pstoda.v
//Module name 	:pstoda
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
module pstoda (
					  //INPUT
					  sclk,	
					  rst,
					  data,
						
					  //OUTPUT
						ack,	//data request	
						scl,	//I2C clock wire
						sda	//I2C data wire
					  );
//********************************************************
//DEFINE PARAMETER //
//********************************************************

//nine segment state machine declare
parameter ready = 8'b0000_0000,		//start state	
				start = 8'b0000_0001,	//send start signal to I2C
				bit1 = 8'b0000_0010,		//send bit1 to I2C
				bit2 = 8'b0000_0100,		//send bit2 to I2C
				bit3 = 8'b0000_1000,		//send bit3 to I2C
				bit4 = 8'b0001_0000,		//send bit4 to I2C
				bit5 = 8'b0010_0000,		//send to stop
				stop = 8'b0100_0000,		//send stop signal to I2C
				IDLE = 8'b1000_0000;		//IDLE
				
//********************************************************
//DEFINE INPUT //
//********************************************************
input sclk,rst;
input [3:0] data;


//********************************************************
//DEFINE OUTPUT //
//********************************************************
output ack;
output scl;
inout sda;



//********************************************************
//OUTPUT ATRIBUTE //
//********************************************************
//REGS
reg scl,
		link_sda,
		ack,
		sdabuf;				//I2C data buffer inside, connect to I2C when link_sda is high
reg [3:0] databuf;		//buffer storing data from top module 
reg [7:0] state;			

//WIRES
assign sda = link_sda? sdabuf : 1'bz;


//********************************************************
//MODULE  REGISTERS/WIRES DEFINE //
//********************************************************




//********************************************************
//INSTANCE MODULE //
//********************************************************



//********************************************************
//MAIN CODE //
//********************************************************
//1/2 clock devide
always @(posedge sclk , negedge rst)	
begin 
	if(!rst)
		scl <= 1'b1;
	else 
		scl <= ~scl;
end


// data stroing after sending ack.
always @(posedge ack)
databuf <= data;


always @(negedge sclk , negedge rst)
if(!rst)
begin 
	link_sda <= 1'b0;
	state <= ready;
	sdabuf <= 1'b1;
	ack <= 1'b0;
end
else begin
	case (state)
	ready: if (ack)		//already received data form top module, start occupiding I2C 
				begin 
					link_sda <= 1'b1;
					state <= start;
				end
			else 
				begin
					link_sda <= 1'b0;
					state <= ready;
					ack <= 1'b1;
				end
	start: if(scl && ack)	//generate start signal to I2C
				begin
				sdabuf <= 1'b0;
				state <= bit1;
				end
			else state <= start;
	bit1: if(!scl)			//send the MSB in data to I2C
				begin
				sdabuf <= databuf[3];
				state <= bit2;
				ack <=1'b0;	//else it would be always in "start" 
				end
			else state <= bit1;	
	bit2: if(!scl)			//send the 3 bit in data to I2C
				begin
					sdabuf <= databuf[2];
					state <= bit3;
				end
			else state <= bit2;
	bit3: if(!scl)			//send the 2 bit in data to I2C
				begin
					sdabuf <= databuf[1];
					state <= bit4;
				end
			else state <= bit3;
	bit4: if(!scl)			//send the first bit in data to I2C
				begin 
					sdabuf <= databuf[0];
					state <= bit5;
				end
				else state <= bit4;
	bit5: if(!scl)			//set the sda into low to ready for stop signal
				begin 
					sdabuf <= 1'b0;
					state <= stop;
				end
				else state <= bit5;
				
	stop: if(scl)			//generate stop signal
				begin 
					sdabuf <= 1'b1;
					state <= IDLE;
				end
				else state <= stop;
	IDLE: begin 			//IDLE
				link_sda <= 1'b0;
				sdabuf <=1'b1;
				state <= ready;
			end
	default: begin 
					link_sda <= 1'b0;
					sdabuf <= 1'b1;
					state <= ready;
				end
	endcase 			
	
end

//********************************************************//
endmodule










