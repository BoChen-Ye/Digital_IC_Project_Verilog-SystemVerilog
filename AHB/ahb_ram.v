module ahb_ram(
	input         HCLK,
    input         HSEL,
    input  [16:2] HADDR,
    input         HWRITE,
    input  [31:0] HWDATA,
    
	output [31:0] HRDATA
);

  reg [31:0] ram[32767:0]; // 128KB RAM organized as 32K x 32 bits 
  
  assign HRDATA = ram[HADDR];
  
  always@(posedge HCLK)
    if (HWRITE & HSEL) ram[HADDR] <= HWDATA;
	
endmodule