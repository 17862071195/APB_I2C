`ifndef RKV_I2C_REG_ACCESS_VIRT_SEQ_SV
`define RKV_I2C_REG_ACCESS_VIRT_SEQ_SV
class rkv_i2c_reg_access_virt_seq extends rkv_i2c_base_virtual_sequence;

  `uvm_object_utils(rkv_i2c_reg_access_virt_seq)

  function new (string name = "rkv_i2c_reg_access_virt_seq");
    super.new(name);
  endfunction

  virtual task body();
	  reg_access_seq = new();
    `uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW)
    super.body();
    vif.wait_rstn_release();
    vif.wait_apb(10);	  
    // TODO
	  rgm.reset();
	  reg_access_seq.model = rgm;
	  reg_access_seq.start(m_sequencer);
    
    // Attach element sequences below
    `uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
    rgm.IC_ENABLE.ENABLE.set(1);
	  rgm.IC_ENABLE.update(status);
  endtask

endclass
`endif // RKV_I2C_REG_ACCESS_VIRT_SEQ_SV
