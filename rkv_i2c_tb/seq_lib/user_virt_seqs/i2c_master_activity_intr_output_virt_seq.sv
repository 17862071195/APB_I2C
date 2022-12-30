`ifndef I2C_MASTER_ACTIVITY_INTR_OUTPUT_VIRT_SEQ_SV
`define I2C_MASTER_ACTIVITY_INTR_OUTPUT_VIRT_SEQ_SV

class i2c_master_activity_intr_output_virt_seq extends rkv_i2c_base_virtual_sequence;
  `uvm_object_utils(i2c_master_activity_intr_output_virt_seq)

  function new(string name="i2c_master_activity_intr_output_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    super.body();
    `uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW)
    vif.wait_rstn_release();    
    vif.wait_apb(10);

    `uvm_do_on_with(apb_cfg_seq, p_sequencer.apb_mst_sqr, {
                    SPEED == 1;
										IC_10BITADDR_MASTER == 0;
										IC_TAR == `LVC_I2C_SLAVE0_ADDRESS;
                    IC_FS_SCL_HCNT == 200;
                    IC_FS_SCL_LCNT == 200;
										ENABLE == 1;})
    rgm.IC_INTR_MASK.M_ACTIVITY.set(1);
    rgm.IC_INTR_MASK.M_START_DET.set(1);
    rgm.IC_INTR_MASK.M_STOP_DET.set(1);
    rgm.IC_INTR_MASK.update(status);

    fork     
      `uvm_do_on_with(apb_intr_wait_seq, p_sequencer.apb_mst_sqr, {intr_id == IC_START_DET_INTR_ID;})
      `uvm_do_on_with(apb_intr_wait_seq, p_sequencer.apb_mst_sqr, {intr_id == IC_ACTIVITY_INTR_ID;})
      `uvm_do_on_with(apb_intr_wait_seq, p_sequencer.apb_mst_sqr, {intr_id == IC_STOP_DET_INTR_ID;})
      `uvm_do_on_with(apb_write_packet_seq, 
                      p_sequencer.apb_mst_sqr,
                     {packet.size() == 5; 
                      packet[0] == 8'b1111_0000;
                      packet[1] == 8'b0101_0101;
                      packet[2] == 8'b0101_1111;
                      packet[3] == 8'b0101_1100;
                      packet[4] == 8'b0101_0011;
                     })
      `uvm_do_on(i2c_slv_write_resp_seq, p_sequencer.i2c_slv_sqr)
    join  
    if(vif.get_intr(IC_START_DET_INTR_ID) === 1'b1) `uvm_info("INTRSUCES","R_START_DET signal set high successfully", UVM_LOW)
    else  `uvm_error("INTRERR", "R_START_DET signal is not high !!!")
    if(vif.get_intr(IC_ACTIVITY_INTR_ID) === 1'b1) `uvm_info("INTRSUCES","R_ACTIVITY_DET signal set high successfully", UVM_LOW)
    else  `uvm_error("INTRERR", "R_ACTIVITY_DET signal is not high !!!")
    if(vif.get_intr(IC_STOP_DET_INTR_ID) === 1'b1) `uvm_info("INTRSUCES","R_STOP_DET signal set high successfully", UVM_LOW)
    else  `uvm_error("INTRERR", "R_STOP_DET signal is not high !!!")
   
    `uvm_do_on_with(apb_intr_clear_seq,p_sequencer.apb_mst_sqr,{intr_id == IC_ACTIVITY_INTR_ID;})
    `uvm_do_on_with(apb_intr_clear_seq,p_sequencer.apb_mst_sqr,{intr_id == IC_START_DET_INTR_ID;})
    `uvm_do_on_with(apb_intr_clear_seq,p_sequencer.apb_mst_sqr,{intr_id == IC_STOP_DET_INTR_ID;})   

    `uvm_do_on(apb_wait_empty_seq, p_sequencer.apb_mst_sqr)
    
    #10us;
    
    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
  endtask

endclass

`endif
