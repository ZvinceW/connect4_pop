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

endmodule