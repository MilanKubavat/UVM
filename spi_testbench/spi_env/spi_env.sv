//----------------------------------------------------------
// Start Date: 8 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: spi env creates and connects mon, sb, agents 
//----------------------------------------------------------

class spi_env extends uvm_env;

  `uvm_component_utils(spi_env)

  spi_env_cfg  env_cfg;
  spi_master_cfg m_cfg;
  spi_slave_cfg  s_cfg;

  //reset_agent reset_agent_h;
  spi_master_agent spi_master;
  spi_slave_agent  spi_slave;
  spi_monitor      spi_mon;

  extern function new(string name = "spi_env", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass: spi_env

// constructor
function spi_env::new(string name = "spi_env", uvm_component parent);
  super.new(name, parent);

endfunction

// build phase
function void spi_env::build_phase(uvm_phase phase);

   // fatal error if env cfg not found in config db
   if(!uvm_config_db#(spi_env_cfg)::get(this, "", "spi_env_cfg", env_cfg)) begin
    `uvm_fatal(get_full_name(), "Cannot get ENV-CONFIG from configuration database!")
   end

   // set master agent configuration       
   m_cfg = spi_master_cfg::type_id::create("m_cfg");
   m_cfg.spi_vif = env_cfg.spi_vif;
   m_cfg.is_active = env_cfg.m_is_active;
   uvm_config_db#(spi_master_cfg)::set(this, "spi_master*", "spi_master_cfg", m_cfg);

   // set slave agent configuration        
   s_cfg = spi_slave_cfg::type_id::create("s_cfg");
   s_cfg.spi_vif = env_cfg.spi_vif;
   s_cfg.is_active = env_cfg.s_is_active;
   uvm_config_db#(spi_slave_cfg)::set(this, "spi_slave*", "spi_slave_cfg", s_cfg);

   super.build_phase(phase);

   spi_master = spi_master_agent::type_id::create("spi_master", this);
   spi_slave  = spi_slave_agent::type_id::create("spi_slave", this);
   spi_mon    = spi_monitor::type_id::create("spi_mon", this);

endfunction

// connect phase
function void spi_env::connect_phase(uvm_phase phase);
endfunction

