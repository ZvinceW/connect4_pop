module score_display(
    input clk,

    input [3:0] num1, 
    input [3:0] num2,
    input [3:0] num3,
    input [3:0] num4,
    
    output [7:0] seg,
    output [3:0] an
);

reg [3:0] num;

reg [7:0] segment;
reg [3:0] ann;

reg [1:0] counter = 0; 

always @(posedge clk)
begin
	case (counter)
		0: begin num = num1; ann = 4'b0111; end
		1: begin num = num2; ann = 4'b1011; end
		2: begin num = num3; ann = 4'b1101; end
		3: begin num = num4; ann = 4'b1110; end
	endcase
	case (num)
			4'b0000: segment = 8'b11000000; //0
			4'b0001: segment = 8'b11111001; //1
			4'b0010: segment = 8'b10100100; //2 10100100
			4'b0011: segment = 8'b10110000; //3 10110000
			4'b0100: segment = 8'b10011001; //4 10011001
			4'b0101: segment = 8'b10010010; //5 10010010
			4'b0110: segment = 8'b10000010; //6 10000010
			4'b0111: segment = 8'b11111000; //7 11111000
			4'b1000: segment = 8'b10000000; //8 10000000
			4'b1001: segment = 8'b10010000; //9 10010000
			4'b1011: segment = 8'b11111111; //blank
	endcase
    counter <= counter + 1;
end
	
assign seg = segment;	
assign an = ann;

endmodule
