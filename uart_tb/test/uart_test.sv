class uart_base_test extends uvm_test;

	`uvm_component_utils(uart_base_test)

	uart_env env_h;
	uart_env_config env_cfg;

	uart_agent_config agt_cfg[];

	int unsigned no_of_agt = 2;

	bit has_agent = 1;
	bit has_virtual_sequencer = 1;

	//-------------------------------------
	//Methods
	//-------------------------------------
	
	extern function new(string name = "uart_base_test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void config_uart();
	extern function void end_of_elaboration_phase(uvm_phase phase);

endclass


function uart_base_test::new(string name = "uart_base_test", uvm_component parent);
	super.new(name, parent);
endfunction

function void uart_base_test::config_uart();
	if(has_agent)
	begin
		agt_cfg = new[no_of_agt];
		foreach(agt_cfg[i])
		begin
			agt_cfg[i] = uart_agent_config::type_id::create($sformatf("agt_cfg[%0d]", i));
			if(!uvm_config_db#(virtual uart_if)::get(this, "", $sformatf("if%0d", i), agt_cfg[i].vif))
				`uvm_fatal("TEST", "Cannot get vif from database")
			agt_cfg[i].is_active = UVM_ACTIVE;
			env_cfg.agt_cfg[i] = agt_cfg[i];
		end
	end


	env_cfg.no_of_agt = no_of_agt;
	env_cfg.has_agent = has_agent;
	env_cfg.has_virtual_sequencer = has_virtual_sequencer;

endfunction



function void uart_base_test::build_phase(uvm_phase phase);
	env_cfg = uart_env_config::type_id::create("env_cfg");
	
	if(has_agent)
		env_cfg.agt_cfg = new[no_of_agt];
	config_uart();
	uvm_config_db#(uart_env_config)::set(this, "*", "uart_env_config", env_cfg);

	super.build_phase(phase);

	env_h = uart_env::type_id::create("env_h", this);
endfunction

function void uart_base_test::end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology();	
endfunction

//------------------------------------------------------------Delay test
//scenario...............................................................//

class test1 extends uart_base_test;

   `uvm_component_utils(test1)

   config_vseq config_h;
   tx_rx_vseq data_h;

   extern function new(string name = "test1", uvm_component parent);
   extern function void build_phase(uvm_phase phase);
   extern task run_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);

endclass

   function test1::new(string name="test1",uvm_component parent);
      super.new(name,parent);
   endfunction

    function void test1::build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction

   function void test1::end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology();	
   endfunction

   task test1::run_phase(uvm_phase phase);
        phase.raise_objection(this);
        config_h = config_vseq::type_id::create("config_h");
        data_h = tx_rx_vseq::type_id::create("data_h");
        config_h.start(env_h.v_sequencer);
        data_h.start(env_h.v_sequencer);
        #1000;
        phase.drop_objection(this);
   endtask
