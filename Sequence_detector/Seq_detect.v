/*
使用verilog代码，设计电路，检测序列为1001，检测到的时候输出1，没检测到的时候输出0
*/
module Seq_detect (
    input clk,
    input rst_n,
    input seq,
    output wire detect
);
    parameter IDLE = 3'b000 , s1 = 3'b001 , s2 = 3'b011 ,s3 = 3'b010, s4 = 3'b110;
    reg [2:0] cstate,nstate;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cstate <= IDLE;
        else
            cstate <= nstate;
    end
 
    always @(*) begin
        case (cstate)
            IDLE :  nstate = seq ? s1 : IDLE;
            s1   :  nstate = seq ? s1 : s2  ;
            s2   :  nstate = seq ? s1 : s3  ;
            s3   :  nstate = seq ? s4 : IDLE;
            s4   :  nstate = seq ? s1 : IDLE;
            default: nstate = IDLE;
        endcase
    end
 
    assign detect = (nstate == s4)? 1 : 0 ;
endmodule