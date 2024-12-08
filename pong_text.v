`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2024 06:51:52 PM
// Design Name: 
// Module Name: pong_text
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


module pong_text(
    input clk,
    input [3:0] dig0, dig1,
    input [9:0] x, y,
    output ascii_bit);
    
    // signal declaration
    wire [10:0] rom_addr;
    reg [6:0] char_addr, char_addr_s;
    reg [3:0] row_addr;
    wire [3:0] row_addr_s;
    reg [2:0] bit_addr;
    wire [2:0] bit_addr_s;
    wire [7:0] ascii_word;
    wire score_on;
    wire [7:0] rule_rom_addr;
    
   // instantiate ascii rom
   ascii_rom ascii_unit(.clk(clk), .addr(rom_addr), .data(ascii_word));
   
   // ---------------------------------------------------------------------------
   // score region
   // - display two-digit score and ball # on top left
   // - scale to 16 by 32 text size
   // - line 1, 16 chars: "Score: dd Ball: d"
   // ---------------------------------------------------------------------------
   assign score_on = (y >= 32) && (y < 64) && (x[9:4] < 16);
   //assign score_on = (y[9:5] == 0) && (x[9:4] < 16);
   assign row_addr_s = y[4:1];
   assign bit_addr_s = x[3:1];
   always @*
    case(x[7:4])
        4'h6 : char_addr_s = {3'b011, dig1};    //P1
        4'h7 : char_addr_s = 7'h2d;     // -
        4'h8 : char_addr_s = {3'b011, dig0};    //P2
        default: char_addr_s = 7'h00;
    endcase
    
    
     always @* begin    
            if(score_on) begin
                char_addr = char_addr_s;
                row_addr = row_addr_s;
                bit_addr = bit_addr_s;
            end
        end

        assign rom_addr = {char_addr, row_addr[3:0]}; // Limit row_addr range
    assign ascii_bit = ascii_word[~(bit_addr & 3'b111)]; // Limit bit_addr range

        
endmodule
