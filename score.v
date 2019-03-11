`timescale 1ns / 1ps 

module counter{
    input wire reset,
    input wire player1,
    input wire player2,
    input wire clk,
    output wire [3:0] big1,
    output wire [3:0] sm1,
    output wire [3:0] big2,
    output wire [3:0] sm2
}


reg [3:0] tempBig1 = 4'b0000;
reg [3:0] tempSm1 = 4'b0000;
reg [3:0] tempBig2 = 4'b0000;
reg [3:0] tempSm2 = 4'b0000;


always @(posedge clk or posedge player1 ot posedge player2) 
begin
    if (reset) begin
        tempBig1 = 4'b0000;
        tempSm1 = 4'b0000;
        tempBig2 = 4'b0000;
        tempSm2 = 4'b0000;
    end

    else if (  ~reset ) begin
       
        //agjust the clock time
        
        if(player1) begin
            if(tempBig1== 9 && tempSm1== 9) begin
                tempBig1 <= 4'b0000;
                tempSm1 <= 4'b0000;
            end
            else if(tempSm1 == 9 && tempBig1 != 9) begin
                tempSm1 <= 4'b0000;
                tempBig1<= tempBig1 + 4'b0001;
            end
            else begin
                tempSm1 <= tempSm1 + 4'b0001;
            end
        end
            //adjust min
        if(player2) begin
            if(tempBig2 == 9 && tempSm2 == 9) begin
                tempBig2<= 4'b0000;
                tempSm2<= 4'b0000;
            end
            else if(tempSm2 == 9 && tempBig2 != 9) begin
                tempSm2<= 4'b0000;
                tempBig2<= tempBig2+ 4'b0001;
            end
            else begin
                tempSm2 <= tempSm2 + 4'b0001;
            end
        end
    

    end
end 



assign big1 = tempBig1;
assign sm1 = tempSm1;
assign big2 = tempBig2;
assign sm2 = tempSm2;

endmodule