//----------------------------------------------------------
// Start Date: 8 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: spi master sequencer 
//----------------------------------------------------------

class spi_master_sequencer extends uvm_sequencer#(spi_transaction);

  `uvm_component_utils(spi_master_sequencer)

  extern function new(string name = "spi_master_sequencer", uvm_component parent);

endclass: spi_master_sequencer

  // constructor
  function spi_master_sequencer::new(string name = "spi_master_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction
