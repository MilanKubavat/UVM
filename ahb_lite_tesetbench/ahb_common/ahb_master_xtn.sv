//----------------------------------------------------------
// Start Date: 10 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: Master Transaction class 
//----------------------------------------------------------

class ahb_master_xtn extends uvm_sequence_item;

  `uvm_object_utils(ahb_master_xtn)
  
  // TODO : Error using below macros
  //`uvm_object_utils_begin(ahb_master_xtn)
  //`uvm_object_utils_end

  extern function new (string name = "ahb_master_xtn");
  extern function void do_print (uvm_printer printer);
endclass: ahb_master_xtn

function ahb_master_xtn::new(string name = "ahb_master_xtn");
  super.new(name);
endfunction

function void ahb_master_xtn::do_print (uvm_printer printer);
  super.do_print(printer);
  // TODO: write print method
endfunction
