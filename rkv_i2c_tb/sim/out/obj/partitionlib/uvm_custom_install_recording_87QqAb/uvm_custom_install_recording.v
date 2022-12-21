
/* Source file "
	/home/verifier/Code_VCS/MyIIC/rkv_i2c_tb/sim/out/obj/partitionlib/uvm_custom_install_recording_87QqAb/uvm_custom_install_recording.v
	", line 1 */
(* VCS_LogicalLibrary = "VCS_PARTCOMP_LIB" *)
config pc_uvm_custom_install_recording_config;
	design pc_uvm_custom_install_recording DEFAULT.
		uvm_custom_install_recording DEFAULT.
		uvm_custom_install_verdi_recording;
	cell uvm_custom_install_recording liblist DEFAULT;
	cell uvm_custom_install_verdi_recording liblist DEFAULT;
endconfig
`timescale 1ps/1ps
/* Source file "", line 0 */

(* PARTCOMP_WRAPPER = 1, PARTCOMP_DOLLAR_UNIT = "DEFAULT._vcs_unit__3820934895"
	*) 
(* VCS_LogicalLibrary = "VCS_PARTCOMP_LIB" *)

`timescale 1ps/1ps
(* orig_name = "pc_uvm_custom_install_recording" *)
module pc_uvm_custom_install_recording;

	initial begin : XmrProcess
	  $$compile_pkg(0, "", "_vcs_unit__3820934895");
	end
endmodule
