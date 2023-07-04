/*
用移位寄存器的方法比状态机的方法代码要轻简很多：
1.先定义一个4位的变量用来移位——shift = 4’b0000;
2.然后每输入一位x，移位放至shift中——shift <= {shift[2:0], x};
3.检测shift是否等于1001.
*/
module Seq_detect_Shiftreg (
    input clk,
    input rst_n,
    input seq,
    output wire detect
);
    reg [3:0] shift;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            shift <= 4'b0000;
        else
            shift <= {shift[2:0],seq};
    end
    assign detect = (shift == 4'b1001) ? 1 : 0;
endmodule
