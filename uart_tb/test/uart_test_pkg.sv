package uart_test_pkg;

//import uvm_pkg
    import uvm_pkg::*;

    `include "uvm_macros.svh"

    `include "uart_xtn.sv"
    `include "uart_seqs.sv"
    `include "uart_agt_config.sv"
    `include "uart_env_config.sv"
    `include "uart_sequencer.sv"
    `include "uart_monitor.sv"
    `include "uart_driver.sv"
    `include "uart_agent.sv"
    `include "uart_agent_top.sv"
    `include "uart_virtual_sequencer.sv"
    `include "uart_virtual_seqs.sv"
    `include "uart_sb.sv"
    `include "uart_cov.sv"
    `include "uart_env.sv"
    `include "uart_test.sv"

endpackage: uart_test_pkg
