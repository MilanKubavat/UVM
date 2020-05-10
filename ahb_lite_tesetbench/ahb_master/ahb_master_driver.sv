//----------------------------------------------------------
// Start Date: 10 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: ahb master driving logic 
//----------------------------------------------------------

class ahb_master_driver extends uvm_driver#(ahb_master_xtn);

  `uvm_component_utils(ahb_master_driver)

  virtual ahb_interface vif;
  ahb_master_cfg cfg;

  extern function new(string name = "ahb_master_driver", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task drive(ahb_master_xtn req);
endclass: ahb_master_driver

function ahb_master_driver::new(string name = "ahb_master_driver", uvm_component parent);
  super.new(name, parent);
endfunction

function void ahb_master_driver::build_phase(uvm_phase phase);
  // fatal error if cfg not found in config db
  if(!uvm_config_db#(ahb_master_cfg)::get(this, "", "ahb_master_cfg", cfg)) begin
     `uvm_fatal(get_full_name(), "Cannot get cfg from configuration database!")
  end
  super.build_phase(phase);
endfunction

function void ahb_master_driver::connect_phase(uvm_phase phase);
  vif = cfg.vif;
endfunction

task ahb_master_driver::run_phase(uvm_phase phase);
  forever begin
    seq_item_port.get_next_item(req);
    drive(req);
    seq_item_port.item_done(req);
  end
endtask

task ahb_master_driver::drive(ahb_master_xtn req);
  `uvm_info(get_full_name(), "Inside master driver drive task!!", UVM_LOW)
   req.print;
endtask
