`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2024 05:07:18 PM
// Design Name: 
// Module Name: clockDivider
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


module clockDivider #(parameter n = 50000000)(input clk, reset, enable, output reg clk_out);
wire [31:0] count;
// Big enough to hold the maximum possible value
// Increment count
counter_x_bit #(32, n) counterMod (.clk(clk), .reset(reset), .enable(1'b1), .count(count));
// Handle the output clock
always @ (posedge clk, posedge reset) begin
    if (reset) // Asynchronous Reset
        clk_out <= 0;
    else if (count == n-1)
        clk_out <= ~ clk_out;
end
always @(posedge clk or posedge reset) begin
    if (reset)
        $display("ClockDivider: Reset activated.");
    else
        $display("Time: %0t | clk: %b | clk_out: %b", $time, clk, clk_out);
end

endmodule

