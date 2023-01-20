`ifndef I2C_MASTER_HS_MASTER_CODE_TEST_SV
`define I2C_MASTER_HS_MASTER_CODE_TEST_SV

	class i2c_master_hs_master_code_test extends rkv_i2c_base_test;
		`uvm_component_utils(i2c_master_hs_master_code_test)
				
		function new(string name="i2c_master_hs_master_code_test", uvm_component parent);
			super.new(name, parent);
			
		endfunction
		
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			
		endfunction
		
		task run_phase(uvm_phase phase);
			i2c_master_hs_master_code_virt_seq seq = i2c_master_hs_master_code_virt_seq::type_id::create("seq");
			phase.raise_objection(this);
			`uvm_info("SEQ", "sequence starting", UVM_LOW)
			seq.start(env.sqr);
			`uvm_info("SEQ", "sequence finished", UVM_LOW)
			phase.drop_objection(this);
		endtask
	endclass

`endif //I2C_MASTER_HS_MASTER_CODE_TEST_SV
