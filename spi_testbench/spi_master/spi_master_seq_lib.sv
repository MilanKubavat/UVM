//----------------------------------------------------------
// Start Date: 8 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: spi master base, write and read sequences 
//----------------------------------------------------------

class spi_master_base_seq extends uvm_sequence #(spi_transaction);

  `uvm_object_utils(spi_master_base_seq)

  logic [6:0] address;
  logic [7:0] data;

  function new(string name="spi_master_base_seq");
    super.new(name);
  endfunction:new
endclass: spi_master_base_seq

class spi_write_seq extends spi_master_base_seq;

  `uvm_object_utils(spi_write_seq)

  extern function new (string name = "spi_write_seq");
  extern task body();
endclass: spi_write_seq

function spi_write_seq::new(string name = "spi_write_seq");
    super.new(name);
endfunction

task spi_write_seq::body();
  req = spi_transaction::type_id::create("req");
  start_item(req);
    req.instruction = {1'b0, this.address};
    req.data = this.data;
  finish_item(req);
endtask

class spi_read_seq extends spi_master_base_seq;

  `uvm_object_utils(spi_read_seq)

  extern function new (string name = "spi_read_seq");
  extern task body();
endclass: spi_read_seq

function spi_read_seq::new(string name = "spi_read_seq");
    super.new(name);
endfunction

task spi_read_seq::body();
  req = spi_transaction::type_id::create("req");
  $display("Master read requence");
  start_item(req);
    req.instruction = {1'b1, this.address};
  finish_item(req);
endtask
