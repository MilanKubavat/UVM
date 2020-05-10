//----------------------------------------------------------
// Start Date: 10 Apr 2020
// Last Modified: 
// Author: Milan Kubavat
//
// Description: base test to set env cfg and create env 
//----------------------------------------------------------

class ahb_base_test extends uvm_test;

  `uvm_component_utils(ahb_base_test)

  virtual ahb_interface vif;
  ahb_env env;
  ahb_env_cfg env_cfg;

  uvm_active_passive_enum m_is_active;
  uvm_active_passive_enum s_is_active;

  extern function new(string name = "ahb_base_test", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);

endclass: ahb_base_test

// constructor
function ahb_base_test::new(string name = "ahb_base_test", uvm_component parent);
  super.new(name, parent);
endfunction

// build pahse
function void ahb_base_test::build_phase(uvm_phase phase);
   env_cfg = ahb_env_cfg::type_id::create("env_cfg");

   // fatal error if vif not found in config db
   if(!uvm_config_db#(virtual ahb_interface)::get(this, "", "ahb_interface", vif)) begin
     `uvm_fatal(get_full_name(), "Cannot get VIF from configuration database!")
   end

   // configure env variables and create env
   env_cfg.vif = vif;

   m_is_active = UVM_ACTIVE;
   s_is_active = UVM_ACTIVE;

   env_cfg.m_is_active = m_is_active;
   env_cfg.s_is_active = s_is_active;

   uvm_config_db#(ahb_env_cfg)::set(this, "*", "ahb_env_cfg", env_cfg);

   super.build_phase(phase);

   env = ahb_env::type_id::create("env", this);
endfunction

function void ahb_base_test::end_of_elaboration_phase(uvm_phase phase);
  print();
endfunction
