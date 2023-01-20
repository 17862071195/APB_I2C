`ifndef I2C_MASTER_FS_SCL_CNT_SEQ_SV
`define I2C_MASTER_FS_SCL_CNT_SEQ_SV

class i2c_master_fs_scl_cnt_seq extends rkv_i2c_base_virtual_sequence;
	`uvm_object_utils(i2c_master_fs_scl_cnt_seq)
	function new(string name ="i2c_master_fs_scl_cnt_seq");
		super.new(name);
	endfunction
	
	virtual task body();
		`uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW);
		super.body();
		vif.wait_rstn_release();
		vif.wait_apb(10);
		
		cfg.i2c_cfg.slave_cfg[0].bus_speed = lvc_i2c_pkg::FAST_MODE;
		env.i2c_slv.reconfigure_via_task(cfg.i2c_cfg.slave_cfg[0]);
		
		// Spike suppression
		// IC_FS_SPKLEN can be written to only when the DW_apb_i2c is disabled. 
		// result of setting is 1, when writing data is 0. 
		rgm.IC_FS_SPKLEN.mirror(status);
		rgm.IC_FS_SPKLEN.IC_FS_SPKLEN.set(0);		rgm.IC_FS_SPKLEN.update(status);
		rgm.IC_FS_SPKLEN.mirror(status);
		
		// SCL_HCNT must be configuration, before IC_ENABLE[0] register being set to 0.
		// minimum valid value is 6.
		// IC_HC_COUNT_VALUES is set to 1, SCL_HCNT is read only.
		`uvm_do_on_with(apb_cfg_seq, p_sequencer.apb_mst_sqr, {
										SPEED == 2;
										IC_10BITADDR_MASTER == 0;
										IC_TAR == `LVC_I2C_SLAVE0_ADDRESS;
										ENABLE == 1;})
//	  fork
//			`uvm_do_on(i2c_slv_write_resp_seq, p_sequencer.i2c_slv_sqr)
//		join_none
		`uvm_do_on_with(apb_write_packet_seq, p_sequencer.apb_mst_sqr, {
									  packet.size() == 1;
									  packet[0] == 8'b1111_0000;})
		`uvm_do_on(i2c_slv_write_resp_seq, p_sequencer.i2c_slv_sqr)
		`uvm_do_on(apb_usr_wat_ept_seq, p_sequencer.apb_mst_sqr)
		
		#10us;
		
		//test 400kbs in FS mode
		rgm.IC_ENABLE.ENABLE.set(0);  rgm.IC_ENABLE.update(status);
		rgm.IC_FS_SCL_HCNT.IC_FS_SCL_HCNT.set(125);  rgm.IC_FS_SCL_HCNT.update(status);
	  rgm.IC_FS_SCL_LCNT.IC_FS_SCL_LCNT.set(125);  rgm.IC_FS_SCL_LCNT.update(status);
	  rgm.IC_ENABLE.ENABLE.set(1);  rgm.IC_ENABLE.update(status);
//	  fork
//			`uvm_do_on(i2c_slv_write_resp_seq, p_sequencer.i2c_slv_sqr)
//		join_none
		`uvm_do_on_with(apb_write_packet_seq, p_sequencer.apb_mst_sqr, {
									  packet.size() == 1;
									  packet[0] == 8'b1010_1010;})
		`uvm_do_on(i2c_slv_write_resp_seq, p_sequencer.i2c_slv_sqr)
		`uvm_do_on(apb_usr_wat_ept_seq, p_sequencer.apb_mst_sqr)
	  
	  #10us;
	  
	  //test 100kbs in FS mode
		rgm.IC_ENABLE.ENABLE.set(0);  rgm.IC_ENABLE.update(status);
		rgm.IC_FS_SCL_HCNT.IC_FS_SCL_HCNT.set(450);  rgm.IC_FS_SCL_HCNT.update(status);
	  rgm.IC_FS_SCL_LCNT.IC_FS_SCL_LCNT.set(450);  rgm.IC_FS_SCL_LCNT.update(status);
	  rgm.IC_ENABLE.ENABLE.set(1);  rgm.IC_ENABLE.update(status);
//	  fork
//			`uvm_do_on(i2c_slv_write_resp_seq, p_sequencer.i2c_slv_sqr)
//		join_none
		`uvm_do_on_with(apb_write_packet_seq, p_sequencer.apb_mst_sqr, {
									  packet.size() == 1;
									  packet[0] == 8'b1100_1100;})
		`uvm_do_on(i2c_slv_write_resp_seq, p_sequencer.i2c_slv_sqr)
		`uvm_do_on(apb_wait_empty_seq, p_sequencer.apb_mst_sqr)
		
		`uvm_info(get_type_name(), "=====================FINIkSHED=====================", UVM_LOW);
	endtask
endclass
`endif 

