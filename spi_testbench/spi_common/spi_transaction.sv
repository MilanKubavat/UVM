//----------------------------------------------------------
// Start Date: 8 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: Transaction class 
//----------------------------------------------------------

class spi_transaction extends uvm_sequence_item;

  `uvm_object_utils(spi_transaction)
  
  bit [7:0] data;
  bit [7:0] instruction;
 
  // TODO : Error using below macros
  //`uvm_object_utils_begin(spi_transaction)
  //   `uvm_field_int(write, UVM_ALL_ON)
  //   `uvm_field_int(read, UVM_ALL_ON)
  //   `uvm_field_int(data, UVM_ALL_ON)
  //`uvm_object_utils_end

  extern function new (string name = "spi_transaction");
  extern function void do_print (uvm_printer printer);
endclass: spi_transaction

function spi_transaction::new(string name = "spi_transaction");
  super.new(name);
endfunction

function void spi_transaction::do_print (uvm_printer printer);
  super.do_print(printer);
  if(instruction[7] == 1) 
    printer.print_field("read",  1,  1, UVM_BIN);
  else
    printer.print_field("write",  1, 1, UVM_BIN);
  printer.print_field("addr",  instruction[6:0],  8, UVM_DEC);
  printer.print_field("data",  data,  8, UVM_DEC);
endfunction
