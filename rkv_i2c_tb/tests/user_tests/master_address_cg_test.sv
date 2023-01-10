`ifndef MASTER_ADDRESS_CG_TEST_SV
`define MASTER_ADDRESS_CG_TEST_SV

	class master_address_cg_test extends rkv_i2c_base_test;
		`uvm_component_utils(master_address_cg_test)
				
		function new(string name="master_address_cg_test", uvm_component parent);
			super.new(name, parent);
			
		endfunction
		
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			
		endfunction
		
		task run_phase(uvm_phase phase);
			master_address_cg_virt_seq seq = master_address_cg_virt_seq::type_id::create("seq");
			phase.raise_objection(this);
			`uvm_info("SEQ", "sequence starting", UVM_LOW)
			seq.start(env.sqr);
			`uvm_info("SEQ", "sequence finished", UVM_LOW)
			phase.drop_objection(this);
		endtask
	endclass

`endif //MASTER_ADDRESS_CG_TEST_SV
