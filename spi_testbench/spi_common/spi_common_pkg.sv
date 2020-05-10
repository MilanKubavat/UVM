//----------------------------------------------------------
// Start Date: 8 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: compiles common files to the tb 
//----------------------------------------------------------

package spi_common_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;

  `include "spi_transaction.sv"
  `include "spi_monitor.sv"

endpackage
