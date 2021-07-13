`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/24/2021 04:37:53 PM
// Design Name: 
// Module Name: ov7670_axi_stream_capture
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


module ov7670_axi_stream_capture(
input pclk,
input vsync,
input href,
input [7:0]d,
output m_axis_tvalid,
input m_axis_tready,
output m_axis_tlast,
output [31:0]m_axis_tdata,
output m_axis_tuser,
output aclk
);
    reg [18:0]address;
    reg [1:0]line;
    reg href_hold;
    reg [15:0]d_latch;
    reg we_reg;
    reg [6:0]href_last;
    reg eol;
    reg sof;
    reg [7:0]latched_d;
    reg latched_href;
    reg latched_vsync;
    assign m_axis_tdata = { 8'b11111111, d_latch[11] };
    assign m_axis_tvalid = we_reg;
    assign m_axis_tlast = eol;
    assign m_axis_tuser = sof;
    assign aclk = ~( pclk);
always @ ( negedge pclk)
    begin : capture_process
        if ( pclk == 1'b1 )
            begin
                if ( we_reg == 1'b1 )
                    begin
                        if ( ( href_hold == 1'b0 ) & ( latched_href == 1'b1 ) )
                            begin
                            case ( line )
                                2'b00:
                                    begin
                                        line <= 2'b01;
                                    end
                                2'b01:
                                    begin
                                        line <= 2'b10;
                                    end
                                2'b10:
                                    begin
                                        line <= 2'b11;
                                    end
                                        default :
                                             begin
                                                 line <= 2'b00;
                                             end
                                        endcase
                                end
href_hold <= latched_href;
    if ( latched_href == 1'b1 )
        begin
            d_latch <= { d_latch[7:0], latched_d };
        end
    we_reg <= 1'b0;
        if ( latched_vsync == 1'b1 )
            begin
                address <= { 1'b0 };
                    href_last <= { 1'b0 };
            line <= { 1'b0 };
             end
        else
            begin
                if ( href_last[0] == 1'b1 )
                    begin
                        we_reg <= 1'b1;
                        href_last <= { 1'b0 };
                    end
                else
                    begin
                        href_last <= { href_last[( - 1 ):0], latched_href };
                    end
                 end
    case ($unsigned((address) % 640  == 639)) 
        1'b1:
            begin
                eol <= 1'b1;
            end
        default :
            begin
                eol <= 1'b0;
            end
       endcase
    case ( $unsigned(address) == 0 )
        1'b1:
            begin
                sof <= 1'b1;
            end
    default :
        begin
            sof <= 1'b0;
        end
    endcase
end
    if ( pclk == 1'b0 )
        begin
            latched_d <= d;
            latched_href <= href;
            latched_vsync <= vsync;
        end
    end
endmodule