
`ifndef RKV_I2C_USER_VIRTUAL_SEQUENCES_SVH
`define RKV_I2C_USER_VIRTUAL_SEQUENCES_SVH
	
`include "master_address_cg_virt_seq.sv"
`include "i2c_master_ss_scl_cnt_seq.sv"
`include "i2c_master_fs_scl_cnt_seq.sv"
`include "i2c_master_hs_scl_cnt_seq.sv"
`include "i2c_master_sda_control_cg_virt_seq.sv"
`include "i2c_master_enabled_cg_virt_seq.sv"
`include "i2c_master_tx_abrt_intr_virt_seq.sv"
`include "i2c_master_activity_intr_output_virt_seq.sv"
`include "i2c_master_tx_empty_intr_virt_seq.sv"

`endif // RKV_I2C_USER_VIRTUAL_SEQUENCES_SVH

