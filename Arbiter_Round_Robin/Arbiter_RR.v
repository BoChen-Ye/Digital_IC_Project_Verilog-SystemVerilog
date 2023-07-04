// ===================================================================================
// 功能：
//     -1- Round Robin 仲裁器
//     -2- 仲裁请求个数N可变
//     -3- 加入lock机制（类似握手）
//     -4- 复位时的最高优先级定为 0 ，次优先级：1 -> 2 …… -> N-2 -> N-1
// By：Xu Y. B.
// ===================================================================================
`timescale 1ns / 1ps
module Arbiter_RR #(
parameter   N = 4 //仲裁请求个数
)(
input               clock,
input               reset_b,
input      [N-1:0]  request,
input      [N-1:0]  lock,
output reg [N-1:0]  grant//one-hot
    );
// 模块内部参数
 
localparam LP_ST_IDLE           = 3'b001;// 复位进入空闲状态，接收并处理系统的初次仲裁请求
localparam LP_ST_WAIT_REQ_GRANT = 3'b010;// 等待后续仲裁请求到来,并进行仲裁
localparam LP_ST_WAIT_LOCK      = 3'b100;// 等待LOCK拉低
 
// 模块内部信号
reg  [2:0]   R_STATUS;
reg  [N-1:0] R_MASK;
wire [N-1:0] W_REQ_MASKED;
 
assign W_REQ_MASKED = request & R_MASK;
 
always @ (posedge clock)
begin
  if(~reset_b)
	begin
		R_STATUS <= LP_ST_IDLE;
		R_MASK <= 0;
		grant <= 0;
	end
  else
  begin
    case(R_STATUS)
    LP_ST_IDLE:
    begin
      if(|request) //首次仲裁请求
      begin
        R_STATUS <= LP_ST_WAIT_LOCK;
        grant <= request & ((~request)+1);
        R_MASK <= ~((request & ((~request)+1))-1 | (request & ((~request)+1)));  
      end
      else
      begin
        R_STATUS <= LP_ST_IDLE;
      end
    end     
    LP_ST_WAIT_REQ_GRANT://处理后续的仲裁请求
    begin
      if(|request)
      begin
        R_STATUS <= LP_ST_WAIT_LOCK;
        if(|(request & R_MASK))//不全为零
        begin
          grant <= W_REQ_MASKED & ((~W_REQ_MASKED)+1);
          R_MASK <= ~((W_REQ_MASKED & ((~W_REQ_MASKED)+1))-1 | (W_REQ_MASKED & ((~W_REQ_MASKED)+1)));
        end
        else
        begin
          grant <= request & ((~request)+1);
          R_MASK <= ~((request & ((~request)+1))-1 | (request & ((~request)+1)));
        end
      end
      else
      begin
        R_STATUS <= LP_ST_WAIT_REQ_GRANT;      
        grant <= 0;      
        R_MASK <= 0;      
      end
    end   
    LP_ST_WAIT_LOCK:
    begin
      if(|(lock & grant)) //未释放仲裁器    
      begin    
        R_STATUS <= LP_ST_WAIT_LOCK;    
      end    
      else if(|request) //释放的同时存在仲裁请求     
      begin    
        R_STATUS <= LP_ST_WAIT_LOCK;
        if(|(request & R_MASK))//不全为零
        begin
          grant <= W_REQ_MASKED & ((~W_REQ_MASKED)+1);
          R_MASK <= ~((W_REQ_MASKED & ((~W_REQ_MASKED)+1))-1 | (W_REQ_MASKED & ((~W_REQ_MASKED)+1)));
        end
        else
        begin
          grant <= request & ((~request)+1);
          R_MASK <= ~((request & ((~request)+1))-1 | (request & ((~request)+1)));
        end    
      end
      else
      begin
        R_STATUS <= LP_ST_WAIT_REQ_GRANT;
        grant <= 0;      
        R_MASK <= 0;
      end    
    end    
    default:    
    begin
      R_STATUS <= LP_ST_IDLE;
      R_MASK <= 0;
      grant <= 0;
    end
    endcase
  end
end
endmodule