//******************************************************
//COPYRIGHT(c)2016,SouthChina university of technology
//ALL rights reserved.
//IP LIB INDEX :
//IP Name		:
//
//File name		:EEPROM_I2CWR.v
//Module name 	:EEPROM_I2CWR
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
module EEPROM_I2CWR (
					  //INPUT
						rst,	//reset signal
						CLK,	//clock
						WR,	//write SDA signal
						RD,	//read SDA signal
						ADDR,	//address
						SDA,	//SDA
						DATA,	//8-bits parallel data output, data from SDA
					  //OUTPUT
						SCL,	//SCL
						ACK	//Data request after 8-bits input 
					  );
//********************************************************
//DEFINE PARAMETER //
//********************************************************
parameter 

//main state define
	IDLE 			= 11'b000_0000_0001,
	Ready			= 11'b000_0000_0010,
	Write_start = 11'b000_0000_0100,
	Ctrl_write 	= 11'b000_0000_1000,
	Addr_write 	= 11'b000_0001_0000,
	Data_write 	= 11'b000_0010_0000,
	Read_start 	= 11'b000_0100_0000,
	Ctrl_read 	= 11'b000_1000_0000,
	Data_read 	= 11'b001_0000_0000,
	Stop = 		  11'b010_0000_0000,
	Ackn = 		  11'b100_0000_0000,
	
//serial data output state define
	sh8out_bit7 = 9'b0_0000_0001,
	sh8out_bit6 = 9'b0_0000_0010,
	sh8out_bit5 = 9'b0_0000_0100,
	sh8out_bit4 = 9'b0_0000_1000,
	sh8out_bit3 = 9'b0_0001_0000,
	sh8out_bit2 = 9'b0_0010_0000,
	sh8out_bit1 = 9'b0_0100_0000,
	sh8out_bit0 = 9'b0_1000_0000,
	sh8out_end =  9'b1_0000_0000,
	
//serila data input stat define
	sh8in_begin = 10'b00_0000_0001,
	sh8in_bit7 =  10'b00_0000_0010,
	sh8in_bit6 =  10'b00_0000_0100,
	sh8in_bit5 =  10'b00_0000_1000,
	sh8in_bit4 =  10'b00_0001_0000,
	sh8in_bit3 =  10'b00_0010_0000,
	sh8in_bit2 =  10'b00_0100_0000,
	sh8in_bit1 =  10'b00_1000_0000,
	sh8in_bit0 =  10'b01_0000_0000,
	sh8in_end =   10'b10_0000_0000,
	
//head state define
	head_begin = 3'b001,
	head_bit = 3'b010,
	head_end = 3'b100,
	
//stop state define
	stop_begin = 3'b001,
	stop_bit = 3'b010,
	stop_end = 3'b100,
	
	YES = 1'b1,
	NO = 1'b0;

	
	
	
//********************************************************
//DEFINE INPUT //
//********************************************************
input rst;
input CLK;
input RD,WR;
input [10:0] ADDR;
inout SDA;
inout [7:0] DATA;



//********************************************************
//DEFINE OUTPUT //
//********************************************************
output SCL;
output ACK;


//********************************************************
//OUTPUT ATRIBUTE //
//********************************************************
//REGS
reg ACK;
reg SCL;
reg WF,RF;
reg FF;
reg [1:0] head_buf;			//used for generating negedge in SDA
reg [1:0] stop_buf;			//used for generating posedge in SDA
reg [7:0] sh8out_buf;		//store the output data
reg [8:0] sh8out_state;		
reg [9:0] sh8in_state;
reg [2:0] head_state;
reg [2:0] stop_state;
reg [10:0] main_state;
reg [7:0] data_from_rm;		//store the input data

reg link_sda;				//switch controling the linking to SDA
reg link_read;				//switch controling the linking form input data store to output signal
reg link_write;			//switch controling the linking from MSB of data output buffer to SDA
reg link_stop;				//link the stop_buf to SDA to generate posedge using displacement control	
reg link_head;				//link the head_buf to SDA to generate posedge usging displacement control


//WIRES
//sda4 is the final signal link to SDA, other signal deside the sda4.
wire sda1,sda2,sda3,sda4;


//********************************************************
//MODULE  REGISTERS/WIRES DEFINE //
//********************************************************




//********************************************************
//INSTANCE MODULE //
//********************************************************



//********************************************************
//MAIN CODE //
//********************************************************
assign sda1 = (link_head)? 	head_buf[1] :	1'b0;	//for generating negedge in begin 
assign sda2 = (link_write)? 	sh8out_buf[7]: 1'b0;	//for outputting data 
assign sda3 = (link_stop)? 	stop_buf[1] :	1'b0;	//for generating posedge in stop
assign sda4 = (sda1|sda2|sda3);							//define the sda4
assign SDA = (link_sda)? 		sda4 :			1'bz;	//link the sda4 to SDA
assign DATA = (link_read)? 	data_from_rm: 	8'hzz;//output the data collected form SDA


//trigged SCL in clk posedge and trigged SDA in clk negedge
//This trick is vert important and useful to satisfy the I2C protal
always @(negedge CLK)
begin 
	if(rst)
		SCL <= 0;
	else 
		SCL <= ~SCL;
end


//main state program
always @(posedge CLK)
if(rst)
	begin 
		link_head <= NO;
		link_read <= NO;
		link_write <= NO;
		link_sda <= NO;
		ACK <= NO;			
		RF <= NO;
		WF <= NO;
		FF <= NO;
		main_state <= IDLE;
	end
else 
	begin 
		casex(main_state)
		
			//detect the input signal and set main-sstate to Ready if changed
			IDLE: 						
				begin 
					link_read <= NO;
					link_write <= NO;
					link_head <= NO;
					link_stop <= NO;
					link_sda <= NO;
					if(WR)
					begin 
						WF <= 1;			//write flag
							main_state <= Ready;
					end
					else if (RD)
							begin 
								RF <=1; 	//read flag
								main_state <= Ready;
							end
							else 
							begin 
								WF <=0 ;
								RF <= 0;
								main_state <= IDLE;
							end
				end
						
				//set all control signal and prepare to generate a negedge in SDA		
				Ready:					
					begin 
						link_read <= NO;
						link_write <= NO;
						link_head <= YES;
						link_sda <= YES;
						link_stop <= NO;
						head_buf[1:0] <= 2'b10;	//for generating negedge 
						stop_buf[1:0] <= 2'b01;	//for generating posedge
						head_state <= head_begin;
						FF <= 0;						//finish flag
						ACK <= 0;
						main_state <= Write_start;
					end
					
		//call the shift_head task to generate a negedge in SDA.
		//I think the SDA is set to high in Ready state, so the begin state in shift_head task is useless
		/*It is very important in this program to understand that it is a state machine nesting in states.
		In the iner state machine the FF will be set to 1, which lead to one more clock cycle runing else.
		*/
			Write_start:
				begin 
					if(FF==0)
					shift_head;						
					else 
					begin	 
						sh8out_buf[7:0] <= {1'b1,1'b0,1'b1,1'b0,ADDR[10:8],1'b0};//sending control byte
						link_head <= NO;
						link_write <= YES;
						FF <= 0;
						/*
						The link to write and been connected and the signal is alse set, so the first control
						signal is sent in this clock. So in the Ctrl_write state the output start form byte6
						*/
						sh8out_state <= sh8out_bit6;
						main_state <= Ctrl_write;
					end
				end
							
			//sending the control signal	
			Ctrl_write:
				if(FF==0)
					shift8_out;
					else 
						begin 
							sh8out_state <= sh8out_bit7;
							sh8out_buf[7:0] <= ADDR[7:0];
							FF <=0;
							main_state <= Addr_write;
						end
											
			//sending address, change the state desideg on the WF and RF
				Addr_write:
					if(FF ==0 )
						shift8_out;
						else 
						begin
							FF <=0;
							if(WF)
							begin 
								sh8out_state <= sh8out_bit7;
								sh8out_buf[7:0] <= DATA;
								main_state <= Data_write;
							end
							if(RF)
							begin 
								head_buf <= 2'b10;
								head_state <= head_begin;
								main_state <= Read_start;
							end
						end
						
			//write data input SDA
			/*
			the shift8_out task will beeng called several times for sending message input SDA
			*/
				Data_write:
					if(FF==0)
						shift8_out;
					else 
					begin 
						stop_state <= stop_begin;
						main_state <= Stop;
						link_write <= NO;
						FF <= 0;
					end
					
			/*
			If read, There must be a reasart signal signal and control signal after the address message.
			*/
				Read_start:
					if(FF==0)
						shift_head;
					else 
					begin 
						sh8out_buf <= {1'b1,1'b0,1'b1,1'b0,ADDR[10:8],1'b1};
						link_head <= NO;
						link_sda <= YES;
						link_write <= YES;
						FF <= 0;
						sh8out_state <= sh8out_bit6;
						main_state <= Ctrl_read;
					end
					
			//resending control message 
				Ctrl_read:
					begin 
						if(FF==0)
							shift8_out;
						else 
						begin 
							link_sda <= NO;
							link_write <= NO;
							FF <= 0;
							sh8in_state <= sh8in_begin ;
							main_state <= Data_read;
						end
					end
					
			//read data form SDA and prepare to generate stop signal
				Data_read:
					if(FF==0)
						shift8in;
					else 
					begin
						link_stop <= YES;
						link_sda <= YES;
						stop_state <= stop_bit;
						FF <= 0;
						main_state <= Stop;
					end
				
			//generating stop signal
				Stop :
				if(FF==0)
					shift_stop;
				else 
					begin 
						ACK <= 1;
						FF <= 0;
						main_state <= Ackn;
					end
					
			//sending set low ACK signal.
				Ackn:
				begin 
					ACK <=0;
					WF <= 0;
					RF <= 0;
					main_state <= IDLE;
				end
				
				default: main_state <= IDLE;
		endcase 
	end

	
	
	//data input task. store the serial input in a buffer and output parallel
	//It take 9 clock to finish including one clock to stop
	task shift8in;
	begin 
		casex(sh8in_state)
			sh8in_begin:
				sh8in_state <= sh8in_bit7;
			sh8in_bit7:
				if(SCL)
				begin 
					data_from_rm[7] <= SDA;
					sh8in_state <= sh8in_bit6;
				end
				else 
				sh8in_state <= sh8in_bit7;
				
			sh8in_bit6:
							if(SCL)
							begin 
								data_from_rm[6] <= SDA;
								sh8in_state <= sh8in_bit5;
							end
							else 
							sh8in_state <= sh8in_bit6;
			sh8in_bit5:
							if(SCL)
							begin 
								data_from_rm[5] <= SDA;
								sh8in_state <= sh8in_bit4;
							end
							else 
							sh8in_state <= sh8in_bit5;
			sh8in_bit4:
							if(SCL)
							begin 
								data_from_rm[4] <= SDA;
								sh8in_state <= sh8in_bit3;
							end
							else 
							sh8in_state <= sh8in_bit4;
			sh8in_bit3:
							if(SCL)
							begin 
								data_from_rm[3] <= SDA;
								sh8in_state <= sh8in_bit2;
							end
							else 
							sh8in_state <= sh8in_bit3;
			sh8in_bit2:
							if(SCL)
							begin 
								data_from_rm[2] <= SDA;
								sh8in_state <= sh8in_bit1;
							end
							else 
							sh8in_state <= sh8in_bit2;
			sh8in_bit1:
							if(SCL)
							begin 
								data_from_rm[1] <= SDA;
								sh8in_state <= sh8in_bit0;
							end
							else 
							sh8in_state <= sh8in_bit1;
			sh8in_bit0:
							if(SCL)
							begin 
								data_from_rm[0] <= SDA;
								sh8in_state <= sh8in_end;
							end
							else 
							sh8in_state <= sh8in_bit0;
			sh8in_end:
							if(SCL)
							begin 
								link_read <= YES;
								FF <= 1;
								sh8in_state <= sh8in_bit7;
							end
							else 
							sh8in_state <= sh8in_end;
			default: 
					begin 
						link_read <= NO;
						sh8in_state <= sh8in_bit7;
					end
		endcase 
	end
	endtask
	

	
	/*
	Important task output serila signal to SDA.
	It take nine clock to output signal and stop.
	*/
task shift8_out;
begin 
	casex (sh8out_state)
		sh8out_bit7:
			if(!SCL) 
			begin 
				link_sda <= YES;
				link_write <= YES;
				sh8out_state <= sh8out_bit6;
			end
			else 
				sh8out_state  <= sh8out_bit7;
				
		sh8out_bit6:
			if(!SCL) 
			begin 
				link_sda <= YES;
				link_write <= YES;
				sh8out_state <= sh8out_bit5;
				sh8out_buf <= sh8out_buf <<1;
			end
			else 
				sh8out_state  <= sh8out_bit6;
				
		sh8out_bit5:
			if(!SCL) 
			begin 
				sh8out_state <= sh8out_bit4;
				sh8out_buf <= sh8out_buf <<1;
			end
			else 
				sh8out_state  <= sh8out_bit5;
				
		sh8out_bit4:
			if(!SCL) 
			begin 
				sh8out_state <= sh8out_bit3;
				sh8out_buf <= sh8out_buf <<1;
			end
			else 
				sh8out_state  <= sh8out_bit4;
				
		sh8out_bit3:
			if(!SCL) 
			begin 
				sh8out_state <= sh8out_bit2;
				sh8out_buf <= sh8out_buf <<1;
			end
			else 
				sh8out_state  <= sh8out_bit3;
				
		sh8out_bit2:
			if(!SCL) 
			begin 
				sh8out_state <= sh8out_bit1;
				sh8out_buf <= sh8out_buf <<1;
			end
			else 
				sh8out_state  <= sh8out_bit2;
				
		sh8out_bit1:
			if(!SCL) 
			begin 
				sh8out_state <= sh8out_bit0;
				sh8out_buf <= sh8out_buf <<1;
			end
			else 
				sh8out_state  <= sh8out_bit1;
				
		sh8out_bit0:
			if(!SCL) 
			begin 
				sh8out_state <= sh8out_end;
				sh8out_buf <= sh8out_buf <<1;
			end
			else 
				sh8out_state  <= sh8out_bit0;
				
		sh8out_end:
			if(!SCL) 
			begin 
				link_sda <= NO;
				link_write <= 1;
				FF <=1;
			end
			else 
				sh8out_state  <= sh8out_end;
		endcase 
end
endtask


//task generae begin signal in the begin 

task shift_head;
begin 
	casex (head_state)
		head_begin:
			if(!SCL)
			begin 
				link_write <= NO;
				link_sda <= YES;
				link_head <= YES;
				head_state <= head_bit;
			end
			else 
				head_state <= head_begin;
				
		head_bit:
			if(SCL)
			begin 
				FF <=1;
				head_buf <= head_buf <<1;
				head_state <= head_end;
			end
			else 
				head_state <= head_bit;
				
		head_end:
			if(!SCL)
			begin 
				link_head <= NO;
				link_write <= YES;
			end
			else 
				head_state <= head_end;
		endcase 
end
endtask 

//task generating stop signal in the stop 
task shift_stop;
begin 
	casex(stop_state)
		stop_begin: 
			if(!SCL)
			begin 
				link_sda <= YES;
				link_write <= NO;
				link_stop <= YES;
				stop_state <= stop_bit;
			end
			else 
				stop_state <= stop_begin;
				
		stop_bit:
			if(!SCL)
			begin 
				stop_buf <= stop_buf <<1;
				stop_state <= stop_end;
			end
			else 
				stop_state <= stop_bit;
			
		stop_end:
			if(!SCL)
			begin 
				link_head <= NO;
				link_stop <= NO;
				link_sda <= NO;
				FF <=1;
			end
			else 
				stop_state <= stop_end;
		endcase
end	
endtask

endmodule	












