`ifndef I2C_MASTER_TX_FULL_INTR_VIRT_SEQ_SV
`define I2C_MASTER_TX_FULL_INTR_VIRT_SEQ_SV

class i2c_master_tx_full_intr_virt_seq extends rkv_i2c_base_virtual_sequence;
  `uvm_object_utils(i2c_master_tx_full_intr_virt_seq)

  function new(string name="i2c_master_tx_full_intr_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
    super.body();
    `uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW)
    vif.wait_rstn_release();    
    vif.wait_apb(10);

    rgm.IC_TX_TL.TX_TL.set(3);
    rgm.IC_TX_TL.update(status);
    `uvm_do_on_with(apb_cfg_seq, p_sequencer.apb_mst_sqr, {
                    SPEED == 2;
                    IC_10BITADDR_MASTER == 0;
                    IC_RESTART_EN == 0;
                    TX_EMPTY_CTRL == 1;
                    IC_TAR == `LVC_I2C_SLAVE0_ADDRESS;
                    SPECIAL == 1;
                    GC_OR_START == 1;
                    IC_FS_SCL_HCNT == 200;
                    IC_FS_SCL_LCNT == 200;
									//	IC_10BITADDR_MASTER == 0;
									//	IC_TAR == `LVC_I2C_SLAVE0_ADDRESS;
                  //  IC_FS_SCL_HCNT == 200;
                  //  IC_FS_SCL_LCNT == 200;
										ENABLE == 0;})

    //rgm.IC_INTR_MASK.M_TX_OVER.set(0);
    //rgm.IC_INTR_MASK.update(status);

    rgm.IC_COMP_PARAM_1.mirror(status);
    rgm.IC_INTR_MASK.mirror(status);
    `uvm_info("VALUE",$sformatf("TX_BUFFER_DEPTH ========================================= %d", rgm.IC_COMP_PARAM_1.TX_BUFFER_DEPTH.get()), UVM_LOW)
    `uvm_info("VALUE",$sformatf("TX_BUFFER_DEPTH ========================================= %d", rgm.IC_INTR_MASK.M_TX_OVER.get()), UVM_LOW)

        rgm.IC_CLR_TX_ABRT.mirror(status);
    rgm.IC_ENABLE.ENABLE.set('h1);
    rgm.IC_ENABLE.update(status);

    fork
      `uvm_do_on_with(apb_write_nocheck_pkt_seq, p_sequencer.apb_mst_sqr,
                       {packet.size() == 10;
                        packet[0] == 8'b0000_0001;
                        packet[1] == 8'b0000_0010;
                        packet[2] == 8'b0000_0100;
                        packet[3] == 8'b0000_1000;
                        packet[4] == 8'b0000_1000;
                        packet[5] == 8'b0000_1000;
                        packet[6] == 8'b0000_1000;
                        packet[7] == 8'b0000_1000;
                        packet[8] == 8'b0000_1000;
                        packet[9] == 8'b0000_1000;
                         })
        //rgm.IC_TX_ABRT_SOURCE.TX_FLUSH_CNT.mirror(status);
        //rgm.IC_STATUS.mirror(status);
      `uvm_do_on_with(i2c_slv_write_resp_seq, p_sequencer.i2c_slv_sqr, {nack_data == 9;})
      //begin
      //  disable fork;
      //end
    join

   // fork
   //   `uvm_do_on_with(apb_write_nocheck_pkt_seq, p_sequencer.apb_mst_sqr,
   //                  {packet.size() == 2;
   //                   packet[0] == 8'b0000_0001;
   //                   packet[1] == 8'b0000_0010;
   //                    })
   //   //`uvm_do_on(i2c_slv_write_resp_seq, p_sequencer.i2c_slv_sqr)
   // join_none

    `uvm_info("MMM",$sformatf("%b",rgm.IC_TX_ABRT_SOURCE.get()), UVM_LOW)
  
    //`uvm_do_on_with(apb_intr_wait_seq,p_sequencer.apb_mst_sqr, {intr_id == IC_TX_OVER_INTR_ID;})
    while(1) begin
      if(vif.get_intr(IC_TX_OVER_INTR_ID) === 1'b1) begin
        `uvm_info("INTRSUCES","IC_TX_OVER_INTR signal set high successfully", UVM_LOW) 
        break;
      end
      else  `uvm_error("INTRERR", "IC_TX_OVER_INTR signal is not high !!!")
      @(vif.i2c_ck);
    end 
    #10us;
    
    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
  endtask

endclass

`endif
