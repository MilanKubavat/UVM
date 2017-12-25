class ClockResetBaseTest extends uvm_test;
  `uvm_component_utils(ClockResetBaseTest)

  ClockResetEnv CR_Env;
  ClockResetCfg CR_Cfg;


  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction


  function void build_phase(uvm_phase phase);
    CR_Cfg = ClockResetCfg::type_id::create("CR_Cfg");
    uvm_config_db#(ClockResetCfg)::set(this, "*", "ClockResetCfg", CR_Cfg);

    CR_Env = ClockResetEnv::type_id::create("CR_Env", this);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    #100ns;
    phase.drop_objection(this);
  endtask

endclass

