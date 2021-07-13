`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/24/2021 11:03:16 AM
// Design Name: 
// Module Name: ov7670_capture
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
/*----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz>
-- 
-- Description: Captures the pixels coming from the OV7670 camera and Stores them 
--              in block RAM.
--
-- The length of href last controls how often pixels are captive - (2 downto 0) stores
-- one pixel every 4 cycles.
--
-- "line" is used to control how often data is captured. In this case every forth 
-- line
----------------------------------------------------------------------------------
*/
module ov7670_capture(
	input pclk,
	input rez_160x120,
	input rez_320x240,
	input vsync,
	input href,
	input [7:0]d,
	output [18:0]addr,
	output [11:0]dout,
	output we
	);
	
reg [18:0]address;
reg [1:0]line;
reg href_hold;
reg [15:0]d_latch;
reg we_reg;
reg [6:0]href_last;
reg [7:0]latched_d;
reg latched_href;
reg latched_vsync;

assign addr = address;
assign we   = we_reg;
assign dout = { d_latch[15:12], d_latch[4:1] };

always @ (pclk)
	begin : capture_process
		if ( pclk == 1'b1 ) begin
			if ( we_reg == 1'b1 ) begin	address <= ($unsigned(address) + 1 );	end
			if ( ( href_hold == 1'b0 ) & ( latched_href == 1'b1 ) ) begin
				case ( line )
					2'b00: 	begin	line <= 2'b01;	end
					2'b01: 	begin	line <= 2'b10;	end
					2'b10:	begin	line <= 2'b11;	end
					default : begin	line <= 2'b00;	end
				endcase
			end
			href_hold <= latched_href;
			if ( latched_href == 1'b1 ) begin	d_latch <= { d_latch[7:0], latched_d }; 	end
			we_reg <= 1'b0;
			if ( latched_vsync == 1'b1 ) begin
				address <= { 1'b0 };
				href_last <= { 1'b0 };
				line <= { 1'b0 };
			end
			else begin
				if (((( rez_160x120 == 1'b1 ) & (href_last[6] == 1'b1))   | 
				     (( rez_320x240 == 1'b1 ) & ( href_last[2] == 1'b1))) | 
				    ((( rez_160x120 == 1'b0 ) & ( rez_320x240 == 1'b0 )) & (href_last[0] == 1'b1))) begin
					if ( rez_160x120 == 1'b1 )	begin
						if ( line == 2'b10 )  begin	we_reg <= 1'b1; end
					end
					else begin
						if ( rez_320x240 == 1'b1 )	begin
							if ( line[1] == 1'b1 )	begin we_reg <= 1'b1; end
						end
						else begin we_reg <= 1'b1; end
					end
					href_last <= { 1'b0 };
				end
				else begin href_last <= { href_last[5:0], latched_href }; end
			end
		end
		if ( pclk == 1'b0 )	begin
			latched_d <= d;
			latched_href <= href;
			latched_vsync <= vsync;
		end
	end
endmodule


