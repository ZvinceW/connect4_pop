`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:30:38 03/19/2013 
// Design Name: 
// Module Name:    vga640x480 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module vga_640x480(
	input wire dclk,			//pixel clock: 25MHz
	input wire clr,			//asynchronous reset
	output wire hsync,		//horizontal sync out
	output wire vsync,		//vertical sync out
	output reg [10:0] x_pixel,	//x position of current pixel
	output reg [10:0] y_pixel, //y position of current pixel
	output reg vid_enable     //turn pixel on/off
	);

// video structure constants
parameter hpixels = 800;// horizontal pixels per line
parameter vlines = 521; // vertical lines per frame
parameter hpulse = 96; 	// hsync pulse length
parameter vpulse = 2; 	// vsync pulse length
parameter hbp = 144; 	// end of horizontal back porch
parameter hfp = 784; 	// beginning of horizontal front porch
parameter vbp = 31; 		// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch
// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 511 - 31 = 480

// registers for storing the horizontal & vertical counters
reg [9:0] hc;
reg [9:0] vc;

// Horizontal & vertical counters --
// this is how we keep track of where we are on the screen.
// ------------------------
// Sequential "always block", which is a block that is
// only triggered on signal transitions or "edges".
// posedge = rising edge  &  negedge = falling edge
// Assignment statements can only be used on type "reg" and need to be of the "non-blocking" type: <=
always @(posedge dclk or posedge clr)
begin
	// reset condition
	if (clr == 1)
	begin
		hc <= 0;
		vc <= 0;
	end
	else
	begin
		// keep counting until the end of the line
		if (hc < hpixels - 1)
			hc <= hc + 1;
		else
		// When we hit the end of the line, reset the horizontal
		// counter and increment the vertical counter.
		// If vertical counter is at the end of the frame, then
		// reset that one too.
		begin
			hc <= 0;
			if (vc < vlines - 1)
				vc <= vc + 1;
			else
				vc <= 0;
		end
		
	end
end

// generate sync pulses (active low)
// ----------------
// "assign" statements are a quick way to
// give values to variables of type: wire
assign hsync = (hc < hpulse) ? 0:1;
assign vsync = (vc < vpulse) ? 0:1;

always @(posedge dclk)
begin
	if((hc < hfp) && (hc > hbp) && (vc < vfp) && (vc > vbp))
		begin
			vid_enable <= 1;
			x_pixel <= hc - hbp;
			y_pixel <= vc - vbp;
		end
	else
		begin
			vid_enable <= 0;
			x_pixel<=0;
			y_pixel<=0;
		end
end

endmodule


/*
module vga640x480(
	input wire dclk,		//pixel clock: 25MHz
	input wire clr,			//asynchronous reset
	output wire hsync,		//horizontal sync out
	output wire vsync,		//vertical sync out
	output reg [2:0] red,	//red vga output
	output reg [2:0] green, //green vga output
	output reg [1:0] blue	//blue vga output
	);

// video structure constants
parameter hpixels = 800;// horizontal pixels per line
parameter vlines = 521; // vertical lines per frame
parameter hpulse = 96; 	// hsync pulse length
parameter vpulse = 2; 	// vsync pulse length
parameter hbp = 144; 	// end of horizontal back porch
parameter hfp = 784; 	// beginning of horizontal front porch
parameter vbp = 31; 		// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch
// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 511 - 31 = 480

// registers for storing the horizontal & vertical counters
reg [9:0] hc;
reg [9:0] vc;

// Horizontal & vertical counters --
// this is how we keep track of where we are on the screen.
// ------------------------
// Sequential "always block", which is a block that is
// only triggered on signal transitions or "edges".
// posedge = rising edge  &  negedge = falling edge
// Assignment statements can only be used on type "reg" and need to be of the "non-blocking" type: <=
always @(posedge dclk or posedge clr)
begin
	// reset condition
	if (clr == 1)
	begin
		hc <= 0;
		vc <= 0;
	end
	else
	begin
		// keep counting until the end of the line
		if (hc < hpixels - 1)
			hc <= hc + 1;
		else
		// When we hit the end of the line, reset the horizontal
		// counter and increment the vertical counter.
		// If vertical counter is at the end of the frame, then
		// reset that one too.
		begin
			hc <= 0;
			if (vc < vlines - 1)
				vc <= vc + 1;
			else
				vc <= 0;
		end
		
	end
end

// generate sync pulses (active low)
// ----------------
// "assign" statements are a quick way to
// give values to variables of type: wire
assign hsync = (hc < hpulse) ? 0:1;
assign vsync = (vc < vpulse) ? 0:1;

// display 100% saturation colorbars
// ------------------------
// Combinational "always block", which is a block that is
// triggered when anything in the "sensitivity list" changes.
// The asterisk implies that everything that is capable of triggering the block
// is automatically included in the sensitivty list.  In this case, it would be
// equivalent to the following: always @(hc, vc)
// Assignment statements can only be used on type "reg" and should be of the "blocking" type: =
always @(*)
begin
	// first check if we're within vertical active video range
	if (vc >= vbp && vc < vfp)
	begin
		// now display different colors every 80 pixels
		// while we're within the active horizontal range
		// -----------------
		// display white bar
		if (hc >= hbp && hc < (hbp+80))
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b11;
		end
		// display yellow bar
		else if (hc >= (hbp+80) && hc < (hbp+160))
		begin
			red = 3'b111;
			green = 3'b111;
			blue = 2'b00;
		end
		// display cyan bar
		else if (hc >= (hbp+160) && hc < (hbp+240))
		begin
			red = 3'b000;
			green = 3'b111;
			blue = 2'b11;
		end
		// display green bar
		else if (hc >= (hbp+240) && hc < (hbp+320))
		begin
			red = 3'b000;
			green = 3'b111;
			blue = 2'b00;
		end
		// display magenta bar
		else if (hc >= (hbp+320) && hc < (hbp+400))
		begin
			red = 3'b111;
			green = 3'b000;
			blue = 2'b11;
		end
		// display red bar
		else if (hc >= (hbp+400) && hc < (hbp+480))
		begin
			red = 3'b111;
			green = 3'b000;
			blue = 2'b00;
		end
		// display blue bar
		else if (hc >= (hbp+480) && hc < (hbp+560))
		begin
			red = 3'b000;
			green = 3'b000;
			blue = 2'b11;
		end
		// display black bar
		else if (hc >= (hbp+560) && hc < (hbp+640))
		begin
			red = 3'b000;
			green = 3'b000;
			blue = 2'b00;
		end
		// we're outside active horizontal range so display black
		else
		begin
			red = 0;
			green = 0;
			blue = 0;
		end
	end
	// we're outside active vertical range so display black
	else
	begin
		red = 0;
		green = 0;
		blue = 0;
	end
end

endmodule
*/

/*
module vga_640x480(input wire clk,
input wire clr,
output reg hsync,
output reg vsync,
output reg [10:0] PixelX,
output reg [10:0] PixelY,
output reg vidon
    );


parameter TotalHorizontalPixels = 11'd1040;
parameter HorizontalSyncWidth = 11'd120;
parameter VerticalSyncWidth = 11'd6;

parameter TotalVerticalLines = 11'd666;
parameter HorizontalBackPorchTime = 11'd184 ;
parameter HorizontalFrontPorchTime = 11'd984 ;
parameter VerticalBackPorchTime = 11'd43 ;
parameter VerticalFrontPorchTime = 11'd643;

reg VerticalSyncEnable;

reg [10:0] HorizontalCounter;
reg [10:0] VerticalCounter;

//Counter for the horizontal sync signal
always @(posedge clk)
begin
	if(clr == 1)
		HorizontalCounter <= 0;
	else
		begin
			if(HorizontalCounter == TotalHorizontalPixels - 1)
				begin //the counter has hreached the end of a horizontal line
					HorizontalCounter<=0;
					VerticalSyncEnable <= 1;
				end
			else
				begin 
					HorizontalCounter<=HorizontalCounter+1; 
					VerticalSyncEnable <=0;
				end
		end
end

//Generate the hsync pulse
//Horizontal Sync is low when HorizontalCounter is 0-127

always @(*)
begin
	if((HorizontalCounter<HorizontalSyncWidth))
		hsync = 1;
	else
		hsync = 0;
end

//Counter for the vertical sync

always @(posedge clk)
begin
	if(clr == 1)
		VerticalCounter<=0;
	else
	begin
		if(VerticalSyncEnable == 1)
			begin
				if(VerticalCounter==TotalVerticalLines-1)
					VerticalCounter<=0;
				else
					VerticalCounter<=VerticalCounter+1;
			end
	end
end

//generate the vsync pulse
always @(*)
begin
	if(VerticalCounter < VerticalSyncWidth)
		vsync = 1;
	else
		vsync = 0;
end

always @(posedge clk)
begin
	if((HorizontalCounter<HorizontalFrontPorchTime) && (HorizontalCounter>HorizontalBackPorchTime) && (VerticalCounter<VerticalFrontPorchTime) && (VerticalCounter>VerticalBackPorchTime))
		begin
			vidon <= 1;
			PixelX<= HorizontalCounter - HorizontalBackPorchTime;
			PixelY<= VerticalCounter - VerticalBackPorchTime;
		end
	else
		begin
			vidon <= 0;
			PixelX<=0;
			PixelY<=0;
		end
end

endmodule
*/