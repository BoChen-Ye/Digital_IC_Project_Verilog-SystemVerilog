module shifter(
	input [7:0] sig_xyz,
	output[7:0] sig_xyz_shift_lft3,sig_xyz_shift_rght3,
);

assign sig_xyz_shift_lft3  = sig_xyz << 3; //low 3 bits are zero
assign sig_xyz_shift_rght3 = sig_xyz >> 3;// upper 3 bits are zero

assign sig_xyz_rot_lft3 = {sig_xyz[4:0],sig_xyz[7:5]}//[7:5] not dropped
assign sig_xyz_rot_rhgt3= {sig_xyz[2:0],sig_xyz[7:3]}

endmodule