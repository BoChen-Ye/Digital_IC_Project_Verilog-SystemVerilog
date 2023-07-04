module ahb_gpio(input  logic        HCLK,
                input  logic        HRESETn,
                input  logic        HSEL,
                input  logic        HADDR,
                input  logic        HWRITE,
                input  logic [31:0] HWDATA,
                output logic [31:0] HRDATA,
                inout  tri   [31:0] pins);

  logic [31:0] gpio[1:0];     // GPIO registers

  // write selected register
  always_ff @(posedge HCLK or negedge HRESETn)
    if (~HRESETn) begin
      gpio[0] <= 32'b0;  // GPIO_PORT
      gpio[1] <= 32'b0;  // GPIO_DIR
    end else if (HWRITE & HSEL)
      gpio[HADDR] <= HWDATA;
    
  // read selected register
  assign HRDATA = HADDR ? gpio[1] : pins;
  
  // No graceful way to control tristates on a per-bit basis in SystemVerilog
  genvar i;
  generate
    for (i=0; i<32; i=i+1) begin: pinloop
      assign pins[i] = gpio[1][i] ? gpio[0][i] : 1'bz;
    end
  endgenerate
endmodule