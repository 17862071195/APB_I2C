
/* Source file "
	/home/verifier/DVT_Code/APB_I2C/rkv_i2c_tb/sim/out/obj/partitionlib/_SNPS_VCS_intf_repository/_SNPS_VCS_intf_repository.v
	", line 1 */
(* VCS_LogicalLibrary = "VCS_PARTCOMP_LIB" *)
config pc__SNPS_VCS_intf_repository_config;
	design pc__SNPS_VCS_intf_repository;
	instance pc__SNPS_VCS_intf_repository.DEFAULT_lvc_apb_if liblist DEFAULT
		;
	instance pc__SNPS_VCS_intf_repository.DEFAULT_lvc_i2c_if liblist DEFAULT
		;
	instance pc__SNPS_VCS_intf_repository.DEFAULT_rkv_i2c_if liblist DEFAULT
		;
endconfig
`timescale 1ns/1ps
`noportcoerce
`noinline
/* Source file "", line 0 */

(* PARTCOMP_WRAPPER = 1 *) 
(* VCS_LogicalLibrary = "VCS_PARTCOMP_LIB" *)

`timescale 1ns/1ps
(* orig_name = "pc__SNPS_VCS_intf_repository" *)
module pc__SNPS_VCS_intf_repository;

	lvc_apb_if DEFAULT_lvc_apb_if();
	lvc_i2c_if DEFAULT_lvc_i2c_if();
	rkv_i2c_if DEFAULT_rkv_i2c_if();

	initial begin : XmrProcess
	  $$shared_interface("rkv_i2c_if", "rkv_i2c_if_1146083354_12", 
		  "lvc_apb_if", "lvc_apb_if_1146083354_12", "lvc_i2c_if", 
		  "lvc_i2c_if_1146083354_12");
	end
endmodule
