class ClockResetCfg extends uvm_object;
  `uvm_object_utils(ClockResetCfg)

  function new(string name = "ClockResetCfg");
    super.new(name);
    clockFreq();
  endfunction


  bit resetLevel = 1;
  bit resetAssert;

  int unsigned cyclesBeforeReset, cyclesOnReset;


  bit createClock = 1, createReset = 1;

  int unsigned periodHigh, periodLow;

  function void clockFreq(int unsigned timePeriod = 10, dutyCycle = 50);
    periodHigh = dutyCycle * timePeriod / 100.0;
    periodLow  = timePeriod - periodHigh;
  endfunction

endclass
