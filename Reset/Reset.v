//异步复位，同步释放
module asyn_rstn_syn_re(
    input      clk      ,
    input      rstn     ,
    output reg rstn_out
);
 
reg rstn_1;
 
always @(posedge clk or negedge rstn)begin
    if(!rstn)begin
        rstn_1   <= 1'b0;
        rstn_out <= 1'b0;
    end
    else begin
        rstn_1   <= rstn;
        rstn_out <= rstn_1;
    end
end
 
endmodule