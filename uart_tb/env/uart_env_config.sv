//environment config class
class uart_env_config extends uvm_object;

    `uvm_object_utils(uart_env_config)

//agent config handles
    uart_agent_config agt_cfg[];

//configurable parameters
    bit has_agent;
    int no_of_agt;
    bit has_agent_top;
    bit has_virtual_sequencer;
    bit has_scoreboard;
    bit has_coverage;

    extern function new(string name = "uart_env_config");

endclass:uart_env_config


//constructor 
    function uart_env_config::new(string name = "uart_env_config");
        super.new(name);
    endfunction:new
