//----------------------------------------------------------
// Start Date: 10 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: compiles env files and pkgs required by same 
//----------------------------------------------------------

package ahb_env_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import ahb_common_pkg::*;
  import ahb_master_pkg::*;
  import ahb_slave_pkg::*;

  `include "ahb_env_cfg.sv"
  `include "ahb_env.sv"

endpackage
