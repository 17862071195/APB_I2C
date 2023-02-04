`ifndef I2C_MASTER_ABRT_10B_RD_NORSTRT_VIRT_SEQ_SV
`define I2C_MASTER_ABRT_10B_RD_NORSTRT_VIRT_SEQ_SV

class i2c_master_abrt_10b_rd_norstrt_virt_seq extends rkv_i2c_base_virtual_sequence;
  `uvm_object_utils(i2c_master_abrt_10b_rd_norstrt_virt_seq)

  function new(string name="i2c_master_abrt_10b_rd_norstrt_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    super.body();
    `uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW)
    vif.wait_rstn_release();    
    vif.wait_apb(10);

    cfg.i2c_cfg.slave_cfg[0].enable_10bit_addr = 1;
    env.i2c_slv.reconfigure_via_task(cfg.i2c_cfg.slave_cfg[0]);
    rgm.IC_CON.IC_RESTART_EN.set(0);
    rgm.IC_CON.update(status);

    `uvm_do_on_with(apb_cfg_seq, 
                    p_sequencer.apb_mst_sqr,
                    {SPEED == 2;
                    IC_10BITADDR_MASTER == 1;
                    IC_TAR == `LVC_I2C_SLAVE0_ADDRESS;
                    IC_FS_SCL_HCNT == 200;
                    IC_FS_SCL_LCNT == 200;
                    ENABLE == 1;
                  })
    fork
      `uvm_do_on_with(apb_read_packet_seq, 
                      p_sequencer.apb_mst_sqr,
                     {packet.size() == 6; 
                     })
      `uvm_do_on_with(i2c_slv_read_resp_seq, 
                      p_sequencer.i2c_slv_sqr,
                     {packet.size() == 6; 
                      packet[0] == 8'b0000_0001;
                      packet[1] == 8'b0000_0010;
                      packet[2] == 8'b0000_0011;
                      packet[3] == 8'b0000_0100;
                      packet[4] == 8'b0000_0101;
                      packet[5] == 8'b0000_0110;
                     })
    join_none
    rgm.IC_INTR_STAT.mirror(status);
     
    `uvm_do_on_with(apb_intr_wait_seq, p_sequencer.apb_mst_sqr, {intr_id == IC_TX_ABRT_INTR_ID;})
    #1us;
    if(vif.get_intr(IC_TX_ABRT_INTR_ID) === 1'b1) begin
      rgm.IC_TX_ABRT_SOURCE.mirror(status);
      if(rgm.IC_TX_ABRT_SOURCE.ABRT_10B_RD_NORSTRT.get() == 1) 
        `uvm_info("INTRSUCES","ABRT_10B_RD_NORSTRT set 1 successfully", UVM_LOW) 
      else `uvm_error("INTRERR", "ABRT_10B_RD_NORSTRT is not 1 !!!")
    end
    else  `uvm_error("INTRERR", "ABRT_10B_RD_NORSTRT is not 1 !!!")

    //`uvm_do_on(apb_wait_empty_seq, p_sequencer.apb_mst_sqr)
    #10us;
    
    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
  endtask

endclass

`endif
