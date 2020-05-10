//----------------------------------------------------------
// Start Date: 8 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: spi slave sequencer
//----------------------------------------------------------

class spi_slave_sequencer extends uvm_sequencer#(spi_transaction);

  `uvm_component_utils(spi_slave_sequencer)

  extern function new(string name = "spi_slave_sequencer", uvm_component parent);
endclass: spi_slave_sequencer

function spi_slave_sequencer::new(string name = "spi_slave_sequencer", uvm_component parent);
  super.new(name, parent);
endfunction
