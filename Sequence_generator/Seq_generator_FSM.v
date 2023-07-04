/*
用状态机的思路也比较简单，可以设计 s0 = 0 , s1 = 00 ,s2 = 001, s3= 0010,s4 =00101,s5= 001011 
这六个状态，并进行状态编码，每个状态都可以对应一个输出，而且状态机的转换与输入没有关系，
case当前是s1，那么无条件跳到s2，并且可以对应data输出，s0对应输出0，s1对应输出0，s2对应输出1，
s3对应0，等等。
*/
module Seq_generator_FSM (
    input wire clk;
    input wire rst_n;
    output reg data
);
    reg [2:0] cstate,nstate;
    parameter s0 = 3'b000, s1 = 3'b001 , s2 = 3'b011 ,s3 = 3'b010, s4 = 3'b110, s5= 3'b111;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cstate <= s0;
        else
            cstate <= nstate;
    end
    always @(*) begin
        case (cstate)
            s0   :  begin nstate = s1; data <= 1'b0;end
            s1   :  begin nstate = s2; data <= 1'b0;end
            s2   :  begin nstate = s3; data <= 1'b1;end
            s3   :  begin nstate = s4; data <= 1'b0;end
            s4   :  begin nstate = s5; data <= 1'b1;end
            s5   :  begin nstate = s0; data <= 1'b1;end
            default: begin nstate = s0; data <= 1'b0;end
        endcase
    end
endmodule