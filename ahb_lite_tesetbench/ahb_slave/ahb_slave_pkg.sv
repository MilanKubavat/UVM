//----------------------------------------------------------
// Start Date: 10 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: ahb slave pkg to compile ahb slave 
//----------------------------------------------------------

package ahb_slave_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import ahb_common_pkg::*;

  `include "ahb_slave_cfg.sv"
  `include "ahb_slave_seq_lib.sv"
  `include "ahb_slave_sequencer.sv"
  `include "ahb_slave_driver.sv"
  `include "ahb_slave_agent.sv"

endpackage
