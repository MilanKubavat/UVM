class uart_agent_top extends uvm_agent;

	//Factory Registration
	`uvm_component_utils(uart_agent_top)

	//Write Agent Handle Array
	uart_agent agent[];

	//Env Config
	uart_env_config env_cfg;

	//--------------------------------------
	// Methods
	//--------------------------------------

	extern function new(string name = "uart_agent_top", uvm_component parent);
	extern function void build_phase(uvm_phase phase);

endclass: uart_agent_top


function uart_agent_top::new(string name = "uart_agent_top", uvm_component parent);
	super.new(name, parent);
endfunction: new

function void uart_agent_top::build_phase(uvm_phase phase);
	if(!uvm_config_db#(uart_env_config)::get(this, "", "uart_env_config", env_cfg))
		`uvm_fatal("uart_agent_top", "Cannot get env_config")

	super.build_phase(phase);
	
	if(env_cfg.has_agent)
	begin
		agent = new[env_cfg.no_of_agt];
		foreach(agent[i])
		begin
			agent[i] = uart_agent::type_id::create($sformatf("agent[%0d]", i), this);
			uvm_config_db#(uart_agent_config)::set(this, $sformatf("*agent[%0d]*", i), "uart_agent_config", env_cfg.agt_cfg[i]);
		end
	end
	

endfunction: build_phase
