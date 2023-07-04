module asyn_rstn_syn_re_tb();
 
reg clk,rstn;
 
wire rstn_out;
 
always #10 clk = ~clk;
 
initial begin
    clk <= 1'b0;
    rstn <= 1'b0;
    #30
    rstn <= 1'b1;
end
asyn_rstn_syn_re u_asyn_rstn_syn_re(
    .clk        (clk)       ,
    .rstn       (rstn)      ,
    .rstn_out   (rstn_out)
);
endmodule