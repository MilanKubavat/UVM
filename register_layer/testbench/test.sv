class test extends uvm_test;
   `uvm_component_utils(test)

   environment env;
   reg_seq seq;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   function void build_phase(uvm_phase phase);
      env = environment::type_id::create("env", this);
      seq = reg_seq::type_id::create("seq");
   endfunction

   function void connect_phase(uvm_phase phase);
      seq.regmodel = env.regmodel;
   endfunction

   task run_phase(uvm_phase phase);
      phase.raise_objection(this);
         seq.start(env.seqr);
         #100;
      phase.drop_objection(this);
   endtask

endclass

