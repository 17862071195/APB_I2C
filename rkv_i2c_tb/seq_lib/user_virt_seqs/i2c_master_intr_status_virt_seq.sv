`ifndef I2C_MASTER_INTR_STATUS_VIRT_SEQ_SV
`define I2C_MASTER_INTR_STATUS_VIRT_SEQ_SV
	class i2c_master_intr_status_virt_seq extends rkv_i2c_base_virtual_sequence;
		`uvm_object_utils(i2c_master_intr_status_virt_seq)
		
		function new(string name="i2c_master_intr_status_virt_seq");
			super.new(name);
		endfunction
		
		virtual task body();
			`uvm_info(get_type_name(),"=====================STARTED=====================",UVM_LOW)
			super.body();
			vif.wait_rstn_release();
			vif.wait_apb(10);

      cfg.i2c_cfg.slave_cfg[0].enable_10bit_addr = 1;
      env.i2c_slv.reconfigure_via_task(cfg.i2c_cfg.slave_cfg[0]);
      rgm.IC_CON.IC_RESTART_EN.set(0);
      rgm.IC_CON.update(status);
      
      //i2c_master_start_byte_virt_seq.sv



			`uvm_info(get_type_name(),"====================FINIkSHED====================",UVM_LOW)
		endtask
				
	endclass

`endif //I2C_MASTER_INTR_STATUS_VIRT_SEQ_SV
