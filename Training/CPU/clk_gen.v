`timescale 1ns/1ns 
module clk_gen(clk,reset,fetch,alu_ena);
input clk,reset;
output fetch,alu_ena;

wire clk,reset;

reg fetch,alu_ena;
reg [7:0] state;

parameter S1 = 8'b0000_0001,
				S2 = 8'b0000_0010,
				S3 = 8'b0000_0100,
				S4 = 8'b0000_1000,
				S5 = 8'b0001_0000,
				S6 = 8'b0010_0000,
				S7 = 8'b0100_0000,
				S8 = 8'b1000_0000,
				IDLE = 8'b0000_0000;

always @(posedge clk)
begin 
	if(reset)
	begin 
		fetch <= 0;
		alu_ena <= 0;
		state <=  IDLE;
	end
	else 
	begin 
		case (state)
			S1: 
			begin 
				alu_ena <= 1;
				state <=  S2;
			end
			S2:
			begin 
				alu_ena <= 1;
				state <= S3;
			end
			S3:
			begin 
				fetch <= 1;
				state <= S4;
			end
			S4:
			begin 
				state <= S5;
			end
			S5: state <= S6;
			S6: state <= S7;
			S7:
			begin 
				fetch <= 0;
				state <= S8;
			end
			S8:state <= S1;
			IDLE: state <= S1;
			default: state <= IDLE;
		endcase 
	end

end


endmodule 