
/* Source file "
	/home/verifier/Code_VCS/MyIIC/rkv_i2c_tb/sim/out/obj/partitionlib/rkv_i2c_tb_iq1u8b/rkv_i2c_tb.v
	", line 1 */
(* VCS_LogicalLibrary = "VCS_PARTCOMP_LIB" *)
config pc_rkv_i2c_tb_config;
	design pc_rkv_i2c_tb DEFAULT.rkv_i2c_tb;
	cell rkv_i2c_tb liblist DEFAULT;
endconfig
`timescale 1ns/1ps
/* Source file "", line 0 */

(* PARTCOMP_WRAPPER = 1 *) 
(* VCS_LogicalLibrary = "VCS_PARTCOMP_LIB" *)

`timescale 1ns/1ps
(* orig_name = "pc_rkv_i2c_tb" *)
module pc_rkv_i2c_tb;


	reg			_vcs_dummy_top_if_node;
	reg			_vcs_dummy_i2c_if_node;

	initial begin : XmrProcess
	  $$xmr_map_info("rkv_i2c_tb", "top_if.i2c_rstn", "top_if", 1, 1, 0, 
		  "top_if.apb_rstn", "top_if", 1, 1, 0, "i2c_if.SDA", "i2c_if", 
		  1, 1, 0, "i2c_if.SCL", "i2c_if", 1, 1, 0, "i2c_if.RST", 
		  "i2c_if", 1, 1, 0, "top_if.i2c_clk", "top_if", 1, 1, 0, 
		  "top_if.apb_clk", "top_if", 1, 1, 0);
	end
endmodule
