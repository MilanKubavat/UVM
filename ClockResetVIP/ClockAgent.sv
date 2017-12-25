class ClockAgent extends uvm_agent;
  `uvm_component_utils(ClockAgent)

  ClockDriver  clk_drv;
  ClockMonitor clk_mon;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);

endclass : ClockAgent

function ClockAgent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void ClockAgent::build_phase(uvm_phase phase);
  clk_drv = ClockDriver::type_id::create("clk_drv", this);
  clk_mon = ClockMonitor::type_id::create("clk_mon", this);
endfunction : build_phase

