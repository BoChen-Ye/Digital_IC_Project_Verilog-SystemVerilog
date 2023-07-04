module parallel_to_serial_tb();
reg clk, rstn;
reg [7:0] din_parallel;
reg din_valid;
 
wire dout_valid,dout_serial;
 
always #5 clk = ~clk;
 
initial begin
    clk <= 1'b0;
    rstn <= 1'b0;
    #15
    rstn <= 1'b1;   
    din_valid <= 1'b1;
    din_parallel <= 8'b11110000;
    #80
    din_valid <= 1'b0;
    #40
    din_valid <= 1'b1;
    din_parallel <= 8'b10100011;
    #80
    din_valid <= 1'b0;
    #50
    $stop();
end
parallel_to_serial u_parallel_to_serial(
    .clk           (clk)          ,    
    .rstn          (rstn)         ,    
    .din_parallel  (din_parallel) ,
    .din_valid     (din_valid)    ,
    .dout_serial   (dout_serial)  ,
    .dout_valid    (dout_valid)
);
endmodule