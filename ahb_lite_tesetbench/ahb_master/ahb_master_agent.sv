//----------------------------------------------------------
// Start Date: 10 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: master agent creates driver, monitor and sequencer 
//----------------------------------------------------------

class ahb_master_agent extends uvm_agent;

  `uvm_component_utils(ahb_master_agent)

  ahb_master_driver    drv_h;
  ahb_master_sequencer seqr_h;

  uvm_analysis_port#(ahb_master_xtn) agent_ap;

  ahb_master_cfg m_cfg;

  uvm_active_passive_enum is_active;

  extern function new(string name = "ahb_master_agent", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass: ahb_master_agent

function ahb_master_agent::new(string name = "ahb_master_agent", uvm_component parent);
  super.new(name, parent);
  agent_ap = new("agent_ap", this);
endfunction

function void ahb_master_agent::build_phase(uvm_phase phase);
  // fatal error if master cfg not found in config db
  if(!uvm_config_db#(ahb_master_cfg)::get(this, "", "ahb_master_cfg", m_cfg)) begin
    `uvm_fatal(get_full_name(), "Cannot get AGENT-CONFIG from configuration database!")
  end

  is_active = m_cfg.is_active;

  super.build_phase(phase);

  if(is_active == UVM_ACTIVE) begin
    drv_h  = ahb_master_driver::type_id::create("drv_h", this);
    seqr_h = ahb_master_sequencer::type_id::create("seqr_h", this);
  end
endfunction

function void ahb_master_agent::connect_phase(uvm_phase phase);
  if(is_active == UVM_ACTIVE) begin
    drv_h.seq_item_port.connect(seqr_h.seq_item_export);
  end
endfunction
