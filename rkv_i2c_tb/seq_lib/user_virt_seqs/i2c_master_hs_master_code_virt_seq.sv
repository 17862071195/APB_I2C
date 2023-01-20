`ifndef I2C_MASTER_HS_MASTER_CODE_VIRT_SEQ_SV
`define I2C_MASTER_HS_MASTER_CODE_VIRT_SEQ_SV
	class i2c_master_hs_master_code_virt_seq extends rkv_i2c_base_virtual_sequence;
		`uvm_object_utils(i2c_master_hs_master_code_virt_seq)
		
		function new(string name="i2c_master_hs_master_code_virt_seq");
			super.new(name);
		endfunction
		
		virtual task body();
			`uvm_info(get_type_name(),"=====================STARTED=====================",UVM_LOW)
			super.body();
			vif.wait_rstn_release();
			vif.wait_apb(10);
			
      cfg.i2c_cfg.slave_cfg[0].bus_speed = lvc_i2c_pkg::HIGHSPEED_MODE;
      env.i2c_slv.reconfigure_via_task(cfg.i2c_cfg.slave_cfg[0]);

      //read reset value of IC_*_SPKLIN
			//configurate HCNT LCNT SPEED of i2c ip 
      //rgm.IC_FS_SPKLEN.mirror(status);
      //rgm.IC_HS_SPKLEN.mirror(status);

      //set 0 to IC_HS_SPKLEN and IC_FS_SPLKEN adn cehck minimum value of them.
      rgm.IC_FS_SPKLEN.mirror(status);
      rgm.IC_HS_SPKLEN.mirror(status);
      rgm.IC_FS_SPKLEN.IC_FS_SPKLEN.set(0);
      rgm.IC_HS_SPKLEN.IC_HS_SPKLEN.set(0);
      rgm.IC_FS_SPKLEN.update(status);
      rgm.IC_HS_SPKLEN.update(status);
      rgm.IC_FS_SPKLEN.mirror(status);
      rgm.IC_HS_SPKLEN.mirror(status);
      if(rgm.IC_FS_SPKLEN.IC_FS_SPKLEN.get() != 1) `uvm_error("COMPERR", "IC_FS_SPKLEN is not 1 after writeing 0 to its !!!")
      if(rgm.IC_HS_SPKLEN.IC_HS_SPKLEN.get() != 1) `uvm_error("COMPERR", "IC_HS_SPKLEN is not 1 after writeing 0 to its !!!")
      
      `uvm_do_on_with(apb_user_cfg_seq, 
                 p_sequencer.apb_mst_sqr,
                 {SPEED == 3;
                 IC_10BITADDR_MASTER == 0;
                 IC_TAR == `LVC_I2C_SLAVE0_ADDRESS;
                 ENABLE == 1;})   
    
    `uvm_do_on_with(apb_write_packet_seq, 
                    p_sequencer.apb_mst_sqr,
                   {packet.size() == 1; 
                    packet[0] inside {[2'h00:2'hFF]};
                   })      
    `uvm_do_on(i2c_slv_write_resp_seq, p_sequencer.i2c_slv_sqr)

    `uvm_do_on(apb_wait_empty_seq, p_sequencer.apb_mst_sqr)
    #10us;

    //IC_HS_MADDR test
    rgm.IC_ENABLE.ENABLE.set(0);
    rgm.IC_ENABLE.update(status);
    rgm.IC_HS_MADDR.IC_HS_MAR.set(0);
    rgm.IC_HS_MADDR.update(status);
    `uvm_do_on_with(apb_user_cfg_seq, 
                 p_sequencer.apb_mst_sqr,
                 {SPEED == 3;
                 IC_10BITADDR_MASTER == 0;
                 IC_TAR == `LVC_I2C_SLAVE0_ADDRESS;
                 ENABLE == 1;})   
     `uvm_do_on_with(apb_write_packet_seq, 
                 p_sequencer.apb_mst_sqr,
                {packet.size() == 1; 
                 packet[0] inside {[2'h00:2'hFF]};
                })
    `uvm_do_on(i2c_slv_write_resp_seq, p_sequencer.i2c_slv_sqr)
    `uvm_do_on(apb_wait_empty_seq, p_sequencer.apb_mst_sqr)
    #10us;

    rgm.IC_ENABLE.ENABLE.set(0);
    rgm.IC_ENABLE.update(status);
    rgm.IC_HS_MADDR.IC_HS_MAR.set(7);
    rgm.IC_HS_MADDR.update(status);
    rgm.IC_ENABLE.ENABLE.set(1);
    rgm.IC_ENABLE.update(status);
     `uvm_do_on_with(apb_write_packet_seq, 
                 p_sequencer.apb_mst_sqr,
                {packet.size() == 1; 
                 packet[0] inside {[2'h00:2'hFF]};
                })
    `uvm_do_on(i2c_slv_write_resp_seq, p_sequencer.i2c_slv_sqr)
    `uvm_do_on(apb_wait_empty_seq, p_sequencer.apb_mst_sqr)
    #10us;


			`uvm_info(get_type_name(),"====================FINIkSHED====================",UVM_LOW)
		endtask
				
	endclass

`endif //I2C_MASTER_HS_MASTER_CODE_VIRT_SEQ_SV
