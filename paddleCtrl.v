`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2024 01:51:02 PM
// Design Name: 
// Module Name: paddleCtrl
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


module paddleCtrl(input clk, reset, pushup, pushdown, vpos, output [8:0] coord);

wire upwire, downwire;
debouncer deb1(.clk(clk), .rst(reset), .in(pushup), .out(upwire));
debouncer deb2(.clk(clk), .rst(reset), .in(pushdown), .out(downwire));

wire clk_out;
clockDivider #(100000) clkdiv (.clk(clk), .reset(reset), .enable(1'b1), .clk_out(clk_out));

wire countEn;
assign countEn = pushup ^ pushdown;

counter_x_bit #(9,480) vcount(clk_out, reset, countEn, upwire, coord);

endmodule
