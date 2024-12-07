`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2024 04:10:50 PM
// Design Name: 
// Module Name: debouncer
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

module debouncer(input clk, rst, in, output out);
reg q1,q2,q3;
always@(posedge clk, posedge rst) begin
if(rst == 1'b1) begin
q1 <= 0;
q2 <= 0;
q3 <= 0;
end
else begin
q1 <= in;
q2 <= q1;
q3 <= q2;
end
end
assign out = (rst) ? 0 : q1&q2&q3;
endmodule

