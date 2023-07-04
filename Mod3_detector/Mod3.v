/*
使用verilog代码，设计电路，判断输入序列能否被三整除，能的时候输出1，不能的时候输出0
*/
module moduleName (
    input clk,
    input rst_n,
    input data,
    output wire mod0
);
    parameter IDLE = 2'b00,s0 = 2'b01,s1 = 2'b11,s2 = 2'b10;
    reg[1:0]  cstate,nstate;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cstate <= IDLE;
        else
            cstate <= nstate;
    end
    always @(*) begin
        case (cstate)
            IDLE : nstate = data ? s1 : s0 ;
            s0   : nstate = data ? s1 : s0 ;
            s1   : nstate = data ? s0 : s2 ;
            s2   : nstate = data ? s2 : s1 ;
            default: nstate = IDLE;
        endcase
    end
    assign mod0 = (cstate == s0) ? 1 : 0;
endmodule