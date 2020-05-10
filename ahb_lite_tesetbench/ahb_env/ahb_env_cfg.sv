//----------------------------------------------------------
// Start Date: 10 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: env configuration file 
//----------------------------------------------------------

class ahb_env_cfg extends uvm_object;

  `uvm_object_utils(ahb_env_cfg)

  ahb_master_cfg m_cfg;
  ahb_slave_cfg  s_cfg;

  uvm_active_passive_enum m_is_active;
  uvm_active_passive_enum s_is_active;

  virtual ahb_interface vif;

  extern function new(string name = "ahb_env_cfg");
endclass: ahb_env_cfg

function ahb_env_cfg::new(string name = "ahb_env_cfg");
  super.new(name);
endfunction
