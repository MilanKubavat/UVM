class ClockResetEnv extends uvm_agent;
  `uvm_component_utils(ClockResetEnv)

  ClockAgent clk_agent;
  ResetAgent rst_agent;

  ClockResetCfg CR_Cfg;

  extern function new(string name="ClockResetEnv", uvm_component parent);
  extern function void build_phase(uvm_phase phase);

endclass : ClockResetEnv

function ClockResetEnv::new(string name="ClockResetEnv", uvm_component parent);
  super.new(name, parent);
endfunction : new

function void ClockResetEnv::build_phase(uvm_phase phase);
  if(!uvm_config_db#(ClockResetCfg)::get(this, "", "ClockResetCfg", CR_Cfg))
    `uvm_fatal("CFG/ERROR", "Failed to get CFG..")

  if(CR_Cfg.createClock)
    clk_agent = ClockAgent::type_id::create("clk_agent", this);

  if(CR_Cfg.createReset)
    rst_agent = ResetAgent::type_id::create("rst_agent", this);
endfunction : build_phase

