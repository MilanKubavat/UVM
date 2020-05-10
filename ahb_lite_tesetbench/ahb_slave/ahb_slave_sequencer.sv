//----------------------------------------------------------
// Start Date: 10 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: ahb slave sequencer
//----------------------------------------------------------

class ahb_slave_sequencer extends uvm_sequencer#(ahb_slave_xtn);

  `uvm_component_utils(ahb_slave_sequencer)

  extern function new(string name = "ahb_slave_sequencer", uvm_component parent);
endclass: ahb_slave_sequencer

function ahb_slave_sequencer::new(string name = "ahb_slave_sequencer", uvm_component parent);
  super.new(name, parent);
endfunction
