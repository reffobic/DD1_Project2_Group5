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

module display (input clk, reset, p1up, p1down, p2up, p2down, dark, enable, output reg [3:0] r, g, b, output hsync, vsync, output [0:6] segments, output [3:0] anode_active);

parameter paddleHeight = 150;
parameter paddleWidth = 5;
parameter ball_radius = 5;

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

wire [8:0] p1coordinate;
wire [8:0] p2coordinate;

paddleCtrl paddle1 (.clk(clk_out), .reset(reset), .pushup(p1up), .pushdown(p1down), .vpos(480), .coord(p1coordinate));
paddleCtrl paddle2 (.clk(clk_out), .reset(reset), .pushup(p2up), .pushdown(p2down), .vpos(480), .coord(p2coordinate));

wire [9:0] ball_xCoord;
wire [8:0] ball_yCoord;
reg vCol, hCol;
wire ball_clk;
wire [1:0] score;

clockDivider #(50000) clkdivBall (.clk(clk_out), .reset(reset), .enable(enable), .clk_out(ball_clk));
ballCtrl ball (.clk(ball_clk), .reset(reset),.vCol(vCol),.hCol(hCol), .enable(enable),  .xCoord(ball_xCoord), .yCoord(ball_yCoord),.score(score));

wire [11:0] ballColours;
wire [11:0] paddleColours;
wire [11:0] backgroundColours;
reg [3:0] p1Score = 4'b0000;
reg [3:0] p2Score = 4'b0000;

assign ballColours = dark ? 12'b111100000000 : 12'b111110100100;
assign paddleColours = dark ? 12'b111111111111 : 12'b111110100100;
assign backgroundColours  = dark ? 12'b000000000000 : 12'b011010101111;

always @(posedge clk_out) begin
    if (reset) begin
        vCol <= 1'b1;
        hCol <= 1'b1;
        p1Score <= 4'b0000; // Reset P1 score
        p2Score <= 4'b0000; // Reset P2 score
    end else if (
    (ball_xCoord >= 30 && ball_xCoord <= 30 + paddleWidth + ball_radius &&
     ((ball_yCoord + ball_radius >= p1coordinate) || (ball_yCoord - ball_radius >= p1coordinate)) &&
     ((ball_yCoord + ball_radius <= p1coordinate + (paddleHeight / 2)) || (ball_yCoord - ball_radius <= p1coordinate + (paddleHeight / 2))))
    ||
    (ball_xCoord + ball_radius >= 602 && ball_xCoord - ball_radius <= 602 + paddleWidth &&
     ((ball_yCoord + ball_radius >= p2coordinate) || (ball_yCoord - ball_radius >= p2coordinate)) &&
     ((ball_yCoord + ball_radius <= p2coordinate + (paddleHeight / 2)) || (ball_yCoord - ball_radius <= p2coordinate + (paddleHeight / 2))))
    )begin
        hCol <= 1'b1;
    end else if (ball_yCoord <= ball_radius || ball_yCoord >= 480 - ball_radius) begin
        vCol <= 1'b1;
    end else begin
        hCol <= 0;
        vCol <= 0;
   end
end

always @(posedge clk_out or posedge reset) begin
    if (reset) begin
        p1Score <= 4'b0000;
        p2Score <= 4'b0000;
    end else if (score == 2'b01) begin
        p1Score <= p1Score + 1;
    end else if (score == 2'b10) begin
        p2Score <= p2Score + 1;
    end
end

// Seven-Segment Display Control
reg [1:0] en; // Enables each digit sequentially
reg [3:0] current_num; // The number to display on the active digit

always @(posedge clk_out) begin
    en <= en + 1;
end

// Assign numbers for the seven-segment display
always @* begin
    case (en)
        2'b00: current_num = p1Score; // P1 Score on left digit
        2'b01: current_num = 4'b0000; // Blank for unused digit
        2'b10: current_num = p2Score; // P2 Score on right digit
        2'b11: current_num = 4'b0000; // Blank for unused digit
        default: current_num = 4'b0000;
    endcase
end

SevenSegDecWithEn sevenSeg (
    .en(en),
    .num(current_num),
    .segments(segments),
    .anode_active(anode_active)
);

reg [10:0] addr;
wire [7:0] data;
ascii_rom rom (.clk(clk_out), .addr(addr), .data(data));

// Render score digits
always @(posedge clk_out or posedge reset) begin
    if (reset) begin
        r <= 4'b0000;
        g <= 4'b0000;
        b <= 4'b0000;
    end else if (display_on) begin
        if (hpos >= 30 && hpos <= 30+paddleWidth && vpos >= p1coordinate && vpos <= p1coordinate+(paddleHeight/2)) begin
            r <= paddleColours[11:8]; 
            g <= paddleColours[7:4];
            b <= paddleColours[3:0];
        end else if (hpos >= 600 && hpos <= 600+paddleWidth && vpos >= p2coordinate && vpos <= p2coordinate+(paddleHeight/2)) begin
            r <= paddleColours[11:8]; 
            g <= paddleColours[7:4];
            b <= paddleColours[3:0];
        end else if ((hpos - ball_xCoord) * (hpos - ball_xCoord) + (vpos - ball_yCoord) * (vpos - ball_yCoord) <= (ball_radius * ball_radius)) begin
            r <= ballColours[11:8]; 
            g <= ballColours[7:4];
            b <= ballColours[3:0];
        end else if (hpos >= 30 && hpos < 46 && vpos >= 21 && vpos < 35) begin
            addr <= {4'b0011, p1Score, vpos[3:0] - 21}; // Compute ROM address for Player 1
            if (data[7 - (hpos - 30)]) begin
                // Highlight pixel for Player 1 score
                r <= 4'b1111; // White color for text
                g <= 4'b1111;
                b <= 4'b1111;
            end else begin
                // Background color for non-score area
                r <= 10;
                g <= 10;
                b <= 10;
            end
        end 
        // Player 2 Score Display Region
        else if (hpos >= 601 && hpos < 617 && vpos >= 21 && vpos < 35) begin
            addr <= {4'b0011, p2Score, vpos[3:0] - 21}; // Compute ROM address for Player 2
            if (data[7 - (hpos - 601)]) begin
                // Highlight pixel for Player 2 score
                r <= 4'b1111; // White color for text
                g <= 4'b1111;
                b <= 4'b1111;
            end else begin
                // Background color for non-score area
                r <= backgroundColours[11:8];
                g <= backgroundColours[7:4];
                b <= backgroundColours[3:0];
            end
        end else begin
            r <= backgroundColours[11:8];
            g <= backgroundColours[7:4];
            b <= backgroundColours[3:0];
        end
    end else begin
        r <= 4'b0000;
        g <= 4'b0000;
        b <= 4'b0000;
    end
end


endmodule
