//----------------------------------------------------------
// Start Date: 8 Apr 2020
// Last Modified: 
// Author: Milan Kubavat
//
// Description: base test to set env cfg and create env 
//----------------------------------------------------------

class spi_base_test extends uvm_test;

  `uvm_component_utils(spi_base_test)

  virtual spi_interface spi_vif;
  spi_env env;
  spi_env_cfg env_cfg;

  uvm_active_passive_enum m_is_active;
  uvm_active_passive_enum s_is_active;

  extern function new(string name = "spi_base_test", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);

endclass: spi_base_test

// constructor
function spi_base_test::new(string name = "spi_base_test", uvm_component parent);
  super.new(name, parent);
endfunction

// build pahse
function void spi_base_test::build_phase(uvm_phase phase);
   env_cfg = spi_env_cfg::type_id::create("env_cfg");

   // fatal error if spi_intf not found in config db
   if(!uvm_config_db#(virtual spi_interface)::get(this, "", "spi_interface", spi_vif)) begin
     `uvm_fatal(get_full_name(), "Cannot get VIF from configuration database!")
   end

   env_cfg.spi_vif = spi_vif;

   m_is_active = UVM_ACTIVE;
   s_is_active = UVM_ACTIVE;

   env_cfg.m_is_active = m_is_active;
   env_cfg.s_is_active = s_is_active;

   uvm_config_db#(spi_env_cfg)::set(this, "*", "spi_env_cfg", env_cfg);

   super.build_phase(phase);

   env = spi_env::type_id::create("env", this);
endfunction

function void spi_base_test::end_of_elaboration_phase(uvm_phase phase);
  print();
endfunction
