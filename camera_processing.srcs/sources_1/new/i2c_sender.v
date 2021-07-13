`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/24/2021 07:50:36 PM
// Design Name: 
// Module Name: i2c_sender
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module i2c_sender(
	input clk,
	inout wire siod,
	output sioc,
	output taken,
	input send,
	input [7:0]id,
	input [7:0] reg1,
	input [7:0]value
	);
reg siod;
reg taken;
reg sioc;
reg [31:0]data_sr;
reg [31:0]busy_sr;
reg [7:0]divider;

always @ ( busy_sr or data_sr)
	begin
		if ( ( ( busy_sr[11:10] == 2'b10 ) | ( busy_sr[20:19] == 2'b10 ) ) | ( busy_sr[29:28] == 2'b10 ) )
			begin
				siod <= 1'bz;
			end
		else
			begin
				siod <= data_sr[31];
			end
	end
	
always @ ( posedge clk)
	begin
		if ( clk == 1'b1 )
			begin
				taken <= 1'b0;
				if ( busy_sr[31] == 1'b0 )
					begin
						sioc <= 1'b1;
						if ( send == 1'b1 )
							begin
								if ( divider == 8'b00000000 )
									begin
										data_sr <= { 3'b100, 2'b01 };
										busy_sr <= { 3'b111, 2'b11 };
										taken <= 1'b1;
									end
								else
									begin
										divider <= ( divider + 1 );
									end
							end
					end
				else
					begin
						case ( { busy_sr[31:29], busy_sr[2:0] } )
							{ 3'b111, 3'b111 }:
								begin
									case ( divider[7:6] )
										2'b00:
											begin
												sioc <= 1'b1;
											end
										2'b01:
											begin
												sioc <= 1'b1;
											end
										2'b10:
											begin
												sioc <= 1'b1;
											end
										default :
											begin
												sioc <= 1'b1;
											end
									endcase
								end
							{ 3'b111, 3'b110 }:
								begin
									case ( divider[7:6] )
										2'b00:
											begin
												sioc <= 1'b1;
											end
										2'b01:
											begin
												sioc <= 1'b1;
											end
										2'b10:
											begin
												sioc <= 1'b1;
											end
										default :
											begin
												sioc <= 1'b1;
											end
									endcase
								end
							{ 3'b111, 3'b100 }:
								begin
									case ( divider[7:6] )
										2'b00:
											begin
												sioc <= 1'b0;
											end
										2'b01:
											begin
												sioc <= 1'b0;
											end
										2'b10:
											begin
												sioc <= 1'b0;
											end
										default :
											begin
												sioc <= 1'b0;
											end
									endcase
								end
							{ 3'b110, 3'b000 }:
								begin
									case ( divider[7:6] )
									2'b00:
										begin
											sioc <= 1'b0;
										end
									2'b01:
										begin
											sioc <= 1'b1;
										end
									2'b10:
										begin
											sioc <= 1'b1;
										end
									default :
										begin
											sioc <= 1'b1;
										end
								endcase
							end
						{ 3'b100, 3'b000 }:
							begin
								case ( divider[7:6] )
									2'b00:
										begin
											sioc <= 1'b1;
										end
									2'b01:
										begin
											sioc <= 1'b1;
										end
									2'b10:
										begin
											sioc <= 1'b1;
										end
									default :
										begin
											sioc <= 1'b1;
										end
								endcase
							end
						{ 3'b000, 3'b000 }:
							begin
								case ( divider[7:6] )
									2'b00:
										begin
											sioc <= 1'b1;
										end
									2'b01:
										begin
											sioc <= 1'b1;
										end
									2'b10:
										begin
											sioc <= 1'b1;
										end
									default :
										begin
											sioc <= 1'b1;
										end
								endcase
							end
						default :
							begin
								case ( divider[7:6] )
									2'b00:
										begin
											sioc <= 1'b0;
										end
									2'b01:
										begin
											sioc <= 1'b1;
										end
									2'b10:
										begin
											sioc <= 1'b1;
										end
									default :
										begin
											sioc <= 1'b0;
										end
								endcase
							end
						endcase

			if ( divider == 8'b11111111 )
				begin
					busy_sr <= { busy_sr[30:0], 1'b0 };
					data_sr <= { data_sr[30:0], 1'b1 };
					divider <= { 1'b0 };
				end
			else
				begin
					divider <= ( divider + 1 );
				end
		end
	end
end
endmodule

