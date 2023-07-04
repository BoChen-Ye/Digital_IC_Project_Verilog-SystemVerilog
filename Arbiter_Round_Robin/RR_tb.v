// =====================================================================
// 功能：测试模块 Round_Robin_Arbiter 功能 
// By：Xu Y. B.
// =====================================================================
 
`timescale 1ns / 1ps
module TB_Round_Robin_Arbiter();
 
parameter     N     =     4; //仲裁请求个数
 
reg               clock;
reg               reset_b;
reg       [N-1:0]      request;
reg       [N-1:0]      lock;
wire       [N-1:0]     grant;//one-hot
 
initial clock = 0;
always #10 clock = ~clock;
 
initial
begin
  reset_b <= 1'b0;
  request <= 0;
  lock <= 0;
  #20;
  reset_b <= 1'b1;
  @(posedge clock)
  request <= 2;
  lock <= 2;
 
  @(posedge clock)
  request <= 0;
 
  @(posedge clock)
  request <= 5;
  lock <= 7;
 
  @(posedge clock)
  lock <= 5;
 
  @(posedge clock)
  request <= 1;
 
  @(posedge clock)
  lock <= 1;
 
  @(posedge clock)
  request <= 0;
 
  @(posedge clock)
  lock <= 0;
 
  #100;
  $finish;
end
 
Round_Robin_Arbiter #(
    .N(N)
  ) inst_Round_Robin_Arbiter (
    .clock   (clock),
    .reset_b (reset_b),
    .request (request),
    .lock    (lock),
    .grant   (grant)
  );
 
endmodule