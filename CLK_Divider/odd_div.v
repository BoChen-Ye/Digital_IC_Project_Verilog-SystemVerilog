module odd_div_clk (
	input	wire	clk,
	input   wire    rst_n,
	
	output  wire    div_clk

);

parameter  DIV = 3;

reg [31:0]	pos_cnt;
wire        pos_clk;
reg [31:0]  neg_cnt;
wire        neg_clk;

//上升沿分频
always@(posedge clk or negedge rst_n)begin
if(!rst_n)begin
  pos_cnt <= 'd0;
end
else if(pos_cnt==DIV-1)begin
 pos_cnt<= 'd0;
end
else begin
pos_cnt<= pos_cnt+1'd1;
end

end

assign pos_clk =(pos_cnt<DIV/2)? 0: 1;
//下降沿分频
always@(negedge clk or negedge rst_n)begin
if(!rst_n)begin
  neg_cnt <= 'd0;
end
else if(neg_cnt==DIV-1)begin
 neg_cnt<= 'd0;
end
else begin
neg_cnt<= neg_cnt+1'd1;
end

end

assign neg_clk =(neg_cnt<DIV/2)? 0: 1;

//奇偶判断后，输出分频时钟

assign div_clk = (DIV[0]==1)?(pos_clk&neg_clk) : pos_clk;

endmodule
