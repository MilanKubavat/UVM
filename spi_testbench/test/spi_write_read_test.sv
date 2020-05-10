//----------------------------------------------------------
// Start Date: 8 Apr 2020
// Last Modified: 
// Author: Milan Kubavat
//
// Description: spi_write_read_test to launch write and read
//              to the same slave memory address  
//----------------------------------------------------------

class spi_write_read_test extends spi_base_test;
     
  `uvm_component_utils(spi_write_read_test);

  spi_write_seq write_seq_h;
  spi_read_seq  read_seq_h;
  spi_slave_seq slave_seq_h;

  extern function new (string name = "spi_write_read_test",uvm_component parent);
  extern function void build_phase (uvm_phase phase);
  extern task run_phase (uvm_phase phase);
endclass:spi_write_read_test

  // constructor
  function spi_write_read_test::new(string name = "spi_write_read_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  // build phase
  function void spi_write_read_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  // run phase
  task spi_write_read_test::run_phase(uvm_phase phase);
    phase.raise_objection(this);
 
    write_seq_h = spi_write_seq::type_id::create("write_seq_h");
    read_seq_h  = spi_read_seq::type_id::create("read_seq_h");
    slave_seq_h = spi_slave_seq::type_id::create("slave_seq_h");
    
    fork
      // master write_read seq
      begin
        write_seq_h.address = 'h8;
        write_seq_h.data = 'ha;
        write_seq_h.start(env.spi_master.seqr_h);
        #100;
        read_seq_h.address = 7'h8;
        read_seq_h.start(env.spi_master.seqr_h);
      end
      // slave reactive seq
      slave_seq_h.start(env.spi_slave.seqr_h);
    join_any

    phase.drop_objection(this);
  endtask

