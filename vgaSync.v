`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2024 03:31:37 PM
// Design Name: 
// Module Name: vgaSync
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

module vgaSync (input clk, reset, output reg hsync, vsync, output wire display_on, output reg [9:0] hpos, vpos);

// VGA 640x480 @ 60Hz timing parameters
parameter H_DISPLAY = 640; // Horizontal display width (visible area)
parameter H_FRONT = 16;    // Horizontal front porch
parameter H_SYNC = 96;     // Horizontal sync pulse width
parameter H_BACK = 48;     // Horizontal back porch

parameter V_DISPLAY = 480; // Vertical display height (visible area)
parameter V_FRONT = 10;    // Vertical front porch
parameter V_SYNC = 2;      // Vertical sync pulse width
parameter V_BACK = 33;     // Vertical back porch

parameter H_SYNC_START = H_DISPLAY + H_FRONT;
parameter H_SYNC_END = H_SYNC_START + H_SYNC - 1;
parameter H_MAX = H_DISPLAY + H_FRONT + H_SYNC + H_BACK - 1;

parameter V_SYNC_START = V_DISPLAY + V_BACK;
parameter V_SYNC_END = V_SYNC_START + V_SYNC - 1;
parameter V_MAX = V_DISPLAY + V_FRONT + V_SYNC + V_BACK - 1;

// Horizontal and vertical position counters
always @(posedge clk or posedge reset) begin
    if (reset)
        hpos <= 0;
    else if (hpos == H_MAX)
        hpos <= 0;
    else
        hpos <= hpos + 1;
end

always @(posedge clk or posedge reset) begin
    if (reset)
        vpos <= 0;
    else if (hpos == H_MAX) begin
        if (vpos == V_MAX)
            vpos <= 0;
        else
            vpos <= vpos + 1;
    end
end

// Sync signals
always @(posedge clk or posedge reset) begin
    if (reset)
        hsync <= 1;
    else
        hsync <= ~(hpos >= H_SYNC_START && hpos <= H_SYNC_END);
end

always @(posedge clk or posedge reset) begin
    if (reset)
        vsync <= 1;
    else
        vsync <= ~(vpos >= V_SYNC_START && vpos <= V_SYNC_END);
end

// Display enable
assign display_on = (hpos < H_DISPLAY) && (vpos < V_DISPLAY);

endmodule

