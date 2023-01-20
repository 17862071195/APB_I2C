`ifndef I2C_MASTER_TX_ABRT_INTR_VIRT_SEQ_SV
`define I2C_MASTER_TX_ABRT_INTR_VIRT_SEQ_SV

class i2c_master_tx_abrt_intr_virt_seq extends rkv_i2c_base_virtual_sequence;
	`uvm_object_utils(i2c_master_tx_abrt_intr_virt_seq)
	function new(string name ="i2c_master_tx_abrt_intr_virt_seq");
		super.new(name);
	endfunction
	
	virtual task body();
		`uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW);
		super.body();
		vif.wait_rstn_release();
		vif.wait_apb(10);
    
    `uvm_do_on_with(apb_cfg_seq, p_sequencer.apb_mst_sqr, {
                    SPEED == 2;
										IC_10BITADDR_MASTER == 0;
										IC_TAR == `LVC_I2C_SLAVE0_ADDRESS;
                    IC_FS_SCL_HCNT == 200;
                    IC_FS_SCL_LCNT == 200;
										ENABLE == 1;})
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
    rgm.IC_INTR_STAT.mirror(status);
    
    rgm.IC_ENABLE.ABORT.set(1);
    rgm.IC_ENABLE.update(status);
    
    `uvm_do_on_with(apb_intr_wait_seq ,p_sequencer.apb_mst_sqr, {intr_id == IC_TX_ABRT_INTR_ID;})
    if(vif.get_intr(IC_TX_ABRT_INTR_ID) === 1) `uvm_info("SUCCESS", "TX_ABRT test successfully!", UVM_LOW)
    else `uvm_error("INTRERR", "interrupt output IC_TX_ABRT_INTR_ID is not high!") 
    
    rgm.IC_INTR_STAT.mirror(status);
    if(rgm.IC_INTR_STAT.R_TX_ABRT.get() != 1) `uvm_error("REGERR", "IC_INTR_STAT.R_TX_ABRT register is not 1!")
    
    `uvm_info("MMM",$sformatf("%b",rgm.IC_TX_ABRT_SOURCE.get()), UVM_LOW)
    `uvm_do_on_with(apb_intr_clear_seq, p_sequencer.apb_mst_sqr, {
                    intr_id == IC_TX_ABRT_INTR_ID;}) 
    `uvm_do_on(apb_wait_empty_seq, p_sequencer.apb_mst_sqr)

    #10us;

		`uvm_info(get_type_name(), "=====================FINIkSHED=====================", UVM_LOW);
	endtask
endclass
`endif 
