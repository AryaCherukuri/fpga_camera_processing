`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/24/2021 11:25:40 AM
// Design Name: 
// Module Name: ov7670_vga
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


module ov7670_vga(
input clk25,
output [4:0]vga_red,
output [5:0]vga_green,
output [4:0]vga_blue,
output vga_hsync,
output vga_vsync,
output [17:0]frame_addr,
input [11:0]frame_pixel
);
    localparam hrez = 640;
    localparam hstartsync = ( 640 + 16 );
    localparam hendsync = ( 640 + 96 );
    localparam hmaxcount = 800;
    localparam vrez = 480;
    localparam vstartsync = ( 480 + 10 );
    localparam vendsync = ( 480 + 2 );
    localparam vmaxcount = ( 480 + 33 );
    localparam hsync_active = 1'b0;
    localparam vsync_active = 1'b0;
    reg [9:0]hcounter;
    reg [9:0]vcounter;
    reg [4:0]vga_red;
    reg [5:0]vga_green;
    reg [4:0]vga_blue;
    reg [18:0]address;
    reg blank;
    reg vga_hsync;
    reg vga_vsync;
assign frame_addr = address[18:1];
always @ ( posedge clk25)
    begin
        if ( clk25 == 1'b1 )
            begin
                if ( hcounter == ( 800 - 1 ) )
                    begin
                        hcounter <= { 1'b0 };
                            if ( vcounter == ( ( 480 + 33 ) - 1 ) )
                                begin
                                    vcounter <= { 1'b0 };
                                end
                            else
                                begin
                                    vcounter <= ( vcounter + 1 );
                       end
                end
                       else
                            begin
                                hcounter <= ( hcounter + 1 );
                            end
                                if ( blank == 1'b0 )
                                    begin
                                        vga_red <= { frame_pixel[11:8], 1'b0 };
                                        vga_green <= { frame_pixel[7:4], 2'b00 };
                                        vga_blue <= { frame_pixel[3:0], 1'b0 };
                                    end
                            else
                                    begin
                                        vga_red <= { 1'b0 };
                                        vga_green <= { 1'b0 };
                                        vga_blue <= { 1'b0 };
                                    end
                                        if ( vcounter >= 480 )
                                            begin
                                                address <= { 1'b0 };
                                                blank <= 1'b1;
                                            end
                                    else
                                            begin
                                                if ( hcounter < 640 )
                                                    begin
                                                        blank <= 1'b0;
                                                        address <= ( address + 1 );
                                                    end
                                                else
                                                    begin
                                                        blank <= 1'b1;
                                                    end
                                            end
                                                if ( ( hcounter > ( 640 + 16 ) ) & ( hcounter <= ( 640 + 96 ) ) )
                                                    begin
                                                        vga_hsync <= 1'b0;
                                                    end
                                                else
                                                    begin
                                                        vga_hsync <= ~( 1'b0);
                                                    end
                                                        if ( ( vcounter >= ( 480 + 10 ) ) & ( vcounter < ( 480 + 2 ) ) )
                                                            begin
                                                                vga_vsync <= 1'b0;
                                                            end
                                                        else
                                                            begin
                                                                vga_vsync <= ~( 1'b0);
                                                            end
                                                    end
                                            end
endmodule
