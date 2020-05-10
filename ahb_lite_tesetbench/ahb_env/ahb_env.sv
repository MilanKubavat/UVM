//----------------------------------------------------------
// Start Date: 10 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: ahb env creates and connects mon, sb, agents 
//----------------------------------------------------------

class ahb_env extends uvm_env;

  `uvm_component_utils(ahb_env)

  ahb_env_cfg  env_cfg;
  ahb_master_cfg m_cfg;
  ahb_slave_cfg  s_cfg;

  //reset_agent reset_agent_h;
  ahb_master_agent ahb_master;
  ahb_slave_agent  ahb_slave;

  extern function new(string name = "ahb_env", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass: ahb_env

function ahb_env::new(string name = "ahb_env", uvm_component parent);
  super.new(name, parent);
endfunction

function void ahb_env::build_phase(uvm_phase phase);
   // fatal error if env cfg not found in config db
   if(!uvm_config_db#(ahb_env_cfg)::get(this, "", "ahb_env_cfg", env_cfg)) begin
    `uvm_fatal(get_full_name(), "Cannot get ENV-CONFIG from configuration database!")
   end

   // set master agent configuration       
   m_cfg = ahb_master_cfg::type_id::create("m_cfg");
   m_cfg.vif = env_cfg.vif;
   m_cfg.is_active = env_cfg.m_is_active;
   uvm_config_db#(ahb_master_cfg)::set(this, "ahb_master*", "ahb_master_cfg", m_cfg);

   // set slave agent configuration        
   s_cfg = ahb_slave_cfg::type_id::create("s_cfg");
   s_cfg.vif = env_cfg.vif;
   s_cfg.is_active = env_cfg.s_is_active;
   uvm_config_db#(ahb_slave_cfg)::set(this, "ahb_slave*", "ahb_slave_cfg", s_cfg);

   super.build_phase(phase);

   ahb_master = ahb_master_agent::type_id::create("ahb_master", this);
   ahb_slave  = ahb_slave_agent::type_id::create("ahb_slave", this);
endfunction

function void ahb_env::connect_phase(uvm_phase phase);
endfunction

