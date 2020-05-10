//----------------------------------------------------------
// Start Date: 8 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: simple write test on a given address 
//----------------------------------------------------------

class spi_write_test extends spi_base_test;
     
  `uvm_component_utils(spi_write_test);

  spi_write_seq write_seq_h;
  spi_slave_seq slave_seq_h;

  extern function new (string name = "spi_write_test",uvm_component parent);
  extern function void build_phase (uvm_phase phase);
  extern task run_phase (uvm_phase phase);
endclass:spi_write_test

  // constructor
  function spi_write_test::new(string name = "spi_write_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  // build phase
  function void spi_write_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  // run phase
  task spi_write_test::run_phase(uvm_phase phase);
    phase.raise_objection(this);
 
    write_seq_h = spi_write_seq::type_id::create("write_seq_h");
    slave_seq_h = spi_slave_seq::type_id::create("slave_seq_h");
    
    fork
      // master write seq
      write_seq_h.address = 'h12;
      write_seq_h.data = 'h55;
      write_seq_h.start(env.spi_master.seqr_h);
      // slave reactive seq
      slave_seq_h.start(env.spi_slave.seqr_h);
    join

    phase.drop_objection(this);
  endtask

