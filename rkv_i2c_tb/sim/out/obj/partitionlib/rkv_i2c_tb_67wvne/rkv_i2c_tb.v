
/* Source file "
	/home/verifier/Code_VCS/MyIIC/rkv_i2c_tb/sim/out/obj/partitionlib/rkv_i2c_tb_67wvne/rkv_i2c_tb.v
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
	reg			_vcs_dummy_apb_if_node;
	reg			_vcs_dummy_i2c_if_node;

	initial begin : XmrProcess
	  $$xmr_referee_defparam(0, "rkv_DW_apb_i2c_bcm41", "VERIF_EN");
	  $$xmr_referee_defparam(1, "rkv_i2c_tb", 
		  rkv_i2c_tb.dut.U_DW_apb_i2c_intctl.U_DW_apb_i2c_bcm41_ic2pl_ic_disable_psyzr.U_SYNC,
		  "F_SYNC_TYPE");
	  $$xmr_referee_defparam(1, "rkv_i2c_tb", 
		  rkv_i2c_tb.dut.U_DW_apb_i2c_rx_filter.U_DW_apb_i2c_bcm41_async2icl_ic_clk_in_a_icsyzr.U_SYNC,
		  "F_SYNC_TYPE");
	  $$xmr_referee_defparam(1, "rkv_i2c_tb", 
		  rkv_i2c_tb.dut.U_DW_apb_i2c_rx_filter.U_DW_apb_i2c_bcm41_async2icl_ic_data_in_a_icsyzr.U_SYNC,
		  "F_SYNC_TYPE");
	  $$xmr_referee_defparam(1, "rkv_i2c_tb", 
		  rkv_i2c_tb.dut.U_DW_apb_i2c_rx_filter.U_DW_apb_i2c_bcm41_async2icl_ic_clk_in_a_icsyzr.U_SYNC,
		  "VERIF_EN");
	  $$xmr_referee_defparam(1, "rkv_i2c_tb", 
		  rkv_i2c_tb.dut.U_DW_apb_i2c_rx_filter.U_DW_apb_i2c_bcm41_async2icl_ic_data_in_a_icsyzr.U_SYNC,
		  "VERIF_EN");
	  $$xmr_map_info("rkv_i2c_tb", "top_if.debug_rd", "top_if", 1, 1, 0, 
		  "top_if.debug_wr", "top_if", 1, 1, 0, 
		  "top_if.ic_current_src_en", "top_if", 1, 1, 0, 
		  "top_if.debug_p_gen", "top_if", 1, 1, 0, "apb_if.pwrite", 
		  "apb_if", 1, 1, 0, "apb_if.pwdata", "apb_if", 1, 1, 0, 
		  "top_if.i2c_clk", "top_if", 1, 1, 0, "apb_if.psel", "apb_if", 
		  1, 1, 0, "i2c_if.SCL", "i2c_if", 1, 1, 0, 
		  "top_if.debug_slave_act", "top_if", 1, 1, 0, 
		  "top_if.debug_s_gen", "top_if", 1, 1, 0, "top_if.debug_addr", 
		  "top_if", 1, 1, 0, "i2c_if.SDA", "i2c_if", 1, 1, 0, 
		  "top_if.debug_slv_cstate", "top_if", 1, 1, 0, 
		  "top_if.debug_hs", "top_if", 1, 1, 0, "i2c_if.RST", "i2c_if", 
		  1, 1, 0, "top_if.apb_rstn", "top_if", 1, 1, 0, 
		  "apb_if.pready", "apb_if", 1, 1, 0, "top_if.i2c_rstn", 
		  "top_if", 1, 1, 0, "apb_if.penable", "apb_if", 1, 1, 0, 
		  "apb_if.paddr", "apb_if", 1, 1, 0, "top_if.debug_data", 
		  "top_if", 1, 1, 0, "top_if.intr", "top_if", 1, 1, 0, 
		  "apb_if.prdata", "apb_if", 1, 1, 0, "apb_if.pslverr", 
		  "apb_if", 1, 1, 0, "top_if.ic_en", "top_if", 1, 1, 0, 
		  "top_if.debug_master_act", "top_if", 1, 1, 0, 
		  "top_if.debug_mst_cstate", "top_if", 1, 1, 0, 
		  "top_if.debug_addr_10bit", "top_if", 1, 1, 0, 
		  "top_if.apb_clk", "top_if", 1, 1, 0);
	end
endmodule
