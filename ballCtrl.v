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

module ballvCount #(parameter x = 9, n = 480)(input clk, reset, rst, enable, updown, output reg [x-1:0] count);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= n/2;
        end else if (enable) begin
            if (rst)
                count <= n/2;
            else if(updown)
                count <= count + 1;
            else
                count <= count - 1;
        end
    end
endmodule

module ballhCount #(parameter x = 10, n = 640)(input clk, reset, rst, enable, updown, output reg [x-1:0] count);
    always @(posedge clk or posedge reset) begin
        if (reset || rst) begin
            count <= n/2;
        end else if (enable) begin
            if (count == 639 || count == 1 || rst)
                count <= n/2;
            else if(updown)
                count <= count + 1;
            else
                count <= count - 1;
        end
    end
endmodule

module ballCtrl(input clk, reset, vCol, hCol, enable, output reg [9:0] xCoord, output reg [8:0] yCoord, output reg score1, score2);

    reg vDirection=1;
    reg hDirection=1;
    reg rst = 0;
    
    wire [9:0] hCountOut;
    wire [8:0] vCountOut;
    
    ballvCount #(9,480) vcount(clk, reset, rst, enable, vDirection, vCountOut);
    ballhCount #(10,640) hcount(clk, reset, rst, enable, hDirection, hCountOut);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            score1 <= 1'b0;
            score2 <= 1'b0;
        end else if (hCountOut <= 20) begin
            score2 <= 1'b1; // P2 scores
        end else if (hCountOut >= 620) begin
            score1<= 1'b1; // P1 scores
        end else begin
            score1 <= 1'b0;
            score2 <= 1'b0;
        end
    end
   
    always @(posedge clk) begin
        if (reset || xCoord < 1 || xCoord > 639) begin
            xCoord <= 320;
            yCoord <= 240;
            rst <=1;
        end else if (enable) begin
            xCoord <= hCountOut;
            yCoord <= vCountOut;
            rst <=0;
        end
    end
    
    always @(posedge vCol) begin
        vDirection <= ~vDirection;
    end
    always @(posedge hCol) begin
        hDirection <= ~hDirection;
    end
    
endmodule
