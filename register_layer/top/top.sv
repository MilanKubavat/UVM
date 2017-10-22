module top;

   `include "uvm_macros.svh"
   import uvm_pkg::*;
   import tb_pkg::*;

   bit clock, reset_b;

   initial forever #10 clock = !clock;

   intf intf(.clock(clock), reset_b(reset_b));

   dut dut(
      .clock(intf.clock),
      .reset_b(intf.reset_b),
      
      .rw(intf.rw),
      .addr(intf.addr),
      .wdata(intf.wdata),
      .rdata(intf.rdata)
   );


   initial
   begin
      uvm_config_db#(virtual intf)::set(null, "*", "vif", intf);
      run_test();
   end

endmodule

