module nexys3(
    input clk,

    input btnU,
    input btnL,
    input btnD,
    input btnR,

    input [7:0] JA,

    output [7:0] seg,
    output [3:0] an,

    output reg [2:0] vgaRed,
    output reg [2:0] vgaGreen,
    output reg [1:0] vgaBlue,
    output Hsync,
    output Vsync
    );

wire [3:0] Decode;

wire leftButton;
wire rightButton;
wire upButton;
wire downButton;

wire hackerman;

wire clock_hz_50;
wire clock_hz_10;

clock_divider _clock_divider(
    .clk(clk),
    .clk_hz_50(clock_hz_50),
    .clk_hz_10(clock_hz_10)
);

decoder C0(
    .clk(clk),
    .Row(JA[7:4]),
    .Col(JA[3:0]),
    .DecodeOut(Decode)  // the 4-bit representation of the button pressed 1 through F
);

/* 
debouncers for the following buttons:
    - leftButton
    - rightButton
    - upButton
    - downButton 
    - may potentially need for the PMOD buttons? (might need to go in the module above)
*/

/*
VGA stuff
*/

/*
game logic
*/



