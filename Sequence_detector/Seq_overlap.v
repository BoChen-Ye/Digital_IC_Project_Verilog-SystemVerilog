//检测到1011后输出标志
module xljc_1011(
	input clk;
	input rst_n;
	input din; //输入要检测数据
	output reg out
);

parameter S0=5'b0_0001,S1=5'b0_0010,S2=5'b0_0100,S3=5'b0_1000,S4=5'b1_0000;   //独热码

reg [4:0] state;
reg [4:0] c_state,n_state;

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)
	     c_state<=S0;
	 else 
	     c_state<=n_state;	
end
	
always@(c_state or din)begin
	     case(c_state)      
				S0: n_state = din ? S1 : S0;
				
				S1: n_state = din ? S1 : S2;
				
				S2: n_state = din ? S3 : S0;
				
				S3: n_state = din ? S4 : S2;
				
				//S4: n_state = din ? S1 : S0; //non-overlap
				
				S4: n_state = din ? S1 : S2; //overlap
				default:n_state=S0;
			endcase							  		 		 		 
	  
end

always@(posedge clk or negedge rst_n)begin
   if(!rst_n)
	     out<=1'b0;
	 else begin
	     case(n_state)
		  S4:out<=1'b1;
		  default:out<=1'b0;	
		endcase  
	 end
