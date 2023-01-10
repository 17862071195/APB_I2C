

`ifndef RKV_I2C_CGM_SV
`define RKV_I2C_CGM_SV

// Coverage Model
class rkv_i2c_cgm extends uvm_component;

  // Analysis import declarion below
  uvm_analysis_imp_apb_master #(lvc_apb_transfer, rkv_i2c_cgm) apb_trans_observed_imp;
  uvm_analysis_imp_i2c_slave #(lvc_i2c_slave_transaction, rkv_i2c_cgm) i2c_trans_observed_imp;

  // Events
  uvm_event rkv_i2c_field_access_bd_e; //  register field backdoor access event
  uvm_event rkv_i2c_field_access_fd_e; //  register field frontdoor access event

  rkv_i2c_config cfg;
  ral_block_rkv_i2c rgm;
  virtual rkv_i2c_if vif;
	event interrupt_hardware_eve;
	bit enable = 1;
	bit [IC_INTR_NUM-1 :0] intr;
  `uvm_component_utils(rkv_i2c_cgm)
   
  // T2    i2c protocol 
  // T2.1  7bits or 10bits addressing test (master) £ºIC_TAR_IC_TAR
  covergroup target_address_and_slave_address_cg with function sample(bit [9:0]TorS_addr, string field);
	  option.name = "7bits or 10bits addressing test";	
	  TAR_BITS10 : coverpoint TorS_addr[9:7] iff(field == "TAR") {
		  wildcard bins range1 = {3'b1xx};
		  wildcard bins range2 = {3'b0xx};
	  }
	  TAR_BITS7 : coverpoint TorS_addr[6:0] iff(field == "TAR") {
		  wildcard bins range1 = {7'b1xxxxxx};
		  wildcard bins range2 = {7'b0xxxxxx};
	  }
	  SAR_BITS10 : coverpoint TorS_addr[9:7] iff(field=="SAR") {
		  wildcard bins range1 = {3'b1xx};
		  wildcard bins range2 = {3'b0xx};
	  }
	  SAR_BITS7 : coverpoint TorS_addr[6:0] iff(field=="SAR") {
		  wildcard bins range1 = {7'b1xxxxxx};
		  wildcard bins range2 = {7'b0xxxxxx};
	  } 
  endgroup
  
  // T2.2  
  // i2c_clk/standard speed = 1000 = HCNT + LCNT
  // standard speed < 100k  ==>  HCNT + LCNT > 1000
  covergroup speed_modes_cg with function sample(bit [15:0] speed_cnt, string field);
	  option.name = "speed_modes_cg";
	  SPEED : coverpoint speed_cnt iff(field == "SPEED") {
		  bins standard = {1};
		  bins fast = {2};
		  bins hign_speed = {3};
	  }
	  SS_SCL_HCNT : coverpoint speed_cnt iff(field == "SS_SCL_HCNT") {
		  bins min = {[400:600]};
		  bins max = {[800:1000]};
	  }
	  SS_SCL_LCNT : coverpoint speed_cnt iff(field == "SS_SCL_LCNT") {
		  bins min ={[400:600]};
		  bins max = {[800:1000]};
	  }
	  // i2c_clk/standard speed = 100M/400K = 250 = HCNT + LCNT
	  // 250 < HCNT + LCNT < 1000
	  FS_SCL_HCNT : coverpoint speed_cnt iff(field == "FS_SCL_HCNT"){
		  bins min = {[120:150]}; 
		  bins max = {[400:600]};
	  }
	  FS_SCL_LCNT : coverpoint speed_cnt iff(field == "FS_SCL_LCNT"){
		  bins min = {[120:150]};
		  bins max = {[400:600]};
	  }
	  // i2c_clk/standard speed = 100M/3.4M = 29.4 = HCNT + LCNT
	  // 30 < HCNT + LCNT < 250
	  HS_SCL_HCNT : coverpoint speed_cnt iff(field == "HS_SCL_HCNT"){
		  bins min = {[10:20]};
		  bins max = {[40:60]};
	  }
	  HS_SCL_LCNT : coverpoint speed_cnt iff(field == "HS_SCL_LCNT"){
		  bins min = {[10:20]};
		  bins max = {[40:60]};
	  }
	  
  endgroup
  
  // T2.3    config 7bits or 10bits addressing (master mode) £ºIC_CON_IC_10BITADDR_MASTER
  covergroup bits7_or_bits10_addressing_cg with function sample(bit bits10);
	  option.name = "T2 addressing mode control";
	  ADDRMOD : coverpoint bits10 {
		  bins bits7     ={1'b0};
		  bins bits10    ={1'b1};
		  //bins to_bins7  =(1'b1 => 1'b0);
		  //bins to_bins10 =(1'b0 => 1'b1);
	  }
  endgroup
  
  // 2.4     restart enabled and detected (master mode) : IC_RESTART_EN
  covergroup restart_condition_cg with function sample(bit [0:0] restart);
	  option.name = "restart_condition_cg";
	  RESTART_EN : coverpoint restart {
		  bins enable = {1'b1};
		  bins disabl = {1'b0};
	  }
  endgroup
  
  // T3.1    DUT working status
  covergroup activity_cg with function sample(bit [0:0] act, bit [0:0] mact);
	  option.name = "activity_cg";       
	  ACTIVITY : coverpoint act {           
		  bins active = {1'b1};                     
		  bins idle = {1'b0};
	  }
	  MST_ACTIVITY : coverpoint mact {           
		  bins active = {1'b1};                     
		  bins idle = {1'b0};
	  }
  endgroup
    
  // T3.2    DUT enabled status
  covergroup enabled_cg with function sample(bit [0:0] en, string field);
	  option.name = "enabled_cg";
	  IC_ENABLE : coverpoint en iff (field == "IC_ENABLE") {
		  bins enable = {1'b1};
		  bins disabl = {1'b0};
	  }
	  IC_ENABLE_STATUS : coverpoint en iff (field == "IC_ENABLE_STATUS") {
		  bins enable = {1'b1};
		  bins disabl = {1'b0};
	  }
  endgroup   
  
  // T4.1   tx fifo status
  covergroup tx_fifo_status_cg with function sample(bit [0:0] tfe, bit [0:0] tfnf);
	  option.name = "tx_fifo_status_cg";
	  TFE : coverpoint tfe  {
		  bins empty = {1'b1};
		  bins not_empty = {1'b0};
	  }
	  TFNF : coverpoint tfnf {
		  bins not_full = {1'b1};
		  bins full = {1'b0};
	  }
  endgroup      

  // T4.2   rx fifo status
  covergroup rx_fifo_status_cg with function sample(bit [0:0] rff, bit [0:0] rfne);
	  option.name = "rx_fifo_status_cg";
	  TFE : coverpoint rff  {
		  bins full = {1'b1};
		  bins not_full = {1'b0};
	  }
	  TFNF : coverpoint rfne {
		  bins not_empty = {1'b1};
		  bins empty = {1'b0};
	  }
  endgroup 
  
  // T5.1    interrupt status.
  covergroup interrupt_status_cg with function sample(bit [0:0] msthold, bit [0:0] restdet, bit [0:0] gencall, bit [0:0] startdet
	  																								, bit [0:0] stopdet, bit [0:0] actity,  bit [0:0] rxdone,  bit [0:0] txabrt
	  																								, bit [0:0] rdreq,   bit [0:0] txempt,  bit [0:0] txover,  bit [0:0] rxfull
	  																								, bit [0:0] rxover,  bit [0:0] rxunder);
	  option.name = "interrupt_status_cg";
	  R_MASTER_ON_HOLD : coverpoint msthold  {
		  bins active = {1'b1};
		  bins inactive = {1'b0};
	  }
	  R_RESTART_DET : coverpoint restdet  {
		  bins active = {1'b1};
		  bins inactive = {1'b0};
	  }
	  R_GEN_CALL : coverpoint gencall  {
		  bins active = {1'b1};
		  bins inactive = {1'b0};
	  }
	  R_START_DET : coverpoint startdet  {
		  bins active = {1'b1};
		  bins inactive = {1'b0};
	  }
	  R_STOP_DET : coverpoint stopdet  {
		  bins active = {1'b1};
		  bins inactive = {1'b0};
	  }
	  R_ACTIVITY : coverpoint actity  {
		  bins active = {1'b1};
		  bins inactive = {1'b0};
	  }
	  R_RX_DONE : coverpoint rxdone  {
		  bins active = {1'b1};
		  bins inactive = {1'b0};
	  }
	  R_TX_ABRT : coverpoint txabrt  {
		  bins active = {1'b1};
		  bins inactive = {1'b0};
	  }
	  R_RD_REQ : coverpoint rdreq  {
		  bins active = {1'b1};
		  bins inactive = {1'b0};
	  }
	  R_TX_EMPTY : coverpoint txempt  {
		  bins active = {1'b1};
		  bins inactive = {1'b0};
	  }
	  R_TX_OVER : coverpoint txover  {
		  bins active = {1'b1};
		  bins inactive = {1'b0};
	  }
	  R_RX_FULL : coverpoint rxfull  {
		  bins active = {1'b1};
		  bins inactive = {1'b0};
	  }
	  R_RX_OVER : coverpoint rxover  {
		  bins active = {1'b1};
		  bins inactive = {1'b0};
	  }
	  R_RX_UNDER : coverpoint rxunder  {
		  bins active = {1'b1};
		  bins inactive = {1'b0};
	  }
  endgroup 
  
  // T5.2    interrupt clear cg
  covergroup interrupt_clear_cg with function sample(bit [0:0] clr, string field);
	  option.name = "interrupt_clear_cg";
	  CLR_GEN_CALL :  coverpoint clr iff(field == "CLR_GEN_CALL")   {bins clear = {1};}
	  CLR_START_DET : coverpoint clr iff(field == "CLR_START_DET")  {bins clear = {1};}
	  CLR_STOP_DET :  coverpoint clr iff(field == "CLR_STOP_DET")   {bins clear = {1};}
	  CLR_ACTIVITY :  coverpoint clr iff(field == "CLR_ACTIVITY")   {bins clear = {1};}
	  CLR_RX_DONE :   coverpoint clr iff(field == "CLR_RX_DONE")    {bins clear = {1};}
	  CLR_TX_ABRT :   coverpoint clr iff(field == "CLR_TX_ABRT")    {bins clear = {1};}
	  CLR_RD_REQ :    coverpoint clr iff(field == "CLR_RD_REQ")     {bins clear = {1};}
	  CLR_TX_OVER :   coverpoint clr iff(field == "CLR_TX_OVER")    {bins clear = {1};}
	  CLR_RX_OVER :   coverpoint clr iff(field == "CLR_RX_OVER")    {bins clear = {1};}
	  CLR_RX_UNDER :  coverpoint clr iff(field == "CLR_RX_UNDER")   {bins clear = {1};}
	  CLR_INTR :      coverpoint clr iff(field == "CLR_INTR")       {bins clear = {1};}
  endgroup 
  // T5.3    interrupt_hardware_outputs_cg
  covergroup interrupt_hardware_outputs_cg (bit [IC_INTR_NUM-1 :0] intr) @(interrupt_hardware_eve);
	  option.name = "interrupt_hardware_outputs_cg";
	  GEN_CALL_INTR_ID  : coverpoint intr[IC_GEN_CALL_INTR_ID]  {bins intr = {1};}
	  RX_UNDER_INTR_ID  : coverpoint intr[IC_RX_UNDER_INTR_ID]  {bins intr = {1};}
	  RX_OVER_INTR_ID   : coverpoint intr[IC_RX_OVER_INTR_ID]   {bins intr = {1};}
	  RX_FULL_INTR_ID   : coverpoint intr[IC_RX_FULL_INTR_ID]   {bins intr = {1};}
	  TX_OVER_INTR_ID   : coverpoint intr[IC_TX_OVER_INTR_ID]   {bins intr = {1};}
	  TX_EMPTY_INTR_ID  : coverpoint intr[IC_TX_EMPTY_INTR_ID]  {bins intr = {1};}
	  RD_REQ_INTR_ID    : coverpoint intr[IC_RD_REQ_INTR_ID]    {bins intr = {1};}
	  TX_ABRT_INTR_ID   : coverpoint intr[IC_TX_ABRT_INTR_ID]   {bins intr = {1};}
	  RX_DONE_INTR_ID   : coverpoint intr[IC_RX_DONE_INTR_ID]   {bins intr = {1};}
	  ACTIVITY_INTR_ID  : coverpoint intr[IC_ACTIVITY_INTR_ID]  {bins intr = {1};}
	  STOP_DET_INTR_ID  : coverpoint intr[IC_STOP_DET_INTR_ID]  {bins intr = {1};}
	  START_DET_INTR_ID : coverpoint intr[IC_START_DET_INTR_ID] {bins intr = {1};}
  endgroup
  
  // T5.4    interrupt_tx_abort_sources_cg
  covergroup interrupt_tx_abort_sources_cg with function sample(bit [16:0] intsour);
	  option.name = "interrupt_tx_abort_sources_cg";
	  INT_ABORT_SOURCES : coverpoint intsour {
		  wildcard bins ABRT_USER_ABRT       = {17'b1_xxxx_xxxx_xxxx_xxxx};
		  wildcard bins ABRT_SLVRD_INTX      = {17'bx_1xxx_xxxx_xxxx_xxxx};
		  wildcard bins ABRT_SLV_ARBLOST     = {17'bx_x1xx_xxxx_xxxx_xxxx};
		  wildcard bins ABRT_SLVFLUSH_TXFIFO = {17'bx_xx1x_xxxx_xxxx_xxxx};
		  wildcard bins ARB_LOST             = {17'bx_xxx1_xxxx_xxxx_xxxx};
		  wildcard bins ABRT_MASTER_DIS      = {17'bx_xxxx_1xxx_xxxx_xxxx};
		  wildcard bins ABRT_10B_RD_NORSTRT  = {17'bx_xxxx_x1xx_xxxx_xxxx};
		  wildcard bins ABRT_SBYTE_NORSTRT   = {17'bx_xxxx_xx1x_xxxx_xxxx};
		  wildcard bins ABRT_HS_NORSTRT      = {17'bx_xxxx_xxx1_xxxx_xxxx};
		  wildcard bins ABRT_SBYTE_ACKDET    = {17'bx_xxxx_xxxx_1xxx_xxxx};
		  wildcard bins ABRT_HS_ACKDET       = {17'bx_xxxx_xxxx_x1xx_xxxx};
		  wildcard bins ABRT_GCALL_READ      = {17'bx_xxxx_xxxx_xx1x_xxxx};
		  wildcard bins ABRT_GCALL_NOACK     = {17'bx_xxxx_xxxx_xxx1_xxxx};
		  wildcard bins ABRT_TXDATA_NOACK    = {17'bx_xxxx_xxxx_xxxx_1xxx};
		  wildcard bins ABRT_10ADDR2_NOACK   = {17'bx_xxxx_xxxx_xxxx_x1xx};
		  wildcard bins ABRT_10ADDR1_NOACK   = {17'bx_xxxx_xxxx_xxxx_xx1x};
		  wildcard bins ABRT_7B_ADDR_NOACK   = {17'bx_xxxx_xxxx_xxxx_xxx1};
	  }
  endgroup
  
  // T6      setup and hold timing with dedicated registers
  covergroup sda_control_cg with function sample(bit [23:16] tx_hold, bit [15:0] rx_hold, bit [7:0]setup, string field);
	  option.name = "sda_control_cg";
	  SDA_TX_HOLD : coverpoint tx_hold iff (field == "IC_SDA_HOLD") {
		  bins MAX = {[100:$]};
		  bins MID = {[10:99]};
		  bins MIN = {[1:9]};
	  }
	  SDA_RX_HOLD : coverpoint rx_hold iff (field == "IC_SDA_HOLD") {
		  bins MAX = {[100:$]};
		  bins MID = {[10:99]};
		  bins MIN = {[1:9]};		  
	  }
	  SDA_SETUP : coverpoint rx_hold iff (field == "IC_SDA_SETUP") {
		  bins MAX = {[100:$]};
		  bins MID = {[10:99]};
		  bins MIN = {[1:9]};		  
	  }
  endgroup
  
  
  function new(string name = "rkv_i2c_cgm", uvm_component parent = null);
    super.new(name, parent);
	  bits7_or_bits10_addressing_cg = new();
	  target_address_and_slave_address_cg = new();
	  speed_modes_cg = new();
	  restart_condition_cg = new();
	  sda_control_cg = new();
	  enabled_cg = new();
	  activity_cg = new();
	  tx_fifo_status_cg = new();
	  rx_fifo_status_cg = new();
	  interrupt_status_cg = new();
	  interrupt_clear_cg = new();
	  interrupt_hardware_outputs_cg = new(intr);
	  interrupt_tx_abort_sources_cg = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // TLM port instances
    apb_trans_observed_imp = new("apb_trans_observed_imp", this);
    i2c_trans_observed_imp = new("i2c_trans_observed_imp", this);

    // Get global uvm event
    rkv_i2c_field_access_bd_e = uvm_event_pool::get_global("rkv_i2c_field_access_bd_e");
    rkv_i2c_field_access_fd_e = uvm_event_pool::get_global("rkv_i2c_field_access_fd_e");

    if(!uvm_config_db #(rkv_i2c_config)::get(this, "", "cfg", cfg)) begin
      `uvm_error("build_phase", "Unable to get rkv_i2c_config from uvm_config_db")
    end
    rgm = cfg.rgm;
    vif = cfg.vif;
    intr = vif.intr;
    enable = cfg.coverage_model_ebable;
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
	  do_sample_reg();
  endtask

  virtual function void write_apb_master(lvc_apb_transfer tr);
    uvm_reg r;
	  if(tr.trans_status == lvc_apb_pkg::ERROR) return;
	  r = cfg.rgm.default_map.get_reg_by_offset(tr.addr);
	  rkv_i2c_field_access_fd_e.trigger(r);
  endfunction: write_apb_master

  virtual function void write_i2c_slave(lvc_i2c_slave_transaction tr);
    // TODO
  endfunction: write_i2c_slave

  virtual task do_sample_reg();
	  uvm_object tmp;
	  uvm_reg    r; 
	  fork
		  forever begin
			  wait(enable);
			  fork
				  rkv_i2c_field_access_fd_e.wait_trigger_data(tmp);
				  rkv_i2c_field_access_bd_e.wait_trigger_data(tmp);
			  join_any
			  disable fork;
			  void'($cast(r,tmp));
			  //ensure RGM mirror value has been update by monitor transaction
			  #1ps;
			  if(r.get_name() ==  "IC_CON") begin
				  speed_modes_cg.sample(rgm.IC_CON_SPEED.get(),"SPEED");
			  	bits7_or_bits10_addressing_cg.sample(rgm.IC_CON_IC_10BITADDR_MASTER.get());
				  restart_condition_cg.sample(rgm.IC_CON.IC_RESTART_EN.get());
			  end
			  else if(r.get_name() == "IC_SS_SCL_HCNT") speed_modes_cg.sample(rgm.IC_SS_SCL_HCNT_IC_SS_SCL_HCNT.get(), "SS_SCL_HCNT");
			  else if(r.get_name() == "IC_SS_SCL_LCNT") speed_modes_cg.sample(rgm.IC_SS_SCL_LCNT_IC_SS_SCL_LCNT.get(), "SS_SCL_LCNT");
			  else if(r.get_name() == "IC_FS_SCL_HCNT") speed_modes_cg.sample(rgm.IC_FS_SCL_HCNT_IC_FS_SCL_HCNT.get(), "FS_SCL_HCNT");
			  else if(r.get_name() == "IC_FS_SCL_LCNT") speed_modes_cg.sample(rgm.IC_FS_SCL_LCNT_IC_FS_SCL_LCNT.get(), "FS_SCL_LCNT");
			  else if(r.get_name() == "IC_HS_SCL_HCNT") speed_modes_cg.sample(rgm.IC_HS_SCL_HCNT_IC_HS_SCL_HCNT.get(), "HS_SCL_HCNT");
			  else if(r.get_name() == "IC_HS_SCL_LCNT") speed_modes_cg.sample(rgm.IC_HS_SCL_LCNT_IC_HS_SCL_LCNT.get(), "HS_SCL_LCNT");
			  else if(r.get_name() == "IC_TAR")         target_address_and_slave_address_cg.sample(rgm.IC_TAR_IC_TAR.get(), "TAR");
			  else if(r.get_name() == "IC_SAR")         target_address_and_slave_address_cg.sample(rgm.IC_SAR_IC_SAR.get(), "SAR");
			  else if(r.get_name() == "IC_SDA_HOLD")
				  sda_control_cg.sample(rgm.IC_SDA_HOLD.IC_SDA_TX_HOLD.get(), rgm.IC_SDA_HOLD.IC_SDA_RX_HOLD.get(), "", "IC_SDA_HOLD");
			  else if(r.get_name() == "IC_SDA_SETUP")
				  sda_control_cg.sample("", "", rgm.IC_SDA_SETUP.SDA_SETUP.get(), "IC_SDA_SETUP");
			  else if(r.get_name() == "IC_ENABLE")        enabled_cg.sample(rgm.IC_ENABLE.ENABLE.get(), "IC_ENABLE");    
			  else if(r.get_name() == "IC_ENABLE_STATUS") enabled_cg.sample(rgm.IC_ENABLE_STATUS.IC_EN.get(), "IC_ENABLE_STATUS");
			  else if(r.get_name() == "IC_STATUS") begin
				  activity_cg.sample(rgm.IC_STATUS.ACTIVITY.get(), rgm.IC_STATUS.MST_ACTIVITY.get());
				  tx_fifo_status_cg.sample(rgm.IC_STATUS.TFE.get(), rgm.IC_STATUS.TFNF.get());
				  rx_fifo_status_cg.sample(rgm.IC_STATUS.RFF.get(), rgm.IC_STATUS.RFNE.get());
			  end 
			  else if(r.get_name() == "IC_INTR_STAT") interrupt_status_cg.sample(rgm.IC_INTR_STAT.R_MASTER_ON_HOLD.get(),
				  																																 rgm.IC_INTR_STAT.R_RESTART_DET.get(),
				  																																 rgm.IC_INTR_STAT.R_GEN_CALL.get(),
				  																																 rgm.IC_INTR_STAT.R_START_DET.get(),
				  																																 rgm.IC_INTR_STAT.R_STOP_DET.get(),
				  																																 rgm.IC_INTR_STAT.R_ACTIVITY.get(),
				  																																 rgm.IC_INTR_STAT.R_RX_DONE.get(),
				  																																 rgm.IC_INTR_STAT.R_TX_ABRT.get(),
				  																																 rgm.IC_INTR_STAT.R_RD_REQ.get(),
				  																																 rgm.IC_INTR_STAT.R_TX_EMPTY.get(),
				  																																 rgm.IC_INTR_STAT.R_TX_OVER.get(),
				  																																 rgm.IC_INTR_STAT.R_RX_FULL.get(),
				  																																 rgm.IC_INTR_STAT.R_RX_OVER.get(),
				  																																 rgm.IC_INTR_STAT.R_RX_UNDER.get());
			  else if(r.get_name() == "IC_CLR_GEN_CALL")  interrupt_clear_cg.sample(1,"CLR_GEN_CALL");
			  else if(r.get_name() == "IC_CLR_START_DET") interrupt_clear_cg.sample(1,"CLR_START_DET");
			  else if(r.get_name() == "IC_CLR_STOP_DET")  interrupt_clear_cg.sample(1,"CLR_STOP_DET");
			  else if(r.get_name() == "IC_CLR_ACTIVITY")  interrupt_clear_cg.sample(1,"CLR_ACTIVITY");
			  else if(r.get_name() == "IC_CLR_RX_DONE")   interrupt_clear_cg.sample(1,"CLR_RX_DONE");
			  else if(r.get_name() == "IC_CLR_TX_ABRT")   interrupt_clear_cg.sample(1,"CLR_TX_ABRT");
			  else if(r.get_name() == "IC_CLR_RD_REQ")    interrupt_clear_cg.sample(1,"CLR_RD_REQ");
			  else if(r.get_name() == "IC_CLR_TX_OVER")   interrupt_clear_cg.sample(1,"CLR_TX_OVER");
			  else if(r.get_name() == "IC_CLR_RX_OVER")   interrupt_clear_cg.sample(1,"CLR_RX_OVER");
			  else if(r.get_name() == "IC_CLR_RX_UNDER")  interrupt_clear_cg.sample(1,"CLR_RX_UNDER");
			  else if(r.get_name() == "IC_CLR_INTR")      interrupt_clear_cg.sample(1,"CLR_INTR");
			  else if(r.get_name() == "IC_TX_ABRT_SOURCE")interrupt_tx_abort_sources_cg.sample(rgm.IC_TX_ABRT_SOURCE.get()); 
		  end
	  join_none
  endtask
  
  
  virtual task do_sample_signals();
	  fork
		  forever begin
	  		@(vif.intr iff vif.apb_rstn && enable && vif.intr!==0) 
	  		-> interrupt_hardware_eve;
	  	end
	  join_none
  endtask
endclass


`endif // RKV_I2C_CGM_SV

