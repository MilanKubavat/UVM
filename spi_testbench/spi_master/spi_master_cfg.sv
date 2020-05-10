//----------------------------------------------------------
// Start Date: 8 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: spi master configurations 
//----------------------------------------------------------

class spi_master_cfg extends uvm_object;

  `uvm_object_utils(spi_master_cfg)

  virtual spi_interface spi_vif;
  bit cpol=0;
  bit cpha=0;
  uvm_active_passive_enum is_active;

  extern function new(string name = "spi_master_cfg");

endclass: spi_master_cfg

function spi_master_cfg::new(string name = "spi_master_cfg");
  super.new(name);
endfunction
