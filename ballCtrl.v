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

module ballCount #(parameter x = 9, n = 480)(input clk, reset, enable, updown, output reg [x-1:0] count);
    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= n/2;
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

module ballCtrl(input clk, reset, vCol, hCol, enable, output reg [9:0] xCoord, output reg [8:0] yCoord);

    reg vDirection=1;
    reg hDirection=1;
    
    wire [9:0] hCountOut;
    wire [8:0] vCountOut;
    
    ballCount #(9,480) vcount(clk, reset, enable, vDirection, vCountOut);
    ballCount #(10,640) hcount(clk, reset, enable, hDirection, hCountOut);
    
    always @(posedge clk) begin
        if (reset | xCoord < 30 | xCoord > 610) begin
            xCoord <= 320; // Reset to the center
            yCoord <= 240; // Reset to the center
        end else if (enable) begin
            xCoord <= hCountOut;
            yCoord <= vCountOut;
        end
    end
    
    always @(posedge vCol) begin
        vDirection <= ~vDirection;
    end
    always @(posedge hCol) begin
        hDirection <= ~hDirection;
    end
    
endmodule
