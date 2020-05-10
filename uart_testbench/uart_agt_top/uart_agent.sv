class uart_agent extends uvm_agent;

	//Register with Factory
	`uvm_component_utils(uart_agent)

	//Agent Config Object Handle
	uart_agent_config agt_cfg;

	//Component Handles
	uart_driver driver;
	uart_monitor monitor;
	uart_sequencer sequencer;

	//------------------------------------
	// Methods
	//------------------------------------

	extern function new(string name = "uart_agent", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass: uart_agent


function uart_agent::new(string name = "uart_agent", uvm_component parent);
	super.new(name, parent);
endfunction

function void uart_agent::build_phase(uvm_phase phase);
	if(!uvm_config_db#(uart_agent_config)::get(this, "", "uart_agent_config", agt_cfg))
		`uvm_fatal("uart_agent", "Cannot get from agt_config")

	super.build_phase(phase);

	monitor = uart_monitor::type_id::create("monitor", this);

	if(agt_cfg.is_active == UVM_ACTIVE)
	begin
		driver = uart_driver::type_id::create("driver", this);
		sequencer = uart_sequencer::type_id::create("sequencer", this);
	end
endfunction: build_phase

function void uart_agent::connect_phase(uvm_phase phase);
	if(agt_cfg.is_active == UVM_ACTIVE)
		driver.seq_item_port.connect(sequencer.seq_item_export);
endfunction	
