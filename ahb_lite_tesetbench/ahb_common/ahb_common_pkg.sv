//----------------------------------------------------------
// Start Date: 10 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: compiles common files for the tb 
//----------------------------------------------------------

package ahb_common_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;

  `include "ahb_master_xtn.sv"
  `include "ahb_slave_xtn.sv"

endpackage
