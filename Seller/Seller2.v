/*
设计一个自动贩售机，输入货币有两种，为0.5/1元，饮料价格是1.5/2.5元，要求进行找零，
找零只会支付0.5元。
*/
module moduleName (
    input wire clk  ,
    input wire rst_n  ,
    input wire d1 ,
    input wire d2 ,
    input wire sel ,
     
    output reg out1,
    output reg out2,
    output reg out3
);
    parameter IDLE = 3'b000, s0_5 = 3'b001,s1 =3'b010,s1_5 = 3'b011,s_2 = 3'b100;
    parameter s2_5 = 3'b101, s3 = 3'b110;
    reg[2:0]  cstate,nstate;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cstate <= IDLE;
        else
            cstate <= nstate;
    end
    always @(*) begin
        case (cstate)
            IDLE : nstate = d1 ? s0_5 : (d2 ? s1 : IDLE) ;
            s0_5 : nstate = d1 ? s1   : (d2 ? s1_5 : s1) ;
            s1   : nstate = d1 ? s1_5 : (d2 ? s_2 : s1)   ;
            s1_5 : nstate = !sel ? IDLE : d1 ? s_2 : (d2 ? s2_5 : s1_5);
            s_2  : nstate = !sel ? IDLE : d1 ? s2_5 : (d2 ? s3 : s_2);
            s2_5 : nstate = IDLE ;    
            s3   : nstate = IDLE ; 
            default: nstate = IDLE ;
        endcase
    end 
    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            out1 <= 1'b0;
            out2 <= 1'b0;
            out3 <= 1'b0;
        end
        else begin
            if(!sel)begin
                case (nstate)
                    s1_5:    begin out1 <= 1'b1;out2 <= 1'b0;out3 <= 1'b0;end 
                    s_2:     begin out1 <= 1'b1;out2 <= 1'b0;out3 <= 1'b1;end 
                    default:begin out1 <= 1'b0;out2 <= 1'b0;out3 <= 1'b0;end 
                endcase
            end
            else begin
                case (nstate) 
                    s1_5:   begin out1 <= 1'b0;out2 <= 1'b1;out3 <= 1'b0;end  
                    s_2:     begin out1 <= 1'b0;out2 <= 1'b1;out3 <= 1'b1;end  
                    default:begin out1 <= 1'b0;out2 <= 1'b0;out3 <= 1'b0;end  
                endcase
            end
        end
    end
endmodule