//----------------------------------------------------------
// Start Date: 10 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: ahb master configurations 
//----------------------------------------------------------

class ahb_master_cfg extends uvm_object;

  `uvm_object_utils(ahb_master_cfg)

  virtual ahb_interface vif;
  uvm_active_passive_enum is_active;

  extern function new(string name = "ahb_master_cfg");

endclass: ahb_master_cfg

function ahb_master_cfg::new(string name = "ahb_master_cfg");
  super.new(name);
endfunction
