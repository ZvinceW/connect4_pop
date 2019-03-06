module clock_divider(
    input  clk,
    output clk_hz_50,
	output clk_hz_10,
);

	reg [25:0] clk_hz_50_counter = 0;
	reg [25:0] clk_hz_10_counter = 0;

	reg clk_50 = 0;
	reg clk_10 = 0;

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
		
		if (clk_hz_10_counter != 5_000_000)
		begin
			clk_hz_10_counter = clk_hz_10_counter + 1;
		end
		else
		begin
			clk_10 = ~clk_10;
			clk_hz_10_counter = 0;
		end
	end
	
	assign clk_hz_50 = clk_50;
	assign clk_hz_10 = clk_10;

endmodule
