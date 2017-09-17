class uart_virtual_sequencer extends uvm_sequencer#(uvm_sequence_item);
	`uvm_component_utils(uart_virtual_sequencer)

	uart_sequencer seqrh[];

	extern function new(string name = "uart_virtual_sequencer", uvm_component parent);
endclass

function uart_virtual_sequencer::new(string name = "uart_virtual_sequencer", uvm_component parent);
	super.new(name, parent);
endfunction
