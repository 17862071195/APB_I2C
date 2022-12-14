`ifndef I2C_MASTER_TIMEOUT_CG_VIRT_SEQ_SV
`define I2C_MASTER_TIMEOUT_CG_VIRT_SEQ_SV

class i2c_master_timeout_cg_virt_seq extends rkv_i2c_base_virtual_sequence;
  `uvm_object_utils(i2c_master_timeout_cg_virt_seq)
  int apb_clk_counter = 0;

  function new(string name="i2c_master_timeout_cg_virt_seq");
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

      if(apb_vif.pslverr !== 0) `uvm_error("SIGERR","pslverr signal is high !!!")

      rgm.IC_ENABLE_ENABLE.set(0);
      rgm.IC_ENABLE.update(status);
      rgm.REG_TIMEOUT_RST.write(status,'h04);
      rgm.REG_TIMEOUT_RST.read(status,data);

      fork
        wait_pslverr();
        begin
          rgm.IC_CON.MASTER_MODE.set(1);
          rgm.IC_CON.IC_SLAVE_DISABLE.set(0);
          rgm.IC_CON.update(status);
          rgm.IC_ENABLE_ENABLE.set(1);
          rgm.IC_ENABLE.update(status);
        end  
      join  

      //`uvm_error("SIGERR","pslverr signal is slow !!!")
      
      //`uvm_do_on(apb_wait_empty_seq, p_sequencer.apb_mst_sqr)
      #1us;
      `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
  endtask

  task wait_pslverr(); 
    while(1) begin    
      if(apb_vif.pslverr === 1) begin
        `uvm_info("SIGSUCES", "pslverr signal is high !!!", UVM_LOW)
        break;
      end
      @(vif.apb_ck);
      apb_clk_counter++;
      if(apb_clk_counter > 10000) begin
        `uvm_error("SIGERR","pslverr signal is slow !!!")
        break;
      end
    end
  endtask

endclass

`endif
