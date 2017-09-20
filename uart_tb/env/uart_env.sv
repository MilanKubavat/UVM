class uart_env extends uvm_env;
    
    `uvm_component_utils(uart_env)

//handle for env_cfg
    uart_env_config env_cfg;

//handle for agent top
    uart_agent_top agt_top;

//handle for scoreboard, virtual sequencer
    uart_virtual_sequencer v_sequencer;
    uart_sb sb;
    coverage_collector covh[];

    extern function new(string name = "uart_env",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern function void end_of_elaboration_phase (uvm_phase phase);

endclass:uart_env


//constructor
    function uart_env::new(string name = "uart_env",uvm_component parent);
        super.new(name,parent);
    endfunction

//build_phase
    function void uart_env::build_phase(uvm_phase phase);
        if(!uvm_config_db #(uart_env_config)::get(this,"","uart_env_config",env_cfg))
        `uvm_fatal("uart_env","unable to get env_cfg")

        if(env_cfg.has_agent_top)
        agt_top = uart_agent_top::type_id::create("agt_top",this);
        
        if(env_cfg.has_virtual_sequencer)
        begin
        v_sequencer = uart_virtual_sequencer::type_id::create("v_seuqnecer",this);
        $display("--------%0d-------------",env_cfg.no_of_agt);
        v_sequencer.sqrh = new[env_cfg.no_of_agt];
        end

        if(env_cfg.has_scoreboard)
        sb = uart_sb::type_id::create("sb",this);

        if(env_cfg.has_coverage)
        begin
        covh = new[env_cfg.no_of_agt];
        foreach(covh[i])
        covh[i] = coverage_collector::type_id::create($sformatf("covh[%0d]",i),this);
        end


    endfunction:build_phase

//connect phase
    function void uart_env::connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if(env_cfg.has_virtual_sequencer)
        begin

            if(env_cfg.has_agent)
            begin
                foreach(agt_top.agent[i])
                v_sequencer.sqrh[i] = agt_top.agent[i].sequencer;
            end
        end

        foreach(agt_top.agent[i])
        begin
        agt_top.agent[i].monitor.mon_ap.connect(sb.uart_fifo[i].analysis_export);
        agt_top.agent[i].monitor.mon_ap.connect(covh[i].analysis_export);
        end
        
    endfunction

//end of elaboration phase to print topology
    function void uart_env::end_of_elaboration_phase (uvm_phase phase);
        uvm_top.print_topology();
    endfunction:end_of_elaboration_phase
