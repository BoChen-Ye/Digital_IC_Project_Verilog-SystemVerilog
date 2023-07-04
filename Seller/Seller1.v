/*
使用Verilog设计电路，完成以下功能:每瓶饮料1.5元，一次只能投入一个硬币，
可投入0.5与1.0两种硬币，具有找零功能。

输入:两位memory代表投入的硬币，memory[1]拉高意味着投入1元，
	memory[0]拉高意味着投入0.5 元，默认一次只能投入一枚硬币。
输出:drink代表输出饮料，coin代表输出硬币。
*/
module Seller1 (
    input clk,
    input rst_n,
    input [1:0] money,
    output wire drink,
    output wire coin
);
    parameter IDLE = 3'b000,s1 = 3'b001,s2 =3'b010,s3 = 3'b011,s4 = 3'b100;
    reg[2:0]  cstate,nstate;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cstate <= IDLE;
        else
            cstate <= nstate;
        
    end
    always @(*) begin
        case (cstate)
            IDLE : nstate = money[1] ? s2 : (money[0] ? s1 : IDLE) ;
            s1   : nstate = money[1] ? s3 : (money[0] ? s2 : s1  ) ;
            s2   : nstate = money[1] ? s4 : (money[0] ? s3 : s2  ) ;
            s3   : nstate = money[1] ? s2 : (money[0] ? s1 : IDLE) ;
            s4   : nstate = money[1] ? s2 : (money[0] ? s1 : IDLE) ;
            default: nstate = IDLE ;
        endcase
    end 
    assign drink = (cstate == s3) ||  (cstate == s4) ;
    assign cion  = (cstate == s4) ? 1 : 0 ;
endmodule