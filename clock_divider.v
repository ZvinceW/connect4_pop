module clock_divider(
    input  clk,
    output clk_hz_50,
	output clk_hz_500,
);

	reg [25:0] clk_hz_50_counter = 0;
	reg [25:0] clk_hz_500_counter = 0;

	reg clk_50 = 0;
	reg clk_500 = 0;

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
	end
	
	assign clk_hz_50 = clk_50;
	assign clk_hz_500 = clk_500;

endmodule
