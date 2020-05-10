//----------------------------------------------------------
// Start Date: 8 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: spi slave configurations 
//----------------------------------------------------------

class spi_slave_cfg extends uvm_object;

  `uvm_object_utils(spi_slave_cfg)

  virtual spi_interface spi_vif;
  uvm_active_passive_enum is_active;

  // memory to store data recieved by slave
  bit [7:0] slave_mem [0:15];

  extern function new(string name = "spi_slave_cfg");
endclass: spi_slave_cfg

function spi_slave_cfg::new(string name = "spi_slave_cfg");
  super.new(name);
endfunction
