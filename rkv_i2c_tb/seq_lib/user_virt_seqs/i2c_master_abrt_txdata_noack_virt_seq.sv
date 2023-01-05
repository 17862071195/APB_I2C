`ifndef I2C_MASTER_ABRT_TXDATA_NOACK_VIRT_SEQ_SV
`define I2C_MASTER_ABRT_TXDATA_NOACK_VIRT_SEQ_SV

class i2c_master_abrt_txdata_noack_virt_seq extends rkv_i2c_base_virtual_sequence;
  `uvm_object_utils(i2c_master_abrt_txdata_noack_virt_seq)

  function new(string name="i2c_master_abrt_txdata_noack_virt_seq");
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
                    IC_FS_SCL_HCNT == 200;
                    IC_FS_SCL_LCNT == 200;
										ENABLE == 1;})
    fork
      `uvm_do_on_with(i2c_slv_write_resp_seq,p_sequencer.i2c_slv_sqr,{nack_data == 1;})
      `uvm_do_on_with(apb_write_packet_seq, p_sequencer.apb_mst_sqr,
                     {packet.size() == 1;
                      packet[0] == 8'b01011101;
                     })
    join
    `uvm_do_on_with(apb_write_packet_seq, p_sequencer.apb_mst_sqr,
                   {packet.size() == 1;
                    packet[0] == 8'b01011101;
                   })

    `uvm_do_on_with(apb_intr_wait_seq, p_sequencer.apb_mst_sqr, {intr_id == IC_TX_ABRT_INTR_ID;})

    #1us;
    if(vif.get_intr(IC_TX_ABRT_INTR_ID) === 1'b1) begin
      rgm.IC_TX_ABRT_SOURCE.mirror(status);
      if(rgm.IC_TX_ABRT_SOURCE.ABRT_TXDATA_NOACK.get() == 1) 
        `uvm_info("INTRSUCES","ABRT_TXDATA_NOACK set 1 successfully", UVM_LOW) 
      else `uvm_error("INTRERR", "ABRT_TXDATA_NOACK is not 1 !!!")
    end
    else  `uvm_error("INTRERR", "ABRT_TXDATA_NOACK is not 1 !!!")

    `uvm_info("INTRSUCES",$sformatf("%b",rgm.IC_TX_ABRT_SOURCE.get()), UVM_LOW)

    
    #10us;
    
    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
  endtask

endclass

`endif
