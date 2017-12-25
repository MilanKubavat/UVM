module ClockResetGenerator(output clock, reset);

  `include "uvm_macros.svh"

  import uvm_pkg::*;
  import ClockResetPkg::*;

  ClockResetIf ClockResetInterface();

  assign clock = ClockResetInterface.clock;
  assign reset = ClockResetInterface.reset;

  initial
  begin
    uvm_config_db#(virtual ClockResetIf)::set(null, "*", "ClockResetIf", ClockResetInterface);
    run_test();
  end
endmodule

