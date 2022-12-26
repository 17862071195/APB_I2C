`ifndef I2C_MASTER_SDA_CONTROL_CG_VIRT_SEQ_SV
`define I2C_MASTER_SDA_CONTROL_CG_VIRT_SEQ_SV

class i2c_master_sda_control_cg_virt_seq extends rkv_i2c_base_virtual_sequence;
	`uvm_object_utils(i2c_master_sda_control_cg_virt_seq)
	
	bit [15:0] hold_time[] = '{16'h0005, 16'h0032, 16'h0064};
	//int times_error_addressing = 0;
	
	function new(string name="i2c_master_sda_control_seq");
		super.new(name);
	endfunction
	
	virtual task body();
		super.body();
		`uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW)
		vif.wait_rstn_release();
		vif.wait_apb(10);
		
		`uvm_do_on_with(apb_cfg_seq, p_sequencer.apb_mst_sqr, {
										SPEED == 2;
										IC_10BITADDR_MASTER == 0;
										IC_TAR == `LVC_I2C_SLAVE0_ADDRESS;
										IC_FS_SCL_HCNT == 125;
										IC_FS_SCL_LCNT ==125;
		})
		
		// TX_HOLD
		foreach (hold_time[i]) begin			
			rgm.IC_SDA_HOLD_IC_SDA_TX_HOLD.set(hold_time[i]);  rgm.IC_SDA_HOLD.update(status);
			rgm.IC_ENABLE.ENABLE.set(1'b1);  rgm.IC_ENABLE.update(status);
			fork
				`uvm_do_on_with(apb_write_packet_seq, p_sequencer.apb_mst_sqr, {
											packet.size() == 1;
											packet[0] == 8'b11110000;})
				`uvm_do_on(i2c_slv_write_resp_seq, p_sequencer.i2c_slv_sqr)
			join
			
			#1us;
			
			fork 
				`uvm_do_on_with(apb_read_packet_seq, p_sequencer.apb_mst_sqr, {packet.size() == 1;})
				`uvm_do_on_with(i2c_slv_read_resp_seq, p_sequencer.i2c_slv_sqr, {
												packet.size()==1;
												packet[0] == 8'b10101010;})
			join	
			rgm.IC_ENABLE.ENABLE.set(0);  rgm.IC_ENABLE.update(status);
			#1us;
		end
		
		// RX_HOLD
		foreach (hold_time[i]) begin			
			rgm.IC_SDA_HOLD_IC_SDA_RX_HOLD.set(hold_time[i]);  rgm.IC_SDA_HOLD.update(status);
			rgm.IC_ENABLE.ENABLE.set(1'b1);  rgm.IC_ENABLE.update(status);
			fork
				`uvm_do_on_with(apb_write_packet_seq, p_sequencer.apb_mst_sqr, {
											packet.size() == 1;
											packet[0] == 8'b11110000;})
				`uvm_do_on(i2c_slv_write_resp_seq, p_sequencer.i2c_slv_sqr)
			join
			
			#1us;
			
			fork 
				`uvm_do_on_with(apb_read_packet_seq, p_sequencer.apb_mst_sqr, {packet.size() == 1;})
				`uvm_do_on_with(i2c_slv_read_resp_seq, p_sequencer.i2c_slv_sqr, {
												packet.size()==1;
												packet[0] == 8'b10101010;})
			join	
			rgm.IC_ENABLE.ENABLE.set(0);  rgm.IC_ENABLE.update(status);
			#1us;
		end
		
		`uvm_do_on(apb_wait_empty_seq, p_sequencer.apb_mst_sqr)
		#1us;
		`uvm_info(get_type_name(), "==================== FINISHED=====================", UVM_LOW)
	endtask
	
endclass
`endif


