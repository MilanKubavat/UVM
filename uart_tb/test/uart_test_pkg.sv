package uart_test_pkg;

	//---------------------------------------------------------
	// File includes
	//---------------------------------------------------------
	import uvm_pkg::*;
   `include "timescale.v"
	`include "uvm_macros.svh"

	`include "uart_agt_config.sv"
	`include "uart_env_config.sv"
	
	`include "uart_xtn.sv"
	`include "uart_driver.sv"
	`include "uart_monitor.sv"
	`include "uart_sequencer.sv"
	`include "uart_agent.sv"
	`include "uart_agent_top.sv"
	`include "uart_seqs.sv"

	`include "uart_virtual_sequencer.sv"
	`include "uart_virtual_seqs.sv"
	//`include "uart_scoreboard.svh"

	`include "uart_env.sv"

	`include "uart_test.sv"

endpackage
