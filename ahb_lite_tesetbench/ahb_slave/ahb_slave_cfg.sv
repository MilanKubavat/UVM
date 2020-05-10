//----------------------------------------------------------
// Start Date: 10 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: ahb slave configurations 
//----------------------------------------------------------

class ahb_slave_cfg extends uvm_object;

  `uvm_object_utils(ahb_slave_cfg)

  virtual ahb_interface vif;
  uvm_active_passive_enum is_active;

  // memory to store data recieved by slave
  bit [7:0] slave_mem [0:100];

  extern function new(string name = "ahb_slave_cfg");
endclass: ahb_slave_cfg

function ahb_slave_cfg::new(string name = "ahb_slave_cfg");
  super.new(name);
endfunction
