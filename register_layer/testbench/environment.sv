class environment extends uvm_env;
   `uvm_component_utils(environment)

   driver drv;
   sequencer seqr;

   reg_model regmodel;
   adapter adptr;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   function void build_phase(uvm_phase phase);
      drv = driver::type_id::create("drv", this);
      seqr = sequencer::type_id::create("seqr", this);

      adptr = adapter::type_id::create("adptr");
      regmodel = reg_model::type_id::create("regmodel", this);
   endfunction

   function void connect_phase(uvm_phase phase);
      drv.seq_item_port.connect(seqr.seq_item_export);

      //Register Model Configurations
      regmodel.default_map.set_sequencer(.sequencer(seqr), .adapter(adptr));
      regmodel.default_map.set_base_addr(0);
      regmodel.add_hdl_path("top.dut");
   endfunction

endclass
