class ResetMonitor extends uvm_driver#(uvm_sequence_item);
  `uvm_component_utils(ResetMonitor)

  virtual ClockResetIf CR_Vif;

  ClockResetCfg CR_Cfg;

  extern function new(string name, uvm_component parent);

  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass : ResetMonitor


function ResetMonitor::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new


function void ResetMonitor::build_phase(uvm_phase phase);

  if(!uvm_config_db #(ClockResetCfg)::get(this, "", "ClockResetCfg", CR_Cfg))
    `uvm_fatal(get_full_name(),"unable to get ClockReset config")

  if(!uvm_config_db #(virtual ClockResetIf)::get(this, "", "ClockResetIf", CR_Vif))
    `uvm_fatal(get_full_name(),"unable to get Clock_Reset_Intf")

endfunction : build_phase


task ResetMonitor::run_phase(uvm_phase phase);
	$display("ResetMonitor run phase");
endtask : run_phase


