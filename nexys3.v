module nexys3(
    input clk,

    input btnL,     // reset score button
    input btnR,     // reset game button

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

wire leftButton;    // reset score button
wire rightButton;   // reset game button

wire clock_hz_50;
wire clock_hz_500;


wire [10:0] x_pixel;
wire [10:0] y_pixel;
wire vid_enable;
wire pop;

wire vgaR;
wire vgaG;
wire vgaB;


// clock divider
// need special clock for VGA display, seven-segment display, 
clock_divider _clock_divider(
    .clk(clk),
    .clk_hz_50(clock_hz_50),
    .clk_hz_500(clock_hz_500)
);

// decoder for PMOD keypad (taken from Digilent PMOD Reference Design https://reference.digilentinc.com/reference/programmable-logic/nexys-3/start)
decoder C0(
    .clk(clk),
    .Row(JA[7:4]),
    .Col(JA[3:0]),
    .DecodeOut(Decode),  // the 4-bit representation of the button pressed 1 through F
    .pop_out(pop)
);

/* 
debouncers for the following buttons:
    - leftButton
    - rightButton
    - may potentially need for the PMOD buttons? (might need to go in the module above)
*/

/*
VGA stuff
*/
reg clr = 0;         //REPLACE WITH DEBOUNCER SIGNAL
wire hs;
assign Hsync = ~Hs;  //Hsync output
wire vs;
assign Vsync = ~Vs;  //Vsync output

vga_640x480 vga_module(
    .dclk(clock_hz_50),			//pixel clock: 25MHz
	.clr(clr),			//asynchronous reset
	.hsync(hs),		//horizontal sync out
	.vsync(vs),		//vertical sync out
	.x_pixel(x_pixel),	//x position of current pixel
	.y_pixel(y_pixel), //y position of current pixel
	.vid_enable(vid_enable)     //turn pixel on/off
)

// game logic
connect4 c4_module(
    .clock(clk),
    .x_pixel(x_pixel),
    .y_pixel(y_pixel),
    .keypadButton(Decode),
    .pop(pop)
    .resetGame(btnL),
    .resetScore(btnR),
    .vgaR(vgaR),
    .vgaG(vgaG),
    .vgaB(vgaB)
);

endmodule

