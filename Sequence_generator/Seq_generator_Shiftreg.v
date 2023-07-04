/*
编写一个模块，实现循环输出序列001011。
分析：这里需要循环输出序列001011，显然定义一个reg[5:0] 去存储001011，
然后按照时钟一拍一拍的把他的最高位读出即可。由于这里需要循环输出，所以当读到100000的时候，
需要重新写入reg的值。
*/
module Seq_generator_Shiftreg (
    input clk,
    input rst_n,
    output reg data
);
    reg [5:0]data_r;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            data_r <= 6'b001011;
        else if (data_r == 6'b100000)           // 加括号
            data_r <= 6'b001011;
        else    
            data_r <= (data_r << 1 );           // 加括号
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            data <= 1'b0;
        else    
            data <= data_r[5];
    end   
endmodule