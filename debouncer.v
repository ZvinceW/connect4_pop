
`timescale 1ns / 1ps

module debouncer(
    input clk,
    input btn_in,
    output btn_out
    );

reg [1:0] btn_buffer;
assign btn_out = btn_buffer[0];

always @(posedge clk or posedge btn_in) begin

    if (btn_in)
        btn_buffer <= 2'b11;
    else
        btn_buffer <= {1'b0, btn_buffer[1]};

end

endmodule


/*
module debouncer(
    input clk, // 500-900 Hz clock?
    input btn,
    output reg valid
);

reg [1:0] history;

history[1:0] <= 0;
valid <= 1'b0;

always @ (posedge clk)
    history[1:0] <= {btn, history[1]};
	   
	// Detecting posedge of btn
    wire is_btn_posedge;
    assign is_btn_posedge <= ~history[0] & history[1];
    if (is_btn_posedge == 2'b11)
        valid <= is_btn_posedge;
	else
	    valid <= 0;

endmodule
*/


// Lab 3 Implementation

// module debouncer(
// 	input clk,
//    input PB,  
//    output PB_state  // 1 as long as the push-button is active (down)
// );

// 	reg Btn_state = 0;
	
// 	// Next declare a 16-bits counter
// 	reg [19:0] PB_cnt;
// 	wire PB_cnt_max = 20'hffff0;	// true when all bits of PB_cnt are 1's

// 	always @(posedge clk)
// 		if(PB == 0) begin
// 			 PB_cnt <= 0;  // nothing's going on
// 			 Btn_state <= 0;
// 		end
// 		else
// 		begin
// 			 PB_cnt <= PB_cnt + 1'b1;  // something's going on, increment the counter
// 			 if(PB_cnt == PB_cnt_max) begin
// 				Btn_state <= 1;  // if the counter is maxed out, PB changed!
// 				PB_cnt <= 0;
// 			 end
// 		end
	
// 	assign PB_state = Btn_state;

// endmodule