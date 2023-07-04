module edge_det_tb();
 
reg clk,rstn;
reg signal;
 
wire signal_edge;
 
always #10 clk = ~clk;
 
initial begin
    clk     <= 1'b0;
    rstn    <= 1'b0;
    signal  <= 1'b0;
    #50
    rstn    <= 1'b1;
    #100
    signal  <= 1'b1;
end    
edge_det u_edge_det (
    .clk          (clk)    ,
    .rstn         (rstn)   ,
    .signal       (signal) ,
    .signal_edge  (signal_edge)
);
endmodule