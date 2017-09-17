class uart_agent_config extends uvm_object;

	`uvm_object_utils(uart_agent_config)
	
	virtual uart_if vif;
	
	uvm_active_passive_enum is_active;

	extern function new(string name = "uart_agent_config");
endclass: uart_agent_config


function uart_agent_config::new(string name = "uart_agent_config");
	super.new(name);
endfunction
