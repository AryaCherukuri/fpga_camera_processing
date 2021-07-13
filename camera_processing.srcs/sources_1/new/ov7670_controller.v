`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/24/2021 11:35:45 AM
// Design Name: 
// Module Name: ov7670_controller
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


module ov7670_controller(
input clk,
input resend,
output config_finished,
output sioc,
inout siod,
output reset,
output pwdn,
output xclk
);
wire [15:0]command;
wire finished = 1'b0;
wire taken = 1'b0;
wire send;
localparam camera_address = 7'b1000010;
reg sys_clk;
assign config_finished = finished;
assign send = ~( finished);
    i2c_sender inst_i2c_sender (
        .clk(clk),
        .id(7'b1000010),
        .reg1(command[15:8]),
        .send(send),
        .value(command[7:0]),
        .sioc(sioc),
        .taken(taken), 
        .siod(siod)
);
assign reset = 1'b1;
assign pwdn = 1'b0;
assign xclk = sys_clk;
       ov7670_registers inst_ov7670_registers (
        .advance(taken),
        .clk(clk),
        .resend(resend),
        .command(command),
        .finished(finished)
);
always @ ( posedge clk)
    begin
        if ( clk == 1'b1 )
            begin
                sys_clk <= ~( sys_clk);
            end
    end
endmodule