module nexys3(
    input clk,

    input btnL,     // reset score button
    input btnR,     // reset game button

    input [7:0] JA,

    //output [7:0] seg,
    //output [3:0] an,

    output wire [2:0] vgaRed,
    output wire [2:0] vgaGreen,
    output wire [1:0] vgaBlue,
    output Hsync,
    output Vsync
);


wire [3:0] Decode;

wire leftButton;    // reset score button
wire rightButton;   // reset game button

wire clock_hz_50;
wire clock_hz_500;
wire clock_hz_25M;


wire [10:0] x_pixel;
wire [10:0] y_pixel;
wire vid_enable;
wire pop;

wire vgaR;
wire vgaG;
wire vgaB;

reg clr = 0;         //REPLACE WITH DEBOUNCER SIGNAL


// clock divider
// need special clock for VGA display, seven-segment display, 
clockdiv _clock_divider(
    .clk(clk),
	.clr(clr),
    .dclk(clock_hz_50),
    .segclk(clock_hz_500)
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

wire hs;
assign Hsync = ~hs;  //Hsync output
wire vs;
assign Vsync = ~vs;  //Vsync output

vga640x480 vga_module(
	//.clk(clock_hz_25M),
	//.clr(clr),
	//.hsync(hs),
	//.vsync(vs),
	//.PixelX(x_pixel),
	//.PixelY(y_pixel),
	//.vidon(vid_enable)

    .dclk(clock_hz_50),			//pixel clock: 25MHz
	.clr(clr),			//asynchronous reset
	.hsync(hs),		//horizontal sync out
	.vsync(vs),		//vertical sync out
	.red(vgaRed),	//x position of current pixel
	.green(vgaGreen), //y position of current pixel
	.blue(vgaBlue)     //turn pixel on/off
);
/*
// game logic
connect4 c4_module(
    .clk(clk),
	 .reset(clr),
    .x_pixel(x_pixel),
    .y_pixel(y_pixel),
    .keypadButton(Decode),
    .pop(pop),
    .resetGame(btnL),
    .resetScore(btnR),
    .vgaR(vgaRed),
    .vgaG(vgaGreen),
    .vgaB(vgaBlue)
);
*/
// score_display score_display_(
//     .clk(clk),
//     .num1(), 
//     .num2(),
//     .num3(),
//     .num4(),
//     .seg(seg),
//     .an(an)
// );

endmodule

