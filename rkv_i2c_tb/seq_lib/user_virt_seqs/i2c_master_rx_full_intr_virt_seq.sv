`ifndef I2C_MASTER_RX_FULL_INTR_VIRT_SEQ_SV
`define I2C_MASTER_RX_FULL_INTR_VIRT_SEQ_SV

class i2c_master_rx_full_intr_virt_seq extends rkv_i2c_base_virtual_sequence;
  `uvm_object_utils(i2c_master_rx_full_intr_virt_seq)

  function new(string name="i2c_master_rx_full_intr_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    super.body();
    `uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW)
    vif.wait_rstn_release();    
    vif.wait_apb(10);

    //rgm.IC_RX_TL.RX_TL.set(3);
    //rgm.IC_RX_TL.update(status);
    `uvm_do_on_with(apb_cfg_seq, 
                    p_sequencer.apb_mst_sqr,
                    {SPEED == 2;
                    IC_10BITADDR_MASTER == 0;
                    IC_TAR == `LVC_I2C_SLAVE0_ADDRESS;
                    IC_FS_SCL_HCNT == 200;
                    IC_FS_SCL_LCNT == 200;
                    ENABLE == 1;
                  })

    fork
      `uvm_do_on_with(apb_noread_pkt_seq, 
                      p_sequencer.apb_mst_sqr,
                     {packet.size() == 8; 
                     })
      `uvm_do_on_with(i2c_slv_read_resp_seq, 
                      p_sequencer.i2c_slv_sqr,
                     {packet.size() == 8; 
                      packet[0] == 8'b0000_0001;
                      packet[1] == 8'b0000_0010;
                      packet[2] == 8'b0000_0011;
                      packet[3] == 8'b0000_0100;
                      packet[4] == 8'b0000_0101;
                      packet[5] == 8'b0000_0110;
                      packet[6] == 8'b0000_0111;
                      packet[7] == 8'b0000_1000;
                     })
    join
 
    `uvm_do_on_with(apb_intr_wait_seq, p_sequencer.apb_mst_sqr, {intr_id == IC_RX_FULL_INTR_ID;})
    
    while(1) begin
      if(vif.get_intr(IC_RX_FULL_INTR_ID) === 1'b1) begin `uvm_info("INTRSUCES","IC_RX_FULL_INTR signal set high successfully", UVM_LOW) break; end
      else  `uvm_error("INTRERR", "IC_RX_FULL_INTR signal is not high !!!")
      @(vif.i2c_ck);  
    end

    //`uvm_do_on(apb_wait_empty_seq, p_sequencer.apb_mst_sqr)
    #10us;
    
    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
  endtask

endclass

`endif
