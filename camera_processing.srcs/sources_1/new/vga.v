`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/24/2021 07:26:11 PM
// Design Name: 
// Module Name: vga
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

module vga(
	input clk25,
	output clkout,
	input rez_160x120,
	input rez_320x240,
	output hsync,
	output vsync,
	output nblank,
	output activearea,
	output nsync
	);
	
localparam hm = 799;
localparam hd = 640;
localparam hf = 16;
localparam hb = 48;
localparam hr = 96;
localparam vm = 524;
localparam vd = 480;
localparam vf = 10;
localparam vb = 33;
localparam vr = 2;
reg [9:0]hcnt;
reg [9:0]vcnt;
reg activearea;
reg hsync;
reg vsync;
reg video;

always @ ( posedge clk25)
	begin
		if ( clk25 )
			begin
				if ( hcnt == 799 )
					begin
						hcnt <= 10'b0000000000;
						if ( vcnt == 524 )
							begin
								vcnt <= 10'b0000000000;
								activearea <= 1'b1;
							end
						else
							begin
								if ( rez_160x120 == 1'b1 )
									begin
										if ( vcnt < ( 120 - 1 ) )
											begin
												activearea <= 1'b1;
											end
									end
								else
									begin
										if ( rez_320x240 == 1'b1 )
											begin
												if ( vcnt < ( 240 - 1 ) )
													begin
														activearea <= 1'b1;
													end
											end
										else
											begin
												if ( vcnt < ( 480 - 1 ) )
													begin
														activearea <= 1'b1;
													end
											end
									end
									vcnt <= ( vcnt + 1 );
							end
					end
				else
					begin
						if ( rez_160x120 == 1'b1 )
							begin
								if ( hcnt == ( 160 - 1 ) )
									begin
										activearea <= 1'b0;
									end
							end
						else
							begin
								if ( rez_320x240 == 1'b1 )
									begin
										if ( hcnt == ( 320 - 1 ) )
											begin
												activearea <= 1'b0;
											end
									end
								else
									begin
										if ( hcnt == ( 640 - 1 ) )
											begin
												activearea <= 1'b0;
											end
									end
							end
							hcnt <= ( hcnt + 1 );
					end
			end
	end


always @ ( posedge clk25)
	begin
		if ( clk25 )
			begin
				if ( ( hcnt >= ( 640 + 16 ) ) & ( hcnt <= ( 640 - 1 ) ) )
					begin
						hsync <= 1'b0;
					end
				else
					begin
						hsync <= 1'b1;
					end
			end
	end


always @ ( posedge clk25)
	begin
		if ( clk25 )
			begin
				if ( ( vcnt >= ( 480 + 10 ) ) & ( vcnt <= ( 480 - 1 ) ) )
					begin
						vsync <= 1'b0;
					end
				else
					begin
						vsync <= 1'b1;
					end
			end
	end
	
assign nsync = 1'b1;

always @ ( hcnt or vcnt)
	begin
		if ( ( hcnt < 640 ) & ( vcnt < 480 ) )
			begin
				video <= 1'b1;
			end
		else
			begin
				if ( 1 ) 
					begin
						video <= 1'b0;
					end
			end
	end
assign nblank = video;
assign clkout = clk25;

endmodule

