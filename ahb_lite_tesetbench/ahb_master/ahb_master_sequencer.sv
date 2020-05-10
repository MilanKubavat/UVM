//----------------------------------------------------------
// Start Date: 10 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: ahb master sequencer 
//----------------------------------------------------------

class ahb_master_sequencer extends uvm_sequencer#(ahb_master_xtn);

  `uvm_component_utils(ahb_master_sequencer)

  extern function new(string name = "ahb_master_sequencer", uvm_component parent);

endclass: ahb_master_sequencer

function ahb_master_sequencer::new(string name = "ahb_master_sequencer", uvm_component parent);
  super.new(name, parent);
endfunction
