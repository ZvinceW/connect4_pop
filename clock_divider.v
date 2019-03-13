

/*
module clock_divider(
    input  clk,
    output clk_hz_50,
	output clk_hz_500,
	output clk_hz_25M
);

	reg [25:0] clk_hz_50_counter = 0;
	reg [25:0] clk_hz_500_counter = 0;
	reg [25:0] clk_hz_25M_counter = 0;

	reg clk_50 = 0;
	reg clk_500 = 0;
	reg clk_25M = 0;

	always @(posedge clk)
	begin

        if (clk_hz_50_counter != 1_000_000)
		begin
			clk_hz_50_counter = clk_hz_50_counter + 1;
		end
		else
		begin
			clk_50 = ~clk_50;
			clk_hz_50_counter = 0;
		end
		
		if (clk_hz_500_counter != 100_000)
		begin
			clk_hz_500_counter = clk_hz_500_counter + 1;
		end
		else
		begin
			clk_500 = ~clk_500;
			clk_hz_500_counter = 0;
		end
		
		if (clk_hz_25M_counter != 1)
		begin
			clk_hz_25M_counter = clk_hz_25M_counter + 1;
		end
		else
		begin
			clk_25M = ~clk_25M;
			clk_hz_25M_counter = 0;
		end
		
	end
	
	assign clk_hz_50 = clk_50;
	assign clk_hz_500 = clk_500;
	assign clk_hz_25M = clk_25M;

endmodule
*/
module clockdiv(
	input wire clk,		//master clock: 50MHz
	input wire clr,		//asynchronous reset
	output wire dclk,		//pixel clock: 25MHz
	output wire segclk	//7-segment clock: 381.47Hz
	);

// 17-bit counter variable
reg [16:0] q;

// Clock divider --
// Each bit in q is a clock signal that is
// only a fraction of the master clock.
always @(posedge clk or posedge clr)
begin
	// reset condition
	if (clr == 1)
		q <= 0;
	// increment counter by one
	else
		q <= q + 1;
end

// 50Mhz � 2^17 = 381.47Hz
assign segclk = q[16];

// 50Mhz � 2^1 = 25MHz
assign dclk = q[1];

endmodule
