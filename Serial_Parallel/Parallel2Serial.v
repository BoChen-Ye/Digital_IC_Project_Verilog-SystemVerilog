/*
并转串
在输入数据有效的时候din_valid为高时，把输入的数据寄存一下，寄存到din_parallel_temp中，
然后再用一个计数器去检测输出，当计数器处在1~8的范围内时，让输出的串行数据等于输入的
并行数据的最高位，然后每周期让并行数据左移一bit。这样，八周期后，就实现了并转串。
*/
module parallel_to_serial(
    input clk,
    input rstn,
    input [7:0] din_parallel,
    input din_valid,
    output reg dout_valid,
    output reg dout_serial
);
 
reg [3:0] count;
reg [7:0] din_parallel_temp;
 
always @(posedge clk)begin
    if(!rstn)begin
        dout_valid <= 1'b0;
        dout_serial <= 1'b0;
    end
    else if(din_valid && (count == 4'b0))begin
        din_parallel_temp <= din_parallel;
    end
    else if((count >= 4'd1) && (count <= 4'd8))begin
        dout_serial <= din_parallel_temp[7];
        din_parallel_temp <= din_parallel_temp << 1;
        dout_valid <= 1'b1;
    end    
    else begin
        dout_valid <= 1'b0;
        dout_serial <= 1'b0;
    end
end
 
always @(posedge clk)begin
    if(!rstn)begin
        count <= 4'd0;
    end        
    else if(din_valid)begin
        count <= count + 1'b1;
    end
    else begin
        count <= 4'b0;
    end
end
endmodule