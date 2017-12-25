package tb_pkg;

   `include "uvm_macros.svh"
   import uvm_pkg::*;

   `include "transaction.sv"
   `include "reg_model.sv"

   typedef uvm_sequencer#(transaction) sequencer;

   `include "driver.sv"
   `include "environment.sv"
   `include "test.sv"

endpackage;

