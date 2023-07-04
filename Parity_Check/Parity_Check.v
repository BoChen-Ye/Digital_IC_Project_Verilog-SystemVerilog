module Parity_Check(
	input [7:0] data,
	output  even_parity,
	output  odd_parity
);

assign even_parity = ^data;// reduction XOR
assign odd_parity  = !(^data);

endmodule