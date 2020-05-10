//----------------------------------------------------------
// Start Date: 10 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: top module 
//----------------------------------------------------------

module top();

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import test_pkg::*;

  logic clock;

  // replace with clock generator
  initial begin
    clock = 0;
    forever #10 clock = !clock;
  end

  // instantiating interface and providing referece clock
  // to generate serial clock
  ahb_interface ahb_intf(clock);

  initial begin
    // setting ahb_interface in config db
    uvm_config_db#(virtual ahb_interface)::set(null, "*", "ahb_interface", ahb_intf);
    run_test();
  end

endmodule
