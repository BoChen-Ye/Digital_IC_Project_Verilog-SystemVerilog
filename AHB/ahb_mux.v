module ahb_mux(
	input  [3:0]  HSEL,
    input  [31:0] HRDATA0, HRDATA1, HRDATA2, HRDATA3,
               
	output [31:0] HRDATA
);
               
  always@(*)
    casez(HSEL)
      4'b???1: HRDATA = HRDATA0;
      4'b??10: HRDATA = HRDATA1;
      4'b?100: HRDATA = HRDATA2;
      4'b1000: HRDATA = HRDATA3;
    endcase
endmodule