module serial_to_parallel_tb();
reg clk,rstn;
reg din_serial,din_valid;
wire dout_valid,dout_parallel;
 
always #5 clk = ~clk;
 
initial begin
    clk  <= 1'b0;
    rstn <= 1'b0;
    #15
    rstn <= 1'b1;
    din_valid  <= 1'b1;
    din_serial <= 1'b1; #10
    din_serial <= 1'b1; #10
    din_serial <= 1'b1; #10
    din_serial <= 1'b1; #10
 
    din_serial <= 1'b0; #10
    din_serial <= 1'b0; #10
    din_serial <= 1'b0; #10
    din_serial <= 1'b0; #10
    din_valid  <= 1'b0;
    #30
    din_valid  <= 1'b1;
    din_serial <= 1'b1; #10
    din_serial <= 1'b1; #10
    din_serial <= 1'b0; #10
    din_serial <= 1'b0; #10
 
    din_serial <= 1'b0; #10
    din_serial <= 1'b0; #10
    din_serial <= 1'b1; #10
    din_serial <= 1'b1; #10
    din_valid  <= 1'b0;
    $stop();
end 
serial_to_parallel u_serial_to_parallel(
    .clk           (clk)           ,
    .rstn          (rstn)          ,
    .din_serial    (din_serial)    ,
    .dout_parallel (dout_parallel) ,
    .din_valid     (din_valid)     ,
    .dout_valid    (dout_valid)
);  
endmodule