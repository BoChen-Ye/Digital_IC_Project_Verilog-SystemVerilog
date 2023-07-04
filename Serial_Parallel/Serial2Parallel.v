/*
串转并
用一个计数器count，每输入8个数，就输出一次，每周期dout_temp左移一位，
然后再将输入的1bit串行据存入dout_temp的最低位。
*/
module serial_to_parallel(
    input               rstn          ,
    input               clk           ,
    input               din_serial    ,
    input               din_valid     ,
    output  reg  [7:0]  dout_parallel ,
    output  reg         dout_valid
);
 
reg [7:0] dout_temp;
reg [3:0] count;
 
always @(posedge clk)begin
    if(!rstn)begin
        dout_temp  <= 8'd0;
        count      <= 4'd0;
        dout_valid <= 1'b0;
    end
    else if(din_valid && count <= 4'd7)begin
        dout_temp <= {dout_temp[6:0],din_serial};
        count     <= count + 1'b1;
    end
    else begin
        dout_valid <= 1'b0;
        dout_temp  <= 8'd0;
        count      <= 4'd0;
    end
end
 
always @(posedge clk)begin
    if(count == 4'd8)begin
        count         <= 4'd0;
        dout_parallel <= dout_temp;
        dout_valid    <= 1'b1;
    end
end
endmodule