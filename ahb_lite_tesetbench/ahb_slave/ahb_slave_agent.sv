//----------------------------------------------------------
// Start Date: 10 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: ahb slave 
//----------------------------------------------------------

class ahb_slave_agent extends uvm_agent;

  `uvm_component_utils(ahb_slave_agent)

  ahb_slave_driver    drv_h;
  ahb_slave_sequencer seqr_h;

  uvm_analysis_port#(ahb_slave_xtn) agent_ap;

  ahb_slave_cfg cfg;

  uvm_active_passive_enum is_active;

  extern function new(string name = "ahb_slave_agent", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass: ahb_slave_agent

function ahb_slave_agent::new(string name = "ahb_slave_agent", uvm_component parent);
  super.new(name, parent);
  agent_ap = new("agent_ap", this);
endfunction

function void ahb_slave_agent::build_phase(uvm_phase phase);
  // fatal error if slave cfg not found in config db
  if(!uvm_config_db#(ahb_slave_cfg)::get(this, "", "ahb_slave_cfg", cfg)) begin
    `uvm_fatal(get_full_name(), "Cannot get AGENT-CONFIG from configuration database!")
  end

  is_active = cfg.is_active;

  super.build_phase(phase);

  if(is_active == UVM_ACTIVE) begin
    drv_h  = ahb_slave_driver::type_id::create("drv_h", this);
    seqr_h = ahb_slave_sequencer::type_id::create("seqr_h", this);
  end
endfunction

function void ahb_slave_agent::connect_phase(uvm_phase phase);
  if(is_active == UVM_ACTIVE) begin
    drv_h.seq_item_port.connect(seqr_h.seq_item_export);
  end
endfunction
