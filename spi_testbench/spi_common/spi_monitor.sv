//----------------------------------------------------------
// Start Date: 8 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: spi monitor to monitor interface and
//              implement checks 
//----------------------------------------------------------

class spi_monitor extends uvm_monitor;

  `uvm_component_utils(spi_monitor)

  virtual spi_interface spi_vif;
  //spi_env_cfg cfg;
  spi_transaction xtn;

  uvm_analysis_port#(spi_transaction) monitor_ap;

  extern function new(string name = "spi_monitor", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass: spi_monitor

function spi_monitor::new(string name = "spi_monitor", uvm_component parent);
  super.new(name, parent);
  monitor_ap = new("monitor_ap", this);
endfunction

function void spi_monitor::build_phase(uvm_phase phase);

  // fatal error if cfg object not found in config db 
  //if(!uvm_config_db#(spi_env_cfg)::get(this, "", "spi_env_cfg", cfg)) begin
  //  `uvm_fatal(get_full_name(), "Cannot get cfg from configuration database!")
  //end

  super.build_phase(phase);
endfunction

function void spi_monitor::connect_phase(uvm_phase phase);
  //spi_vif = cfg.spi_vif;
endfunction

// run phase
task spi_monitor::run_phase(uvm_phase phase);
  `uvm_info(get_full_name(), "Inside spi monitor run phase!!", UVM_LOW)
endtask
