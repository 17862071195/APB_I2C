
`ifndef APB_USER_ADDRESS_CHECK_SEQ_SV
`define APB_USER_ADDRESS_CHECK_SEQ_SV

class apb_user_address_check_seq extends rkv_apb_base_sequence;
	
	`uvm_object_utils(apb_user_address_check_seq)
	rand bit [9:0] ADDR = -1;
	
	constraint def_addr {
		soft ADDR == -1;
	}
	
	function new (string name = "apb_user_address_check_seq"); 
		super.new(name);		
	endfunction
	
	virtual task body();
		`uvm_info("body", "address_check_seq Entering...", UVM_HIGH)
		super.body();
		rgm.IC_ENABLE.set(0);
		rgm.IC_ENABLE.update(status);
		if(ADDR >= 0) rgm.IC_TAR.set(ADDR);
		rgm.IC_TAR.update(status);		
		rgm.IC_ENABLE.ENABLE.set('h1);
		rgm.IC_ENABLE.update(status);
		
		`uvm_info("body", "address_check_seq Exiting...", UVM_HIGH)
	endtask
	
	
endclass

`endif
