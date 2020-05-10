//----------------------------------------------------------
// Start Date: 8 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: compiles env files and pkgs required by same 
//----------------------------------------------------------

package spi_env_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import spi_common_pkg::*;
  import spi_master_pkg::*;
  import spi_slave_pkg::*;

  `include "spi_env_cfg.sv"
  `include "spi_env.sv"

endpackage
