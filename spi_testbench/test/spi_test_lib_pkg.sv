//----------------------------------------------------------
// Start Date: 8 Apr 2020
// Last Modified: 
// Author: Milan Kubavat
//
// Description: pkg file to compile all the tests 
//----------------------------------------------------------

package spi_test_lib_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import spi_common_pkg::*;
  import spi_master_pkg::*;
  import spi_slave_pkg::*;
  import spi_env_pkg::*;

  `include "spi_base_test.sv"
  `include "spi_write_test.sv"
  `include "spi_write_read_test.sv"

endpackage
