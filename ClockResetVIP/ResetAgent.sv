class ResetAgent extends uvm_agent;
  `uvm_component_utils(ResetAgent)

  ResetDriver  rst_drv;
  ResetMonitor rst_mon;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

endclass : ResetAgent

function ResetAgent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void ResetAgent::build_phase(uvm_phase phase);
  rst_drv = ResetDriver::type_id::create("rst_drv", this);
  rst_mon = ResetMonitor::type_id::create("rst_mon", this);
endfunction : build_phase


