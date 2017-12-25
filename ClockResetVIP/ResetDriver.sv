class ResetDriver extends uvm_driver#(uvm_sequence_item);
  `uvm_component_utils(ResetDriver)

  virtual ClockResetIf CR_Vif;

  ClockResetCfg  CR_Cfg;

  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass : ResetDriver


function ResetDriver::new(string name, uvm_component parent);
  super.new(name,parent);
endfunction : new


function void ResetDriver::build_phase(uvm_phase phase);

  if(!uvm_config_db #(ClockResetCfg)::get(this, "", "ClockResetCfg", CR_Cfg))
    `uvm_fatal("CFG/ERROR", "Failed to get CFG..")

  if(!uvm_config_db #(virtual ClockResetIf)::get(this, "", "ClockResetIf", CR_Vif))
    `uvm_fatal("VIF/ERROR", "Failed to get VIF..")

endfunction : build_phase


task ResetDriver::run_phase(uvm_phase phase);

  forever
  begin
    CR_Vif.reset <= !CR_Cfg.resetLevel;

    wait(CR_Cfg.resetAssert)
    
    repeat(CR_Cfg.cyclesBeforeReset)
      @(CR_Vif.DrvCb);

    CR_Vif.reset <= CR_Cfg.resetLevel;
    
    repeat(CR_Cfg.cyclesOnReset)
      @(CR_Vif.DrvCb);

    // Self clearing flag
    CR_Cfg.resetAssert = 0;
  end

endtask : run_phase

