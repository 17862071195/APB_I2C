
`ifndef RKV_I2C_USER_TESTS_SVH
`define RKV_I2C_USER_TESTS_SVH
	`include "master_address_cg_test.sv"
	`include "i2c_master_ss_scl_cnt_test.sv"
	`include "i2c_master_fs_scl_cnt_test.sv"
	`include "i2c_master_hs_scl_cnt_test.sv"
	`include "i2c_master_sda_control_cg_test.sv"
	`include "i2c_master_enabled_cg_test.sv"
	`include "i2c_master_tx_abrt_intr_test.sv"
	`include "i2c_master_activity_intr_output_test.sv"
	`include "i2c_master_tx_empty_intr_test.sv"

`endif // RKV_I2C_USER_TESTS_SVH

