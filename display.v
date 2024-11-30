`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2024 03:57:40 PM
// Design Name: 
// Module Name: display
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


module display (input clk, reset, p1up, p1down, p2up, p2down, dark, output reg [3:0] r, g, b, output hsync, vsync);

parameter paddleHeight = 200;
parameter paddleWidth = 10;

wire clk_out;

clk_wiz_0 clk_gen (
    .clk_in1(clk),      // Input clock (100 MHz)
    .reset(reset),      // Reset signal
    .clk_out1(clk_out), // Output clock (25.175 MHz)
    .locked(locked)     // Locked signal (indicates stable clock output)
);

// Internal signals for VGA synchronization
wire display_on;
wire [9:0] hpos;
wire [9:0] vpos;

// Instantiate the VGA synchronization module
vgaSync vgaDriver (.clk(clk_out), .reset(reset), .hsync(hsync), .vsync(vsync), .display_on(display_on), .hpos(hpos), .vpos(vpos));

wire [8:0] p1coordinate;
wire [8:0] p2coordinate;

paddleCtrl paddle1 (.clk(clk_out), .reset(reset), .pushup(p1up), .pushdown(p1down), .vpos(480), .coord(p1coordinate));
paddleCtrl paddle2 (.clk(clk_out), .reset(reset), .pushup(p2up), .pushdown(p2down), .vpos(480), .coord(p2coordinate));

wire [9:0] xCoord;
wire [8:0] yCoord;
reg vCol, hCol;
wire ball_clk;
clockDivider #(100000) clkdivBall (.clk(clk_out), .reset(reset), .enable(1'b1), .clk_out(ball_clk));
ballCtrl ball (.clk(ball_clk), .reset(reset), .vCol(vCol), .hCol(hCol), .enable(1'b1), .xCoord(xCoord), .yCoord(yCoord));

wire [11:0] ballColours;
wire [11:0] paddleColours;
wire [11:0] backgroundColours;

assign ballColours = dark ? 12'b111111111111 : 12'b111110100100;
assign paddleColours = dark ? 12'b111111111111 : 12'b111110100100;
assign backgroundColours  = dark ? 12'b000000000000 : 12'b111111011101;

always @(posedge clk_out or posedge reset) begin
    if (reset) begin
        vCol <= 1'b0;
        hCol <= 1'b0;
    end else if ((xCoord >= 30 && xCoord <= 30+paddleWidth && yCoord >= p1coordinate && yCoord <= p1coordinate+(paddleHeight/2)) || (xCoord >= 600 && xCoord <= 600+paddleWidth && yCoord >= p2coordinate && yCoord <= p2coordinate+(paddleHeight/2)) ) begin
        hCol <= 1;
    end else if (yCoord == 20 || yCoord == 460) begin
        vCol <= 1;
    end else begin
        hCol <= 0;
        vCol <= 0;
   end
end


// Generate the square and background color
always @(posedge clk_out or posedge reset) begin
    if (reset) begin
        // Reset RGB outputs to black
        r <= 4'b0000;
        g <= 4'b0000;
        b <= 4'b0000;
       
    end else if (display_on) begin
        // Draw a square in the specified region
        if (hpos >= 30 && hpos <= 30+paddleWidth && vpos >= p1coordinate && vpos <= p1coordinate+(paddleHeight/2)) begin
            r <= paddleColours[11:8]; 
            g <= paddleColours[7:4];
            b <= paddleColours[3:0];
        end else if (hpos >= 600 && hpos <= 600+paddleWidth && vpos >= p2coordinate && vpos <= p2coordinate+(paddleHeight/2)) begin
            r <= paddleColours[11:8]; 
            g <= paddleColours[7:4];
            b <= paddleColours[3:0];
        end else if (hpos >= xCoord && hpos <= xCoord+20 && vpos >= yCoord && vpos <= yCoord+20) begin
            r <= ballColours[11:8]; 
            g <= ballColours[7:4];
            b <= ballColours[3:0];
        end else begin
            r <= backgroundColours[11:8];
            g <= backgroundColours[7:4];
            b <= backgroundColours[3:0];
        end
    end else begin
        // Turn off RGB outputs outside the visible area
        r <= 4'b0000;
        g <= 4'b0000;
        b <= 4'b0000;
    end
end

endmodule
