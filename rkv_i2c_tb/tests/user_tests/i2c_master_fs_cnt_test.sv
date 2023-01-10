`ifndef I2C_MASTER_FS_CNT_TEST_SV
`define I2C_MASTER_FS_CNT_TEST_SV

class i2c_master_fs_cnt_test extends rkv_i2c_base_test;
	`uvm_component_utils(i2c_master_fs_cnt_test)
	function new(string name ="i2c_master_fs_cnt_test", uvm_component parent);
		super.new(name, parent);
	endfunction 
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
	
	task run_phase(uvm_phase phase);
		i2c_master_fs_scl_cnt_seq seq = i2c_master_fs_scl_cnt_seq::type_id::create("seq");
		`uvm_info("SEQ", "sequence starting", UVM_LOW)
		phase.raise_objection(this);
		seq.start(env.sqr);
		phase.drop_objection(this);
		`uvm_info("SEQ", "sequence finished", UVM_LOW)
	endtask
endclass

`endif
