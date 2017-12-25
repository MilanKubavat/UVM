class ClockMonitor extends uvm_monitor;
  `uvm_component_utils(ClockMonitor)

  virtual ClockResetIf CR_Vif;

  ClockResetCfg  CR_Cfg;

  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass : ClockMonitor


function ClockMonitor::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void ClockMonitor::build_phase(uvm_phase phase);

  if(!uvm_config_db #(ClockResetCfg)::get(this, "", "ClockResetCfg", CR_Cfg))
    `uvm_fatal(get_full_name(),"unable to get ClockReset config")

 if(!uvm_config_db #(virtual ClockResetIf)::get(this, "", "ClockResetIf", CR_Vif))
    `uvm_fatal(get_full_name(),"unable to get ClockInterface")

endfunction : build_phase

task ClockMonitor::run_phase(uvm_phase phase);
	$display("ClockMonitor run_phase");
endtask : run_phase

