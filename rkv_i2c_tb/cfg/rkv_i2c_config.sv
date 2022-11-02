`ifndef RKV_I2C_CONFIG_SV
`define RKV_I2C_CONFIG_SV

class rkv_i2c_config extends uvm_object;

  lvc_apb_config apb_cfg;
  lvc_i2c_system_configuration i2c_cfg;
  ral_block_rkv_i2c rgm;
	
	virtual lvc_i2c_if i2c_vif;

  `uvm_object_utils(rkv_i2c_config)

  function new (string name = "rkv_i2c_config");
    super.new(name);
	  apb_cfg = lvc_apb_config::type_id::create("apb_cfg");
	  i2c_cfg = lvc_i2c_system_configuration::type_id::create("i2c_cfg");
		do_apb_cfg();
		do_i2c_cfg();  
  endfunction

  function void do_apb_cfg();
    // TODO
  endfunction

  function void do_i2c_cfg();
	  //system configuration
	  i2c_cfg.num_masters = 1; 
	  i2c_cfg.num_slaves = 1;
	  i2c_cfg.create_sub_cfgs(i2c_cfg.num_masters, i2c_cfg.num_slaves, STANDARD_MODE);
	  
	  //Agent Configuration
	  i2c_cfg.master_cfg[0].bus_speed = STANDARD_MODE;	 //speed mode              default:STANDARD_MODE
	  i2c_cfg.master_cfg[0].master_code = 3'b000;        //master code             default:3'b000
	  i2c_cfg.master_cfg[0].is_active = 0;               //Active or Passive mode  default:0
	  i2c_cfg.master_cfg[0].enable_10bit_addr = 0;       //7/10-bit addressing     default:0 7bite address
	  
	  i2c_cfg.master_cfg[0].checks_enable = 1;           //Protocol Checks	       default:1
	  i2c_cfg.master_cfg[0].toggle_coverage_enable = 0;  //toggle coverage	       default:0
	  i2c_cfg.master_cfg[0].agent_id = 0;                //agent id	               default:0
	  i2c_cfg.master_cfg[0].enable_xml_gen = 0;          //Protocol Analyzer (PA)  default:0
	  i2c_cfg.master_cfg[0].enable_traffic_log = 1;      //Monitor log             default:1
	  
	  i2c_cfg.slave_cfg[0].is_active = 1;
	  i2c_cfg.slave_cfg[0].enable_10bit_addr = 0;
	  i2c_cfg.slave_cfg[0].slave_address = `LVC_I2C_SLAVE0_ADDRESS;
	  i2c_cfg.slave_cfg[0].device_id = 24'b0;
	  
	  i2c_cfg.slave_cfg[0].checks_enable = 0;            
	  i2c_cfg.slave_cfg[0].toggle_coverage_enable = 0;   
	  i2c_cfg.slave_cfg[0].agent_id = 0;
  endfunction
  
  function void set_if(lvc_i2c_vif i2c_vif);
	  this.i2c_vif = i2c_vif;
	  //i2c interface configuration
	  i2c_cfg.set_if(i2c_vif);
  endfunction
endclass

`endif // RKV_I2C_CONFIG_SV
