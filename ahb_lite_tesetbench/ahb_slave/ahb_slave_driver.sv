//----------------------------------------------------------
// Start Date: 10 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: ahb slave driver logic 
//----------------------------------------------------------

class ahb_slave_driver extends uvm_driver#(ahb_slave_xtn);

  `uvm_component_utils(ahb_slave_driver)

  virtual ahb_interface vif;
  ahb_slave_cfg cfg;

  extern function new(string name = "ahb_slave_driver", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task drive();
endclass: ahb_slave_driver

function ahb_slave_driver::new(string name = "ahb_slave_driver", uvm_component parent);
  super.new(name, parent);
endfunction

function void ahb_slave_driver::build_phase(uvm_phase phase);
  // fatal error if cfg not found in config db
  if(!uvm_config_db#(ahb_slave_cfg)::get(this, "", "ahb_slave_cfg", cfg)) begin
     `uvm_fatal(get_full_name(), "Cannot get cfg from configuration database!")
  end

  super.build_phase(phase);
endfunction

function void ahb_slave_driver::connect_phase(uvm_phase phase);
  vif = cfg.vif;
endfunction

task ahb_slave_driver::run_phase(uvm_phase phase);
  forever begin
    seq_item_port.get_next_item(req);
      drive();
    seq_item_port.item_done(req);
  end
endtask

task ahb_slave_driver::drive();
  `uvm_info(get_full_name(), "Inside slave driver drive task!!", UVM_LOW)
endtask
