module edge_det(
    input clk            ,
    input rstn           ,
    input signal         ,
    output pos_edge,neg_edge,both_edge
);
 
reg reg1,reg2;
 
always @(posedge clk or negedge rstn)begin
    if(!rstn)begin
        reg1 <= 1'b0;
        reg2 <= 1'b0;
    end
    else begin
        reg1 <= signal;
        reg2 <= reg1;
    end
end
 
assign pos_edge = (~reg2) & reg1;//上升边沿检测
assign neg_edge = (~reg1) & reg2;//下降边沿检测
assign both_edge = reg1 ^reg2;//双边沿检测
endmodule