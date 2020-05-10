//----------------------------------------------------------
// Start Date: 8 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: env configuration file 
//----------------------------------------------------------

class spi_env_cfg extends uvm_object;

  `uvm_object_utils(spi_env_cfg)

  spi_master_cfg m_cfg;
  spi_slave_cfg  s_cfg;

  uvm_active_passive_enum m_is_active;
  uvm_active_passive_enum s_is_active;

  virtual spi_interface spi_vif;

  extern function new(string name = "spi_env_cfg");

endclass: spi_env_cfg

  // constructor
  function spi_env_cfg::new(string name = "spi_env_cfg");
    super.new(name);
  endfunction
