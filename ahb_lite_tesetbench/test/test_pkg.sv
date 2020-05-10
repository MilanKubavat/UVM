//----------------------------------------------------------
// Start Date: 10 Apr 2020
// Last Modified: 
// Author: Milan Kubavat
//
// Description: pkg file to compile all the tests 
//----------------------------------------------------------

package test_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import ahb_common_pkg::*;
  import ahb_master_pkg::*;
  import ahb_slave_pkg::*;
  import ahb_env_pkg::*;

  `include "ahb_base_test.sv"

endpackage
