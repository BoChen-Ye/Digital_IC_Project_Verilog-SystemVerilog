module ahb_rom(
	input         HCLK,
    input         HSEL,
    input  [15:2] HADDR,
	
    output [31:0] HRDATA
);

  reg [31:0] rom[16383:0]; // 64KB ROM organized as 16K x 32 bits 
  
  initial
      $readmemh("rom_contents.dat",rom);
  
  assign HRDATA = rom[HADDR];
endmodule