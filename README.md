# Pong Game

## Pong Game FPGA Implementation
This project implements a classic Pong game using Verilog HDL on an FPGA platform. The game features real-time interaction, dynamic visuals, and modular design principles, providing an engaging and customizable experience.

## Features

- **VGA Display**: Outputs game visuals at 640x480 resolution with 60Hz refresh rate.
- **Dynamic Gameplay**: Real-time paddle and ball motion with collision detection and scorekeeping.
- **Text Rendering**: Displays player scores and "Game Over" messages using ASCII ROM.
- **Customization**: Supports dark mode for visual preferences.
- **Seven-Segment Display**: Shows live scores for both players.

## Modules Overview

1. **`display`**  
   Integrates all visual components, including paddle and ball rendering, score display, VGA synchronization, and game state updates.

2. **`vgaSync`**  
   Generates VGA synchronization signals, managing horizontal and vertical timing.

3. **`paddleCtrl`**  
   Handles paddle movement with input debouncing, clock division, and boundary enforcement.

4. **`ballCtrl`**  
   Manages ball motion, collision detection, scoring logic, and position updates.

5. **`pong_text` and `gameOverText`**  
   Render text for player scores and "Game Over" messages using ASCII ROM.

6. **Clock Modules**  
   Divides the clock frequency for VGA timing, paddle control, ball movement, and seven-segment displays.

## Setup and Requirements
### Hardware
- FPGA board (e.g., Basys 3)
- VGA display compatible with 640x480 resolution
- Input devices for paddle control (e.g., buttons or switches)

### Software
- Xilinx Vivado Design Suite

## Done By
- **Mohamed El-Refai** 900222334
- **Mohamed Azouz** 900225230
- **Hana Shalaby** 900223042
