`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2024 11:30:20 AM
// Design Name: 
// Module Name: gameOverText
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


module gameOverText(input clk,
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
   assign score_on = (y >= 232) && (y < 264) && (x[9:4] < 64);
   //assign score_on = (y[9:5] == 0) && (x[9:4] < 16);
   assign row_addr_s = y[4:1];
   assign bit_addr_s = x[3:1];
   always @*
    case(x[7:4])
        4'h1 : char_addr_s = 7'h47;    //G    
        4'h2 : char_addr_s = 7'h41;     // -
        4'h3 : char_addr_s = 7'h4d;    //P2
        4'h4 : char_addr_s = 7'h45;
        4'h5 : char_addr_s = 7'h20;
        4'h6 : char_addr_s = 7'h4f;
        4'h7 : char_addr_s = 7'h56;
        4'h8 : char_addr_s = 7'h45;
        4'h9 : char_addr_s = 7'h52;
        default: char_addr_s = 7'h00;
    endcase
    
    
     always @* begin    
            if(score_on) begin
                char_addr = char_addr_s;
                row_addr = row_addr_s;
                bit_addr = bit_addr_s;
            end
        end

        assign rom_addr = {char_addr, row_addr};
        assign ascii_bit = ascii_word[~bit_addr];
endmodule
