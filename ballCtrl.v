`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2024 11:54:47 AM
// Design Name: 
// Module Name: ballCtrl
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


module ballCtrl(input clk, reset, vCol, hCol, enable, output [9:0] xCoord, output [8:0] yCoord);

    reg vDirection=0;
    reg hDirection=0;
    
    counter_x_bit #(9,480) vcount(clk, reset, enable, vDirection, yCoord);
    counter_x_bit #(10,640) hcount(clk, reset, enable, hDirection, xCoord);
    
    always @(posedge vCol) begin
        vDirection <= ~vDirection;
    end
    always @(posedge hCol) begin
        hDirection <= ~hDirection;
    end
    
endmodule
