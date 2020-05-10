//----------------------------------------------------------
// Start Date: 10 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: ahb master sequences 
//----------------------------------------------------------

class ahb_master_base_seq extends uvm_sequence #(ahb_master_xtn);

  `uvm_object_utils(ahb_master_base_seq)

  function new(string name="ahb_master_base_seq");
    super.new(name);
  endfunction:new
endclass: ahb_master_base_seq
