`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/24/2021 08:03:46 PM
// Design Name: 
// Module Name: ov7670_registers
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


module ov7670_registers(
	input clk,
	input resend,
	input advance,
	output [15:0]command,
	output finished
	);
reg finished;
reg [7:0]address;
reg [15:0]sreg;
assign command = sreg;

always @ ( sreg)
	begin
		if ( sreg == 16'b1111111111111111 ) begin
				finished <= 1'b1;
			end
		else 
			begin
				finished <= 1'b0;
			end
	end

always @ ( posedge clk)
	begin
		if ( clk == 1'b1 )
			begin
				if ( resend == 1'b1 )
					begin
						address <= { 1'b0 };
					end
				else
					begin
						if ( advance == 1'b1 )
							begin
								address <= ( $unsigned(address) + 1 );
							end
					end
				case ( address )
					2'b00:
						begin
							sreg <= 13'b1001010000000;
						end
					2'b01:
						begin
							sreg <= 13'b1001010000000;
						end
					2'b10:
						begin
							sreg <= 13'b1001000000100;
						end
					2'b11:
						begin
							sreg <= 4'b1100;
						end
					3'b100:
						begin
							sreg <= 12'b110000000000;
						end
					3'b101:
						begin
							sreg <= 14'b11111000000000;
						end
					3'b110:
						begin
							sreg <= 16'b1000110000000000;
						end
					3'b111:
						begin
							sreg <= 11'b10000000000;
						end
					4'b1000:
						begin
							sreg <= 15'b100000000010000;
						end
					4'b1001:
						begin
							sreg <= 14'b11101000000100;
						end
					4'b1010:
						begin
							sreg <= 13'b1010000111000;
						end
					4'b1011:
						begin
							sreg <= 15'b100111110110011;
						end
					4'b1100:
						begin
							sreg <= 15'b101000010110011;
						end
					4'b1101:
						begin
							sreg <= 15'b101000100000000;
						end
					4'b1110:
						begin
							sreg <= 15'b101001000111101;
						end
					4'b1111:
						begin
							sreg <= 15'b101001110100111;
						end
					2'b10:
						begin
							sreg <= 15'b101010011100100;
						end
					2'b11:
						begin
							sreg <= 15'b101100010011110;
						end
					5'b10010:
						begin
							sreg <= 14'b11110111000000;
						end
					5'b10011:
						begin
							sreg <= 4'b1100;
						end
					5'b10100:
						begin
							sreg <= 13'b1011100010001;
						end
					5'b10101:
						begin
							sreg <= 13'b1100001100001;
						end
					5'b10110:
						begin
							sreg <= 14'b11001010100100;
						end
					5'b10111:
						begin
							sreg <= 13'b1100100000011;
						end
					5'b11000:
						begin
							sreg <= 13'b1101001111011;
						end
					5'b11001:
						begin
							sreg <= 10'b1100001010;
						end
					5'b11010:
						begin
							sreg <= 12'b111001100001;
						end
					5'b11011:
						begin
							sreg <= 12'b111101001011;
						end
					5'b11100:
						begin
							sreg <= 13'b1011000000010;
						end
					5'b11101:
						begin
							sreg <= 13'b1111000110111;
						end
					5'b11110:
						begin
							sreg <= 14'b10000100000010;
						end
					5'b11111:
						begin
							sreg <= 14'b10001010010001;
						end
					6'b100000:
						begin
							sreg <= 14'b10100100000111;
						end
					6'b100001:
						begin
							sreg <= 14'b11001100001011;
						end
					6'b100010:
						begin
							sreg <= 14'b11010100001011;
						end
					6'b100011:
						begin
							sreg <= 14'b11011100011101;
						end
					6'b100100:
						begin
							sreg <= 14'b11100001110001;
						end
					6'b100101:
						begin
							sreg <= 14'b11100100101010;
						end
					6'b100110:
						begin
							sreg <= 14'b11110001111000;
						end
					6'b100111:
						begin
							sreg <= 15'b100110101000000;
						end
					6'b101000:
						begin
							sreg <= 15'b100111000100000;
						end
					6'b101001:
						begin
							sreg <= 15'b110100100000000;
						end
					6'b101010:
						begin
							sreg <= 15'b110101101001010;
						end
					6'b101011:
						begin
							sreg <= 15'b111010000010000;
						end
					6'b101100:
						begin
							sreg <= 16'b1000110101001111;
						end
					6'b101101:
						begin
							sreg <= 16'b1000111000000000;
						end
					6'b101110:
						begin
							sreg <= 16'b1000111100000000;
						end
					6'b101111:
						begin
							sreg <= 16'b1001000000000000;
						end
					6'b110000:
						begin
							sreg <= 16'b1001000100000000;
						end
					6'b110001:
						begin
							sreg <= 16'b1001011000000000;
						end
					6'b110010:
						begin
							sreg <= 16'b1001101000000000;
						end
					6'b110011:
						begin
							sreg <= 16'b1011000010000100;
						end
					6'b110100:
						begin
							sreg <= 16'b1011000100001100;
						end
					6'b110101:
						begin
							sreg <= 16'b1011001000001110;
						end
					6'b110110:
						begin
							sreg <= 16'b1011001110000010;
						end
					6'b110111:
						begin
							sreg <= 16'b1011100000001010;
						end
					default :
						begin
							sreg <= 16'b1111111111111111;
						end
				endcase
		end
	end
endmodule








