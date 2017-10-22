interface intf(input clock, reset_b);

   logic rw;
   logic [1:0] addr;

   logic [31:0] wdata, rdata;

   clocking drvCb@(posedge clock);
      output rw;
      output addr;
      output wdata;
   endclocking

   clocking monCb@(posedge clock);
      input rw;
      input addr;
      input wdata;
      input rdata;
   endclocking

endinterface

