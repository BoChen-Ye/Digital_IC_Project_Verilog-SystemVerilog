// deal 8-bits data parallel per cycle
module scrambler_8bits(
	input		clk,
	input		rstb,
	input [7:0]	data_in,
	input		k_in,//When 1, the input is a control
					//when 0, the data is regular data
	input		disab_scram,//when 1 scrambling is disabled
	
	output [7:0] data_out,
	output 		 k_out// when 1, the output is control character
	);

localparam LFSR_INT = 16'hFFFF;

reg [15:0] lfsr,lfsr_nxt;
reg [15:0] lfsr_int;
wire 	   initializa_scrambler,pause_scramber;
reg	[7:0]  data_out,data_out_nxt;
wire[7:0]  data_out_int;

assign lfsr_int[0]   = lfsr[8];
assign lfsr_int[1]   = lfsr[9];
assign lfsr_int[2]   = lfsr[10];
assign lfsr_int[3]   = lfsr[8] ^ lfsr[11];
assign lfsr_int[4]   = lfsr[8] ^ lfsr[9]  ^ [12] ;
assign lfsr_int[5]   = lfsr[8] ^ lfsr[9]  ^ [10] ^ lsfr[13];
assign lfsr_int[6]   = lfsr[9] ^ lfsr[10] ^ [11] ^ lsfr[14];
assign lfsr_int[7]   = lfsr[10]^ lfsr[11] ^ [12] ^ lsfr[15];
assign lfsr_int[8]   = lfsr[0] ^ lfsr[11] ^ [12] ^ lsfr[13];
assign lfsr_int[9]	 = lfsr[1] ^ lfsr[12] ^ [13] ^ lsfr[14];
assign lfsr_int[10]  = lfsr[2] ^ lfsr[13] ^ [14] ^ lsfr[15];
assign lfsr_int[11]  = lfsr[3] ^ lfsr[14] ^ [15] ;
assign lfsr_int[12]  = lfsr[4] ^ lfsr[15];
assign lfsr_int[13]  = lfsr[5];
assign lfsr_int[14]  = lfsr[6];
assign lfsr_int[15]  = lfsr[7];
//***********************************
assign initializa_scrambler = (data_in == 8'hBC)&&(k_in == 1);//COM char
assign pause_scramber		= (data_in == 8'h1C)&&(k_in == 1);//SKP char

always@(*)
 begin
	  lfsr_nxt=lfsr;
	  if(disab_scram|pause_scramber)
		lfsr_nxt=lfsr;
	  else if(initializa_scrambler)
		lfsr_nxt=LFSR_INT;
	  else
		lfsr_nxt=lfsr_int;
end
//flop inference
always@(posedge clk or negedge rstb)
 begin
	  if(!rstb)
		lfsr<=LFSR_INT;
	  else
		lfsr<=lfsr_nxt;
 end

assign data_out_int[0]   =   data_in[0] ^ lfsr[15] ;
assign data_out_int[1]   =   data_in[1] ^ lfsr[14] ;
assign data_out_int[2]   =   data_in[2] ^ lfsr[13] ;
assign data_out_int[3]   =   data_in[3] ^ lfsr[12] ;
assign data_out_int[4]   =   data_in[4] ^ lfsr[11] ;
assign data_out_int[5]   =   data_in[5] ^ lfsr[10] ;
assign data_out_int[6]   =   data_in[6] ^ lfsr[9] ;
assign data_out_int[7]   =   data_in[7] ^ lfsr[8] ;

always@(*)
 begin
	  data_out_nxt = data_out_int;
	  if(disab_scram|k_in)
		data_out_nxt = data_in;
	  else
		data_out_nxt = data_out_int;
end

always@(posedge clk or negedge rstb)
 begin
	  if(!rstb)
		data_out<='d0;
	  else
		data_out<=data_out_nxt;
 end
 
 endmodule