`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2021 02:08:17 PM
// Design Name: 
// Module Name: camera_processing
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


module camera_processing(

    );
endmodule

module top_level(
	input clk100,
	input btnl,
	input btnc,
	input btnr,
	output config_finished,
	output vga_hsync,
	output vga_vsync,
	output [3:0]vga_r,
	output [3:0]vga_g,
	output [3:0]vga_b,
	input ov7670_pclk,
	output ov7670_xclk,
	input ov7670_vsync,
	input ov7670_href,
	input [7:0]ov7670_data,
	output ov7670_sioc,
	inout ov7670_siod,
	output ov7670_pwdn,
	output ov7670_reset
	);

wire clk_camera;
wire clk_vga;
wire [0:0]wren;
wire resend;
wire nblank;
wire vsync;
wire nsync;
wire [18:0]wraddress;
wire [11:0]wrdata;
wire [18:0]rdaddress;
wire [11:0]rddata;
wire [7:0]red;
wire [7:0]green;
wire [7:0]blue;
wire activearea;
wire rez_160x120;
wire rez_320x240;
wire [1:0]size_select;
reg [16:0]rd_addr;
reg [16:0]wr_addr;
assign vga_r = red[7:4];
assign vga_g = green[7:4];
assign vga_b = blue[7:4];
assign rez_160x120 = btnl;
assign rez_320x240 = btnr;

clocking your_instance_name ( .clk_100(clk100), .clk_25(clk_vga), .clk_50(clk_camera));

assign vga_vsync = vsync;

vga inst_vga( .clk25(clk_vga), 
		      .nblank(nblank), 
		      .rez_160x120(rez_160x120), 
		      .rez_320x240(rez_320x240), 
		      .vsync(vsync),
		      .activearea(activearea), 
		      .clkout( ), 
		      .hsync(vga_hsync), 
		      .nsync(nsync) );

debounce inst_debounce( 
              .clk(clk_vga), 
              .i(btnc), 
              .o(resend));

ov7670_controller inst_ov7670_controller(
              .clk(clk_camera), 
              .resend(resend), 
              .config_finished(config_finished), 
              .pwdn(ov7670_pwdn),
              .reset(ov7670_reset), 
              .sioc(ov7670_sioc), 
              .xclk(ov7670_xclk), 
              .siod(ov7670_siod) );

assign size_select = { btnl, btnr };

always @ ( size_select)
     begin
           if ( size_select == 2'b00 )
               begin
                    rd_addr <= rdaddress[18:2];
                end
           else
                begin
                   if ( size_select == 2'b01 )
                      begin
                          rd_addr <= rdaddress[16:0];
                      end
                   else
                      begin
                         if ( size_select == 2'b10 )
                            begin
                               rd_addr <= rdaddress[16:0];
                            end
                         else
                            begin
                               if ( size_select == 2'b11 )
                                  begin
                                     rd_addr <= rdaddress[16:0];
                                  end
                            end
                        end
                  end
           end

always @ ( size_select)
    begin
        if ( size_select == 2'b00 )
           begin
                wr_addr <= wraddress[18:2];
           end
       else
           begin
               if ( size_select == 2'b01 )
                   begin
                       wr_addr <= wraddress[16:0];
                   end
               else
                   begin
                       if ( size_select == 2'b10 )
                          begin
                              wr_addr <= wraddress[16:0];
                          end
                       else
                          begin
                              if ( size_select == 2'b11 )
                                  begin
                                     wr_addr <= wraddress[16:0];
                                  end
                           end
                    end
              end
     end

frame_buffer inst_frame_buffer( 
               .addra(wr_addr), 
               .addrb(rd_addr), 
               .clka(ov7670_pclk), 
               .clkb(clk_vga),
               .dina(wrdata), 
               .wea(wren), 
               .doutb(rddata));


ov7670_capture inst_ov7670_capture(
               .d(ov7670_data),
               .href(ov7670_href),
               .pclk(ov7670_pclk),
               .rez_160x120(rez_160x120),
               .rez_320x240(rez_320x240),
               .vsync(ov7670_vsync),
               .addr(wraddress),
               .dout(wrdata),
               .we(wren[0]));

rgb inst_rgb(
          .din(rddata),
          .nblank(activearea),
          .b(blue),
          .g(green),
          .r(red));

address_generator inst_address_generator(
          .clk25(clk_vga),
          .enable(activearea),
          .rez_160x120(rez_160x120),
          .rez_320x240(rez_320x240),
          .vsync(vsync),
          .address(rdaddress));
endmodule

