`timescale 1ns / 1ps 

module counter(
    input wire reset,
    input wire player1,
    input wire player2,
    input wire clk,
    output wire [3:0] big1,
    output wire [3:0] sm1,
    output wire [3:0] big2,
    output wire [3:0] sm2
);


reg [3:0] tempBig1 = 4'b0000;
reg [3:0] tempSm1 = 4'b0000;
reg [3:0] tempBig2 = 4'b0000;
reg [3:0] tempSm2 = 4'b0000;

reg [1:0] det_p1_edge;
wire p1_edge;
assign p1_edge = (det_p1_edge == 2'b01);
always @(posedge clk)
begin
	 det_p1_edge <= {det_p1_edge[0], player1};
end

reg [1:0] det_p2_edge;
wire p2_edge;
assign p2_edge = (det_p2_edge == 2'b01);
always @(posedge clk)
begin
	 det_p2_edge <= {det_p2_edge[0], player2};
end

always @(posedge clk) 
begin
    if (reset) begin
        tempBig1 <= 4'b0000;
        tempSm1 <= 4'b0000;
        tempBig2 <= 4'b0000;
        tempSm2 <= 4'b0000;
    end
    
    else
    begin
       
        //agjust the clock time
        
        if(p1_edge) begin
            if(tempBig1== 4'b1001 && tempSm1== 4'b1001) begin
                tempBig1 <= 4'b0000;
                tempSm1 <= 4'b0000;
            end
            else if(tempSm1 == 4'b1001 && tempBig1 != 4'b1001) begin
                tempSm1 <= 4'b0000;
                tempBig1<= tempBig1 + 4'b0001;
            end
            else begin
                tempSm1 <= tempSm1 + 4'b0001;
            end
        end
            //adjust min
        else if(p2_edge) begin
            if(tempBig2 == 4'b1001 && tempSm2 == 4'b1001) begin
                tempBig2<= 4'b0000;
                tempSm2<= 4'b0000;
            end
            else if(tempSm2 == 4'b1001 && tempBig2 != 4'b1001) begin
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