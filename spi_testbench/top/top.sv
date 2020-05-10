//----------------------------------------------------------
// Start Date: 8 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: top module 
//----------------------------------------------------------

module top();

  `include "uvm_macros.svh"
  import uvm_pkg::*;
  import spi_test_lib_pkg::*;

  logic clock;

  // replace with clock generator
  initial begin
    clock = 0;
    forever #10 clock = !clock;
  end

  // instantiating interface and providing referece clock
  // to generate serial clock
  spi_interface spi_intf(clock);

  initial begin
    $dumpvars();
    $wlfdumpvars(4,top);
    // setting spi_intf in config db
    uvm_config_db#(virtual spi_interface)::set(null, "*", "spi_interface", spi_intf);
    run_test();
  end

endmodule
