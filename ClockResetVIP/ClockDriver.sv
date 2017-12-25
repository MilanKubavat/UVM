class ClockDriver extends uvm_driver#(uvm_sequence_item);
  `uvm_component_utils(ClockDriver)

  virtual ClockResetIf CR_Vif;

  ClockResetCfg  CR_Cfg;
  
  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass : ClockDriver


function ClockDriver::new(string name, uvm_component parent);
  super.new(name,parent);
endfunction : new


function void ClockDriver::build_phase(uvm_phase phase);

  if(!uvm_config_db#(ClockResetCfg)::get(this, "", "ClockResetCfg", CR_Cfg))
    `uvm_fatal("CFG/ERROR", "unable to get ClockReset config")

 if(!uvm_config_db #(virtual ClockResetIf)::get(this, "", "ClockResetIf", CR_Vif))
    `uvm_fatal("VIF/ERROR", "unable to get ClockInterface")

endfunction : build_phase


task ClockDriver::run_phase(uvm_phase phase);
  forever
  begin 
    CR_Vif.clock = 0;
    #(CR_Cfg.periodLow);
    
    CR_Vif.clock = 1;
    #(CR_Cfg.periodHigh);
  end
endtask : run_phase
