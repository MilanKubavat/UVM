interface ClockResetIf();
  logic clock;
  logic reset;

  clocking DrvCb @(posedge clock);
  endclocking

endinterface
