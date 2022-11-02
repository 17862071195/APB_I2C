//=======================================================================
// COPYRIGHT (C) 2018-2020 RockerIC, Ltd.
// This software and the associated documentation are confidential and
// proprietary to RockerIC, Ltd. Your use or disclosure of this software
// is subject to the terms and conditions of a consulting agreement
// between you, or your company, and RockerIC, Ltd. In the event of
// publications, the following notice is applicable:
//
// ALL RIGHTS RESERVED
//
// The entire notice above must be reproduced on all authorized copies.
//
// VisitUs  : www.rockeric.com
// Support  : support@rockeric.com
// WeChat   : eva_bill 
//-----------------------------------------------------------------------
`ifndef LVC_APB_MASTER_AGENT_SV
`define LVC_APB_MASTER_AGENT_SV

function lvc_apb_master_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void lvc_apb_master_agent::build();
  super.build();
  // get config
  if( !uvm_config_db#(lvc_apb_config)::get(this,"","cfg", cfg)) begin
    `uvm_warning("GETCFG","cannot get config object from config DB")
     cfg = lvc_apb_config::type_id::create("cfg");
  end
  // get virtual interface
  if( !uvm_config_db#(virtual lvc_apb_if)::get(this,"","vif", vif)) begin
    `uvm_fatal("GETVIF","cannot get vif handle from config DB")
  end
  monitor = lvc_apb_master_monitor::type_id::create("monitor",this);
  monitor.cfg = cfg;
  if(cfg.is_active == UVM_ACTIVE) begin
    sequencer = lvc_apb_master_sequencer::type_id::create("sequencer",this);
    sequencer.cfg = cfg;
    driver = lvc_apb_master_driver::type_id::create("driver",this);
    driver.cfg = cfg;
  end
endfunction : build

function void lvc_apb_master_agent::connect();
  assign_vi(vif);

  if(is_active == UVM_ACTIVE) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);       
  end

endfunction : connect
  
function void lvc_apb_master_agent::assign_vi(virtual lvc_apb_if vif);
   monitor.vif = vif;
   if (is_active == UVM_ACTIVE) begin
      sequencer.vif = vif; 
      driver.vif = vif; 
    end
endfunction : assign_vi



`endif // LVC_APB_MASTER_AGENT_SV

