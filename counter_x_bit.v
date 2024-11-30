`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2024 04:58:03 PM
// Design Name: 
// Module Name: counter_x_bit
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


module counter_x_bit #(parameter x = 9, n = 480)(input clk, reset, enable, updown, output reg [x-1:0] count);
    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= n;
        else if (enable) begin
            if (count == n-1)
                count <= 0;
            else if(updown)
                count <= count + 1;
            else
                count <= count - 1;
        end
    end
endmodule
