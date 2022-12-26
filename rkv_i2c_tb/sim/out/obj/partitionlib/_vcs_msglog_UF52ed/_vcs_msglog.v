
/* Source file "
	/home/verifier/DVT_Code/APB_I2C/rkv_i2c_tb/sim/out/obj/partitionlib/_vcs_msglog_UF52ed/_vcs_msglog.v
	", line 1 */
(* VCS_LogicalLibrary = "VCS_PARTCOMP_LIB" *)
config pc__vcs_msglog_config;
	design pc__vcs_msglog;
	cell uvm_pkg liblist DEFAULT;
	cell _vcs_msglog liblist DEFAULT;
	cell lvc_apb_pkg liblist DEFAULT;
	cell lvc_i2c_pkg liblist DEFAULT;
	cell rkv_i2c_pkg liblist DEFAULT;
endconfig
`timescale 1ps/1ps
/* Source file "", line 0 */

(* PARTCOMP_PKG_WRAPPER = 1 *) 
(* VCS_LogicalLibrary = "VCS_PARTCOMP_LIB" *)

`timescale 1ps/1ps
(* orig_name = "pc__vcs_msglog" *)
module pc__vcs_msglog;

	initial begin : XmrProcess
	  $$compile_pkg(1, "", "_vcs_msglog", 1, "", "lvc_apb_pkg", 1, "", 
		  "lvc_i2c_pkg", 1, "", "rkv_i2c_pkg", 1, "", "uvm_pkg");
	end
endmodule
