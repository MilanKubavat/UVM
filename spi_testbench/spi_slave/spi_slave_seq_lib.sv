//----------------------------------------------------------
// Start Date: 8 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: spi slave base and reactive sequence
//              implementation 
//----------------------------------------------------------

class spi_slave_base_seq extends uvm_sequence #(spi_transaction);

    `uvm_object_utils(spi_slave_base_seq)

    function new(string name="spi_slave_base_seq");
        super.new(name);
    endfunction:new
endclass: spi_slave_base_seq

class spi_slave_seq extends spi_slave_base_seq;

  `uvm_object_utils(spi_slave_seq)

  extern function new (string name = "spi_slave_seq");
  extern task body();
endclass: spi_slave_seq

function spi_slave_seq::new(string name = "spi_slave_seq");
    super.new(name);
endfunction

task spi_slave_seq::body();
  req = spi_transaction::type_id::create("req");
  forever begin
    start_item(req);
    finish_item(req);
  end
endtask
