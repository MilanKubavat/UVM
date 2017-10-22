class myreg extends uvm_reg;
   `uvm_object_utils(myreg)

   rand uvm_reg_field rf1;

   function new(string name = "");
      super.new(name, 32, UVM_NO_COVERAGE);
   endfunction

   function void build();
      rf1 = uvm_reg_field::type_id::create("rf1");
      rf1.configure(this, 32, 0, "RW", 0, 0, 1, 1, 0);
   endfunction 

endclass


class reg_model extends uvm_reg_block;
   `uvm_component_utils(reg_model)

   rand myreg dreg0;
   rand myreg dreg1;

   function new(string name = "");
      super.new(name, build_coverage(UVM_NO_COVERAGE));
   endfunction

   function void build();
      //DUT Register 0 Configurations
      dreg0 = myreg::type_id::create("dreg0");
      dreg0.build();
      dreg0.configure(this);
      dreg0.add_hdl_path_slice("dreg0", 0, 32);

      //DUT Register 1 Configurations
      dreg1 = myreg::type_id::create("dreg1");
      dreg1.build();
      dreg1.configure(this);
      dreg1.add_hdl_path_slice("dreg1", 1, 32);
      
      //Name, Base, Number of Bytes
      default_map = create_map("my_regmap", 0, 8, UVM_LITTLE_ENDIAN);
      
      default_map.add_reg(dreg0, 0, "RW");
      default_map.add_reg(dreg1, 1, "RW");

      lock_model();
   endfunction

endclass

