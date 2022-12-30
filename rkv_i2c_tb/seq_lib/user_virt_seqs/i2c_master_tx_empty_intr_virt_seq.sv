`ifndef I2C_MASTER_TX_EMPTY_INTR_VIRT_SEQ_SV
`define I2C_MASTER_TX_EMPTY_INTR_VIRT_SEQ_SV

class i2c_master_tx_empty_intr_virt_seq extends rkv_i2c_base_virtual_sequence;
  `uvm_object_utils(i2c_master_tx_empty_intr_virt_seq)

  function new(string name="i2c_master_tx_empty_intr_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    super.body();
    `uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW)
    vif.wait_rstn_release();    
    vif.wait_apb(10);

    `uvm_do_on_with(apb_user_cfg_seq, p_sequencer.apb_mst_sqr, {
                    SPEED == 1;
										IC_10BITADDR_MASTER == 0;
										IC_TAR == `LVC_I2C_SLAVE0_ADDRESS;
                    TX_EMPTY_CTRL == 1; 
                    IC_FS_SCL_HCNT == 200;
                    IC_FS_SCL_LCNT == 200;
										ENABLE == 1;})



    if(vif.get_intr(IC_START_DET_INTR_ID) === 1'b1) `uvm_info("INTRSUCES","R_START_DET signal set high successfully", UVM_LOW)
    else  `uvm_error("INTRERR", "R_START_DET signal is not high !!!")
   


    `uvm_do_on(apb_wait_empty_seq, p_sequencer.apb_mst_sqr)
    
    #10us;
    
    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
  endtask

endclass

`endif
