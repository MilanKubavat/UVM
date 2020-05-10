//----------------------------------------------------------
// Start Date: 10 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: ahb slave base and reactive sequence
//              implementation 
//----------------------------------------------------------

class ahb_slave_base_seq extends uvm_sequence #(ahb_slave_xtn);

  `uvm_object_utils(ahb_slave_base_seq)

  function new(string name="ahb_slave_base_seq");
      super.new(name);
  endfunction:new
endclass: ahb_slave_base_seq

class ahb_slave_seq extends ahb_slave_base_seq;

  `uvm_object_utils(ahb_slave_seq)

  extern function new (string name = "ahb_slave_seq");
  extern task body();
endclass: ahb_slave_seq

function ahb_slave_seq::new(string name = "ahb_slave_seq");
    super.new(name);
endfunction

task ahb_slave_seq::body();
  req = ahb_slave_xtn::type_id::create("req");
  forever begin
    start_item(req);
    finish_item(req);
  end
endtask
