//----------------------------------------------------------
// Start Date: 8 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: spi master pkg to compile spi master 
//----------------------------------------------------------

package spi_master_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import spi_common_pkg::*;

  `include "spi_master_cfg.sv"
  `include "spi_master_seq_lib.sv"
  `include "spi_master_sequencer.sv"
  `include "spi_master_driver.sv"
  `include "spi_master_agent.sv"

endpackage
