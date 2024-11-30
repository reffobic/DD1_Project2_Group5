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

module paddleCount #(parameter x = 9, n = 480, s = 200)(input clk, reset, enable, updown, output reg [x-1:0] count);
    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= n/2;
        else if (enable) begin
            if (count == n-(100))
                count <= count -1;
            else if (count == 0)
                count <= count + 1;
            else if(updown)
                count <= count + 1;
            else
                count <= count - 1;
        end
    end
endmodule

module paddleCtrl(input clk, reset, pushup, pushdown, vpos, output [8:0] coord);

wire upwire, downwire;
debouncer deb1(.clk(clk), .rst(reset), .in(pushup), .out(upwire));
debouncer deb2(.clk(clk), .rst(reset), .in(pushdown), .out(downwire));

wire clk_out;
clockDivider #(100000) clkdiv (.clk(clk), .reset(reset), .enable(1'b1), .clk_out(clk_out));

wire countEn;
assign countEn = pushup ^ pushdown;

paddleCount #(9,480) vcount(clk_out, reset, countEn, upwire, coord);

endmodule
