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


module display (input clk, reset, output reg [3:0] r, g, b, output hsync, vsync);

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

// Generate the square and background color
always @(posedge clk_out or posedge reset) begin
    if (reset) begin
        // Reset RGB outputs to black
        r <= 4'b0000;
        g <= 4'b0000;
        b <= 4'b0000;
    end else if (display_on) begin
        // Draw a square in the specified region
        if (hpos >= 80 && hpos <= 176 && vpos >= 60 && vpos <= 180) begin
            r <= 4'b0000; // blue color
            g <= 4'b0000;
            b <= 4'b1111;
        end else begin
            // Background color (red)
            r <= 4'b1111;
            g <= 4'b0000;
            b <= 4'b0000;
        end
    end else begin
        // Turn off RGB outputs outside the visible area
        r <= 4'b0000;
        g <= 4'b0000;
        b <= 4'b0000;
    end
end

endmodule

