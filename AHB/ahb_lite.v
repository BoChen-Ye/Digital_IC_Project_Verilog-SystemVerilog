module ahb_lite(
	input        HCLK,
    input        HRESETn,
    input [31:0] HADDR,
    input        HWRITE,
    input [31:0] HWDATA,
	
    output[31:0] HRDATA,
    inout  tri   [31:0] pins
);
              
  wire [3:0] HSEL;
  wire [31:0] HRDATA0, HRDATA1, HRDATA2, HRDATA3;
  wire [31:0] pins_dir, pins_out, pins_in;
  wire [31:0] HADDRDEL;
  wire        HWRITEDEL;

  // Delay address and write signals to align in time with data
  flop #(32)  adrreg(HCLK, HADDR, HADDRDEL);
  flop #(1)   writereg(HCLK, HWRITE, HWRITEDEL);
  
  // Memory map decoding
  ahb_decoder dec(HADDRDEL, HSEL);
  ahb_mux     mux(HSEL, HRDATA0, HRDATA1, HRDATA2, HRDATA3, HRDATA);
  
  // Memory and peripherals
  ahb_rom     rom  (HCLK, HSEL[0], HADDRDEL[15:2], HRDATA0);
  ahb_ram     ram  (HCLK, HSEL[1], HADDRDEL[16:2], HWRITEDEL, HWDATA, HRDATA1);
  ahb_gpio    gpio (HCLK, HRESETn, HSEL[2], HADDRDEL[2], HWRITEDEL, HWDATA, HRDATA2, pins);
  ahb_timer   timer(HCLK, HRESETn, HSEL[3], HADDRDEL[4:2], HWRITEDEL, HWDATA, HRDATA3);
  
endmodule