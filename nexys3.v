module nexys3(
    input clk,

    input btnL,     // reset score button
    input btnR,     // reset game button
	input btnU,
    input btnD,
    input btnC,    //submit button

    input [7:0] JA,

    //output [7:0] seg,
    //output [3:0] an,

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
wire btn_clk;
decoder C0(
    .clk(clk),
    .Row(JA[7:4]),
    .Col(JA[3:0]),
    .DecodeOut(Decode),  // the 4-bit representation of the button pressed 1 through F
    .pop_out(pop),
	 .btn_clk(btn_clk)
);

/* 
debouncers for the following buttons:
    - leftButton
    - rightButton
    - may potentially need for the PMOD buttons? (might need to go in the module above)
*/
wire left;
wire right;
wire up;
wire down;
wire center;

debouncer db_left(
    .clk(clk),
    .btn_in(btnL),
    .btn_out(left)
);
debouncer db_right(
    .clk(clk),
    .btn_in(btnR),
    .btn_out(right)
);
debouncer db_up(
    .clk(clk),
    .btn_in(btnU),
    .btn_out(up)
);
debouncer db_down(
    .clk(clk),
    .btn_in(btnD),
    .btn_out(down)
);
debouncer db_center(
    .clk(clk),
    .btn_in(btnC),
    .btn_out(center)
);

/*
VGA stuff
*/

wire hs;
assign Hsync = ~hs;  //Hsync output
wire vs;
assign Vsync = ~vs;  //Vsync output

vga_640x480 vga_module(
	.dclk(clock_hz_50),
	.clr(clr),
	.hsync(hs),
	.vsync(vs),
	.x_pixel(x_pixel),
	.y_pixel(y_pixel),
	.vid_enable(vid_enable)

   //.clk(clock_hz_50),			//pixel clock: 25MHz
	//.clr(clr),			//asynchronous reset
	//.hsync(hs),		//horizontal sync out
	//.vsync(vs),		//vertical sync out
	//.PixelX(x_pixel),	//x position of current pixel
	//.PixelY(y_pixel), //y position of current pixel
	//.vidon(vid_enable)     //turn pixel on/off
);

// game logic
connect4 c4_module(
    .clk(clock_hz_50),
	.reset(right),
    .btn_submit(center),
    .x_pixel(x_pixel),
    .y_pixel(y_pixel),
    .keypadButton(Decode),
    .pop(pop),
    .resetGame(btnL),
    .resetScore(btnR),
    .vgaR(vgaR),
    .vgaG(vgaG),
    .vgaB(vgaB)
);

wire score1big;
wire score1small;
wire score2big;
wire score2small;

counter score(
	.reset(left),
    .player1(up),
    .player2(down),
    .clk(clk),
    .big1(score1big),
    .sm1(score1small),
    .big2(score2big),
    .sm2(score2small)
);

score_display score_display_(
     .clk(clk),
     .num1(score1big),
     .num2(score1small),
     .num3(score2big),
     .num4(score2small),
     .seg(seg),
     .an(an)
 );

always @(clock_hz_50) begin
    if (vid_enable) begin
        vgaRed[2:0] = vgaR;
        vgaGreen[2:0] = vgaG;
        vgaBlue[1:0] = vgaB;
    end
    else begin
        vgaRed[2:0] = 3'b000;
        vgaGreen[2:0] = 3'b000;
        vgaBlue[1:0] = 2'b00;
    end
end


endmodule

