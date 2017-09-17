class uart_env_config extends uvm_object;

	`uvm_object_utils(uart_env_config)

	uart_agent_config agt_cfg[];

	bit has_agent;
	bit has_virtual_sequencer;

	int unsigned no_of_agt;

	extern function new(string name = "uart_env_config");
endclass: uart_env_config

function uart_env_config::new(string name = "uart_env_config");
	super.new(name);
endfunction
