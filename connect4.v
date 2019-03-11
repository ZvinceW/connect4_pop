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


// initialize game state


always @(*)
begin
    if (resetGame)
end



// display stuff

integer pixelCol;
integer pixelRow;

always @(posedge clk) begin
    pixelCol <= (PixelX - 120) / 70;
    pixelRow <= (PixelY - 60) / 60;

    if (PixelX < 110 || PixelX > 530 || PixelY < 60 || PixelY > 420) begin
        //blue border
        R = 3'b000;
        G = 3'b101;
        B = 2'b11;
    else if (gameStatePIECE[pixelCol][7-pixelRow] == 1) begin  //draw square pieces
        // Check piece color
        if (gameStateSIDE[pixelCol][7-pixelRow] == BLACK) begin
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
    else if (pixelCol % 2 == pixelRow % 2) begin
        // Yellow checkerboard squares
        R = 3'b111;
        G = 3'b111;
        B = 2'b00;
        // Highlight column if selected
        if (pixelCol == currColumn) begin
            R = 3'b111;
            G = 3'b111;
            B = 2'b11;
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