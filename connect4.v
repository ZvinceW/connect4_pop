module connect4(
    input clock,

    input [10:0] x_pixel,
    input [10:0] y_pixel,

    input reg [3:0] keypadButton,

    input resetGame,
    input resetScore,

    output reg [2:0] vgaR,
    output reg [2:0] vgaG,
    output reg [1:0] vgaB
);
//0: Yellow, 1: Red

reg player; 
player <= 1; // red first

reg [6:0] piece [5:0];
reg [6:0] state [5:0];
reg [6:0] top; // saves how tall column is for every column (from 1 - 6 tall, 0 = none)

reg [3:0] x;
reg [3:0] y;

initial begin
    for(x = 0; x < 7; x = x + 1) begin
        top[x] = 0;
        for(y = 0; y < 6; y = y + 1) begin  
            piece[x][y] <= 0;
            state[x][y] <= 0;    
        end
    end
end

always @(posedge clk) begin
    if(reset) begin
        for(x = 0; x < 7; x = x + 1) begin
            top[x] = 0;
            for(y = 0; y < 6; y = y + 1) begin  
                piece[x][y] <= 0;
                state[x][y] <= 0;    
                player <= 1;
            end
        end
    end
    else 
        if(pop)begin
            if(col >= 0 && col < 111)begin
                if(state[col][0] == player) begin
                    for(y = 0; y < top[col] - 1; y = y + 1) begin
                        state[col] = state[col +1];
                    end
                    state[col][top[col] -1] = 0;
                    piece[col][top[col] -1] = 0;
                    top[col] = top[col] -1;
                    player = ~player;
                end
                else 
                    //choose again
            end
            else    
                //choose again
        end
        else if( col >= 0 && col < 111 ) begin
            if(top[col] < 110 ) begin
                piece[col][top[col] + 1 ] <= 1;
                state[col][top[col] + 1 ] <= player;
                player <= ~player
            end
            else 
            //choose again
        end    
        else //choose again


// display stuff

integer pixelCol;
integer pixelRow;

always @(posedge clk) begin
    pixelCol <= (x_pixel - 110) / 60;
    pixelRow <= (y_pixel) - 60) / 60;

    if (PixelX < 110 || PixelX > 530 || PixelY < 60 || PixelY > 420) begin
        //blue border
        R = 3'b000;
        G = 3'b101;
        B = 2'b11;
    else if (gameStatePIECE[pixelCol][5-pixelRow] == 1) begin  //draw square pieces
        // Check piece color
        if (gameStateSIDE[pixelCol][5-pixelRow] == BLACK) begin
            // yellow piece
            R = 3'b111;
            G = 3'b111;
            B = 2'b00;
            end
        else begin
            // red piece
            R = 3'b111;
            G = 3'b000;
            B = 2'b00;
            end
        end
    else begin
        // Blue default checkerboard
        R = 3'b000;
        G = 3'b000;
        B = 2'b11;
        // Highlight column if selected
        if (pixelCol == currColumn) begin
            R = 3'b111;
            G = 3'b111;
            B = 2'b11;
            end
        end
    end
endmodule