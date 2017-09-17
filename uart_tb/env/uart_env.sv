class uart_env extends uvm_env;

	`uvm_component_utils(uart_env)

	//Config Object Handle
	uart_env_config env_cfg;
	
	//Dynamic Array of Agent Handles
	uart_agent_top agt_top;

	//Virtual Sequencer Handle
	uart_virtual_sequencer v_sequencer;

	//Scoreboard Handle
	//uart_scoreboard sb;

	//-----------------------------------
	// Methods
	//-----------------------------------

	extern function new(string name = "uart_env", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass: uart_env


function uart_env::new(string name = "uart_env", uvm_component parent);
	super.new(name, parent);
endfunction: new

function void uart_env::build_phase(uvm_phase phase);
	super.build_phase(phase);

	if(!uvm_config_db#(uart_env_config)::get(this, "", "uart_env_config", env_cfg))
		`uvm_fatal(get_type_name(), "Cannot get interface from env_config")

	if(env_cfg.has_agent)
			agt_top = uart_agent_top::type_id::create("agt_top" , this);

	if(env_cfg.has_virtual_sequencer)
	begin
		v_sequencer = uart_virtual_sequencer::type_id::create("v_sequencer", this);
		v_sequencer.seqrh = new[env_cfg.no_of_agt];
	end
/*	if(env_cfg.has_scoreboard)
	begin	
		sb = router_scoreboard::type_id::create("sb", this);
		sb.fifo_rdh = new[env_cfg.no_of_ragt];
		sb.fifo_wrh = new[env_cfg.no_of_wagt];
		foreach(sb.fifo_rdh[i])
			sb.fifo_rdh[i] = new($sformatf("fifo_rdh[%0d]", i), this);
		foreach(sb.fifo_wrh[i])
			sb.fifo_wrh[i] = new($sformatf("fifo_wrh[%0d]", i), this);
	end
*/
endfunction: build_phase


function void uart_env::connect_phase(uvm_phase phase);
	super.connect_phase(phase);

	if(env_cfg.has_virtual_sequencer)
	begin
		if(env_cfg.has_agent)
		begin
			foreach(agt_top.agt[i])
				v_sequencer.seqrh[i] = agt_top.agt[i].sequencer;
		end
		
	end

	/*if(env_cfg.has_scoreboard)
	begin
		foreach(ragt_top.ragt[i])
			ragt_top.ragt[i].monh.monitor_ap.connect(sb.fifo_rdh[i].analysis_export);
		foreach(wagt_top.wagt[i])
			wagt_top.wagt[i].monh.monitor_ap.connect(sb.fifo_wrh[i].analysis_export);
	end
   */
endfunction: connect_phase
