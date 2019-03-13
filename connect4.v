`timescale 1ns / 1ps 

module connect4(
    input clk,
	 input reset,

    input [10:0] x_pixel,
    input [10:0] y_pixel,

    input [3:0] keypadButton,
    input pop,

    input resetGame,
    input resetScore,

    output reg [2:0] vgaR,
    output reg [2:0] vgaG,
    output reg [1:0] vgaB
);
//0: Yellow, 1: Red

reg player = 1; // red first

reg [5:0] piece [6:0];
reg [5:0] state [6:0];
reg [2:0] top [6:0]; // saves how tall column is for every column (from 1 - 6 tall, 0 = none)

wire [3:0] col;
assign col = keypadButton;

integer x;
integer y;

initial begin
    for(x = 0; x < 7; x = x + 1) begin
        top[x] = 0;
        for(y = 0; y < 6; y = y + 1) begin  
            piece[x][y] <= 0;
            state[x][y] <= 0;    
        end
    end
end

reg [2:0] save;
always @(posedge clk) begin
    if(reset) begin
        for(x = 0; x < 7; x = x + 1) begin
            top[x] <= 0;
            for(y = 0; y < 6; y = y + 1) begin  
                piece[x][y] <= 0;
                state[x][y] <= 0;    
                player <= 1;
            end
        end
    end
    else begin
        if(pop)begin
            if(col >= 0 && col < 3'b111)begin
                if(state[col][0] == player) begin
						  save <= top[col] -1;
                    for(y = 0; y < save; y = y + 1) begin
                        state[col] <= state[col +1];
                    end
                    state[col][top[col] - 1] <= 0;
                    piece[col][top[col] - 1] <= 0;
                    top[col] <= top[col] - 1;
                    player <= ~player;
                end
                //else  //choose again
            end
            //else    //choose again
        end
        else if( col >= 0 && col < 3'b111 ) begin
            if(top[col] < 3'b110 ) begin
                piece[col][top[col] + 1 ] <= 1;
                state[col][top[col] + 1 ] <= player;
					 top[col] <= top[col] + 1;
                player <= ~player;
            end
            //else //choose again
        end    
        //else //choose again
	end
end
// display stuff

reg [2:0] column;
reg [2:0] row;

always @(posedge clk) begin
	/*
    column <= (x_pixel - 110) / 60;
    row <= (y_pixel - 60) / 60;

    if (x_pixel < 110 || x_pixel > 530 || y_pixel < 60 || y_pixel > 420) begin
        //black border
        vgaR = 3'b000;
        vgaG = 3'b000;
        vgaB = 2'b00;
	 end
    else if (piece[column][5-row] == 1 && (y_pixel - 60 - row * 30) > 10 && (y_pixel - 60 - row * 30) < 50 && (x_pixel - 110 - column * 30) > 10 && (x_pixel - 110 - column * 30) < 50) begin  //draw square pieces
        // Check piece color
        if (state[column][5-row] == 0) begin
            // yellow piece
            vgaR = 3'b111;
            vgaG = 3'b111;
            vgaB = 2'b00;
        end
        else begin
            // red piece
            vgaR = 3'b111;
            vgaG = 3'b000;
            vgaB = 2'b00;
        end
    end
    else begin
        //blue gameboard
        vgaR = 3'b000;
        vgaG = 3'b101;
        vgaB = 2'b11;
    end
	*/
	vgaR = 3'b000;
    vgaG = 3'b101;
    vgaB = 2'b11;
end
endmodule