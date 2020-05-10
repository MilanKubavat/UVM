//----------------------------------------------------------
// Start Date: 8 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: spi slave pkg to compile spi slave 
//----------------------------------------------------------

package spi_slave_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import spi_common_pkg::*;

  `include "spi_slave_cfg.sv"
  `include "spi_slave_seq_lib.sv"
  `include "spi_slave_sequencer.sv"
  `include "spi_slave_driver.sv"
  `include "spi_slave_agent.sv"

endpackage
