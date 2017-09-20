class base_test extends uvm_test;

    `uvm_component_utils(base_test)

//configuration object handles
    uart_agent_config agt_cfg[];
    uart_env_config env_cfg;

//environment handle
    uart_env env;

//config parameters
    bit has_agent = 1;
    int no_of_agent = 2;
    bit has_scoreboard = 1;
    bit has_coverage = 1;
    bit has_agent_top = 1;
    bit has_virtual_sequencer = 1;

    extern function new(string name = "base_test", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void configuration();

endclass:base_test


//constructor
    function base_test::new(string name = "base_test",uvm_component parent);
        super.new(name, parent);
    endfunction

//build_phase
    function void base_test::build_phase(uvm_phase phase);
        env_cfg = uart_env_config::type_id::create("env_cfg");
            
        if(has_agent)
            env_cfg.agt_cfg = new[no_of_agent];

        configuration();

        uvm_config_db #(uart_env_config)::set(this,"*","uart_env_config",env_cfg);
        super.build_phase(phase);
        env = uart_env::type_id::create("env",this);

    endfunction


//configuration
    function void base_test::configuration();
        if(has_agent)
        begin
            agt_cfg = new[no_of_agent];
            foreach(agt_cfg[i])
                begin
                    agt_cfg[i] = uart_agent_config::type_id::create("agt_cfg");
                    if(!uvm_config_db #(virtual uart_if)::get(this, "", $sformatf("vif_%0d",i), agt_cfg[i].vif))
                    `uvm_fatal(get_type_name(),"cannot get vif from config db, have you set it?")    

                    agt_cfg[i].is_active = UVM_ACTIVE;
                    env_cfg.agt_cfg[i] = agt_cfg[i];
                end
        end
        env_cfg.has_agent = has_agent;
        env_cfg.has_agent_top = has_agent_top;
        env_cfg.no_of_agt = no_of_agent;
        env_cfg.has_virtual_sequencer = has_virtual_sequencer;
        env_cfg.has_scoreboard = has_scoreboard;
        env_cfg.has_coverage = has_coverage;
        
    endfunction

//----------------------------------test scenario 1 UART0 -> UART1 ------------------------------------//
    class uart_test_txrx extends base_test;
        
        `uvm_component_utils(uart_test_txrx);

        config_dl_vseq dl_vseqh;
        config_fcr_4byte_vseq fcr_4byteh;
        uart1_thr_enb_vseq ier_uart1;
        uart2_reciever_data_enb_vseq ier_uart2;
        tx_rx_4byte_vseq1 txrx_h1;
        tx_rx_4byte_vseq2 txrx_h2;

        extern function new (string name = "uart_test_txrx",uvm_component parent);
        extern function void build_phase (uvm_phase phase);
        extern task run_phase (uvm_phase phase);
    endclass:uart_test_txrx

    function uart_test_txrx::new(string name = "uart_test_txrx", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void uart_test_txrx::build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task uart_test_txrx::run_phase(uvm_phase phase);
        phase.raise_objection(this);

        dl_vseqh = config_dl_vseq::type_id::create("dl_vseqh");
        fcr_4byteh = config_fcr_4byte_vseq::type_id::create("fcr_4byteh");
        ier_uart1 = uart1_thr_enb_vseq::type_id::create("ier_uart1");    //THR empty enable 
        ier_uart2 = uart2_reciever_data_enb_vseq::type_id::create("ier_uart2");    //reciever data available enable
        txrx_h1 = tx_rx_4byte_vseq1::type_id::create("txrx_h1");
        txrx_h2 = tx_rx_4byte_vseq2::type_id::create("txrx_h2");
        
        dl_vseqh.start(env.v_sequencer);
        fcr_4byteh.start(env.v_sequencer);
        ier_uart1.start(env.v_sequencer);
        ier_uart2.start(env.v_sequencer);
        
        txrx_h1.start(env.v_sequencer);
        txrx_h2.start(env.v_sequencer);
        #(500 * 1us);
        phase.drop_objection(this);
    endtask

//----------------------------------test scenario 2 UART1 -> UART0 ------------------------------------//
    class uart_test_rxtx extends base_test;
        
        `uvm_component_utils(uart_test_rxtx);

        config_dl_vseq dl_vseqh;
        config_fcr_8byte_vseq fcr_8byteh;
        uart2_thr_enb_vseq ier_thr_uart2;
        uart1_reciever_data_enb_vseq ier_rec_uart1;
        tx_rx_8byte_vseq1 txrx_h1;
        tx_rx_8byte_vseq2 txrx_h2;
        
        extern function new (string name = "uart_test_rxtx",uvm_component parent);
        extern function void build_phase (uvm_phase phase);
        extern task run_phase (uvm_phase phase);
    endclass:uart_test_rxtx

    function uart_test_rxtx::new(string name = "uart_test_rxtx", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void uart_test_rxtx::build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task uart_test_rxtx::run_phase(uvm_phase phase);
        phase.raise_objection(this);

        dl_vseqh = config_dl_vseq::type_id::create("dl_vseqh");
        fcr_8byteh = config_fcr_8byte_vseq::type_id::create("fcr_8byteh");
        ier_thr_uart2 = uart2_thr_enb_vseq::type_id::create("ier_thr_uart2");    //THR empty enable 
        ier_rec_uart1 = uart1_reciever_data_enb_vseq::type_id::create("ier_rec_uart1");    //reciever data available enable
        txrx_h1 = tx_rx_8byte_vseq1::type_id::create("txrx_h1");
        txrx_h2 = tx_rx_8byte_vseq2::type_id::create("txrx_h2");
        
        dl_vseqh.start(env.v_sequencer);
        fcr_8byteh.start(env.v_sequencer);
        ier_thr_uart2.start(env.v_sequencer);
        ier_rec_uart1.start(env.v_sequencer);

        txrx_h2.start(env.v_sequencer);
        txrx_h1.start(env.v_sequencer);
        #1000;
        phase.drop_objection(this);
    endtask

//----------------------------------------test scenario 3(configure UARTs with parity enable)------------------------------------------------------------//
class uart1_parity_error_test extends base_test;
        
        `uvm_component_utils(uart1_parity_error_test);

        config_dl_vseq dl_vseqh;
        config_fcr_1byte_vseq fcr_1byteh;
        uart2_thr_enb_vseq ier_thr_uart2;
        uart1_reciever_data_enb_vseq ier_rec_uart1;
        parity_enb_vseq parity_enb;
        tx_rx_14byte_vseq1 txrx_h1;
        tx_rx_14byte_vseq2 txrx_h2;
        
        extern function new (string name = "uart1_parity_error_test",uvm_component parent);
        extern function void build_phase (uvm_phase phase);
        extern task run_phase (uvm_phase phase);
    endclass:uart1_parity_error_test

    function uart1_parity_error_test::new(string name = "uart1_parity_error_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void uart1_parity_error_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task uart1_parity_error_test::run_phase(uvm_phase phase);
        phase.raise_objection(this);

        dl_vseqh = config_dl_vseq::type_id::create("dl_vseqh");
        fcr_1byteh = config_fcr_1byte_vseq::type_id::create("fcr_1byteh");
        ier_thr_uart2 = uart2_thr_enb_vseq::type_id::create("ier_thr_uart2");    //THR empty enable 
        ier_rec_uart1 = uart1_reciever_data_enb_vseq::type_id::create("ier_rec_uart1");    //reciever data available enable
        parity_enb = parity_enb_vseq::type_id::create("parity_enb");    //parity enable to check for parity error
        txrx_h1 = tx_rx_14byte_vseq1::type_id::create("txrx_h1");
        txrx_h2 = tx_rx_14byte_vseq2::type_id::create("txrx_h2");
        
        dl_vseqh.start(env.v_sequencer);
        parity_enb.start(env.v_sequencer);
        fcr_1byteh.start(env.v_sequencer);
        ier_thr_uart2.start(env.v_sequencer);
        ier_rec_uart1.start(env.v_sequencer);

        txrx_h2.start(env.v_sequencer);
        txrx_h1.start(env.v_sequencer);
        #1000;
        phase.drop_objection(this);
    endtask

//----------------------------------------test scenario 4(configure UARTs with parity enable)------------------------------------------------------------//
class uart2_parity_error_test extends base_test;
        
        `uvm_component_utils(uart2_parity_error_test);

        config_dl_vseq dl_vseqh;
        config_fcr_1byte_vseq fcr_1byteh;
        uart1_thr_enb_vseq ier_thr_uart1;
        uart2_reciever_data_enb_vseq ier_rec_uart2;
        parity_enb_vseq parity_enb;
        tx_rx_8byte_vseq1 txrx_h1;
        tx_rx_8byte_vseq2 txrx_h2;
        
        extern function new (string name = "uart2_parity_error_test",uvm_component parent);
        extern function void build_phase (uvm_phase phase);
        extern task run_phase (uvm_phase phase);
    endclass:uart2_parity_error_test

    function uart2_parity_error_test::new(string name = "uart2_parity_error_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void uart2_parity_error_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task uart2_parity_error_test::run_phase(uvm_phase phase);
        phase.raise_objection(this);

        dl_vseqh = config_dl_vseq::type_id::create("dl_vseqh");
        fcr_1byteh = config_fcr_1byte_vseq::type_id::create("fcr_1byteh");
        ier_thr_uart1 = uart1_thr_enb_vseq::type_id::create("ier_thr_uart1");    //THR empty enable 
        ier_rec_uart2 = uart2_reciever_data_enb_vseq::type_id::create("ier_rec_uart2");    //reciever data available enable
        parity_enb = parity_enb_vseq::type_id::create("parity_enb");    //parity enable to check for parity error
        txrx_h1 = tx_rx_8byte_vseq1::type_id::create("txrx_h1");
        txrx_h2 = tx_rx_8byte_vseq2::type_id::create("txrx_h2");
        
        dl_vseqh.start(env.v_sequencer);
        parity_enb.start(env.v_sequencer);
        fcr_1byteh.start(env.v_sequencer);
        ier_thr_uart1.start(env.v_sequencer);
        ier_rec_uart2.start(env.v_sequencer);

        txrx_h1.start(env.v_sequencer);
        txrx_h2.start(env.v_sequencer);
        #1000;
        phase.drop_objection(this);
    endtask

//----------------------------------------test scenario 5(transmit 7bits in each character)------------------------------------------------------------//
class char_7bit_test extends base_test;
        
        `uvm_component_utils(char_7bit_test);

        config_dl_vseq dl_vseqh;
        config_fcr_1byte_vseq fcr_1byteh;
        uart2_thr_enb_vseq ier_thr_uart2;
        uart1_reciever_data_enb_vseq ier_rec_uart1;
        parity_enb_vseq parity_enb;
        char_7bit_vseq char_7bit;
        tx_rx_1byte_vseq1 txrx_h1;
        tx_rx_1byte_vseq2 txrx_h2;

        extern function new (string name = "char_7bit_test",uvm_component parent);
        extern function void build_phase (uvm_phase phase);
        extern task run_phase (uvm_phase phase);
    endclass:char_7bit_test

    function char_7bit_test::new(string name = "char_7bit_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void char_7bit_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task char_7bit_test::run_phase(uvm_phase phase);
        phase.raise_objection(this);

        dl_vseqh = config_dl_vseq::type_id::create("dl_vseqh");
        char_7bit = char_7bit_vseq::type_id::create("char_7bit");
        fcr_1byteh = config_fcr_1byte_vseq::type_id::create("fcr_1byteh");
        ier_thr_uart2 = uart2_thr_enb_vseq::type_id::create("ier_thr_uart2");    //THR empty enable 
        ier_rec_uart1 = uart1_reciever_data_enb_vseq::type_id::create("ier_rec_uart1");    //reciever data available enable
        //parity_enb = parity_enb_vseq::type_id::create("parity_enb");    //parity enable to check for parity error
        txrx_h1 = tx_rx_1byte_vseq1::type_id::create("txrx_h1");
        txrx_h2 = tx_rx_1byte_vseq2::type_id::create("txrx_h2");
        
        dl_vseqh.start(env.v_sequencer);
        char_7bit.start(env.v_sequencer);
        //parity_enb.start(env.v_sequencer);
        fcr_1byteh.start(env.v_sequencer);
        ier_thr_uart2.start(env.v_sequencer);
        ier_rec_uart1.start(env.v_sequencer);

        txrx_h2.start(env.v_sequencer);
        txrx_h1.start(env.v_sequencer);

        #1000;
        phase.drop_objection(this);
    endtask

//----------------------------------------test scenario 6(transmit 6bits in each character)------------------------------------------------------------//
class char_6bit_test extends base_test;
        
        `uvm_component_utils(char_6bit_test);

        config_dl_vseq dl_vseqh;
        config_fcr_4byte_vseq fcr_4byteh;
        uart1_thr_enb_vseq ier_thr_uart1;
        uart2_reciever_data_enb_vseq ier_rec_uart2;
        parity_enb_vseq parity_enb;
        char_6bit_vseq char_6bit;
        tx_rx_4byte_vseq1 txrx_h1;
        tx_rx_4byte_vseq2 txrx_h2;

        extern function new (string name = "char_6bit_test",uvm_component parent);
        extern function void build_phase (uvm_phase phase);
        extern task run_phase (uvm_phase phase);
    endclass:char_6bit_test

    function char_6bit_test::new(string name = "char_6bit_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void char_6bit_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task char_6bit_test::run_phase(uvm_phase phase);
        phase.raise_objection(this);

        dl_vseqh = config_dl_vseq::type_id::create("dl_vseqh");
        char_6bit = char_6bit_vseq::type_id::create("char_6bit");
        fcr_4byteh = config_fcr_4byte_vseq::type_id::create("fcr_4byteh");
        ier_thr_uart1 = uart1_thr_enb_vseq::type_id::create("ier_thr_uart1");    //THR empty enable 
        ier_rec_uart2 = uart2_reciever_data_enb_vseq::type_id::create("ier_rec_uart2");    //reciever data available enable
        //parity_enb = parity_enb_vseq::type_id::create("parity_enb");    //parity enable to check for parity error
        txrx_h1 = tx_rx_4byte_vseq1::type_id::create("txrx_h1");
        txrx_h2 = tx_rx_4byte_vseq2::type_id::create("txrx_h2");
        
        dl_vseqh.start(env.v_sequencer);
        char_6bit.start(env.v_sequencer);
        //parity_enb.start(env.v_sequencer);
        fcr_4byteh.start(env.v_sequencer);
        ier_thr_uart1.start(env.v_sequencer);
        ier_rec_uart2.start(env.v_sequencer);

        txrx_h1.start(env.v_sequencer);
        txrx_h2.start(env.v_sequencer);

        #1000;
        phase.drop_objection(this);
    endtask

//----------------------------------------test scenario 7(transmit 5bits in each character)------------------------------------------------------------//
class char_5bit_test extends base_test;
        
        `uvm_component_utils(char_5bit_test);

        config_dl_vseq dl_vseqh;
        config_fcr_4byte_vseq fcr_4byteh;
        uart1_thr_enb_vseq ier_thr_uart1;
        uart2_reciever_data_enb_vseq ier_rec_uart2;
        parity_enb_vseq parity_enb;
        char_5bit_vseq char_5bit;
        tx_rx_4byte_vseq1 txrx_h1;
        tx_rx_4byte_vseq2 txrx_h2;

        extern function new (string name = "char_5bit_test",uvm_component parent);
        extern function void build_phase (uvm_phase phase);
        extern task run_phase (uvm_phase phase);
    endclass:char_5bit_test

    function char_5bit_test::new(string name = "char_5bit_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void char_5bit_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task char_5bit_test::run_phase(uvm_phase phase);
        phase.raise_objection(this);

        dl_vseqh = config_dl_vseq::type_id::create("dl_vseqh");
        char_5bit = char_5bit_vseq::type_id::create("char_5bit");
        fcr_4byteh = config_fcr_4byte_vseq::type_id::create("fcr_4byteh");
        ier_thr_uart1 = uart1_thr_enb_vseq::type_id::create("ier_thr_uart1");    //THR empty enable 
        ier_rec_uart2 = uart2_reciever_data_enb_vseq::type_id::create("ier_rec_uart2");    //reciever data available enable
        //parity_enb = parity_enb_vseq::type_id::create("parity_enb");    //parity enable to check for parity error
        txrx_h1 = tx_rx_4byte_vseq1::type_id::create("txrx_h1");
        txrx_h2 = tx_rx_4byte_vseq2::type_id::create("txrx_h2");
        
        dl_vseqh.start(env.v_sequencer);
        char_5bit.start(env.v_sequencer);
        //parity_enb.start(env.v_sequencer);
        fcr_4byteh.start(env.v_sequencer);
        ier_thr_uart1.start(env.v_sequencer);
        ier_rec_uart2.start(env.v_sequencer);

        txrx_h1.start(env.v_sequencer);
        txrx_h2.start(env.v_sequencer);

        #1000;
        phase.drop_objection(this);
    endtask

//----------------------------------------test scenario 8(check for timeout condition UART1)------------------------------------------------------------//
class timeout_uart1_test extends base_test;
        
        `uvm_component_utils(timeout_uart1_test);

        config_dl_vseq dl_vseqh;
        config_fcr_8byte_vseq fcr_8byteh;
        uart2_thr_enb_vseq ier_thr_uart2;
        uart1_reciever_data_enb_vseq ier_rec_uart1;
        parity_enb_vseq parity_enb;
        char_5bit_vseq char_5bit;
        tx_rx_4byte_vseq1 txrx_h1;
        tx_rx_8byte_vseq2 txrx_h2;

        extern function new (string name = "timeout_uart1_test",uvm_component parent);
        extern function void build_phase (uvm_phase phase);
        extern task run_phase (uvm_phase phase);
    endclass:timeout_uart1_test

    function timeout_uart1_test::new(string name = "timeout_uart1_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void timeout_uart1_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task timeout_uart1_test::run_phase(uvm_phase phase);
        phase.raise_objection(this);

        dl_vseqh = config_dl_vseq::type_id::create("dl_vseqh");
        fcr_8byteh = config_fcr_8byte_vseq::type_id::create("fcr_8byteh");
        ier_thr_uart2 = uart2_thr_enb_vseq::type_id::create("ier_thr_uart2");    //THR empty enable 
        ier_rec_uart1 = uart1_reciever_data_enb_vseq::type_id::create("ier_rec_uart1");    //reciever data available enable
        txrx_h1 = tx_rx_4byte_vseq1::type_id::create("txrx_h1");
        txrx_h2 = tx_rx_8byte_vseq2::type_id::create("txrx_h2");
        
        dl_vseqh.start(env.v_sequencer);
        fcr_8byteh.start(env.v_sequencer);
        ier_thr_uart2.start(env.v_sequencer);
        ier_rec_uart1.start(env.v_sequencer);

        txrx_h2.start(env.v_sequencer);
    repeat(2)    txrx_h1.start(env.v_sequencer);

        #1000;
        phase.drop_objection(this);
    endtask

//----------------------------------------test scenario 9(check for timeout condition UART2)------------------------------------------------------------//
class timeout_uart2_test extends base_test;
        
        `uvm_component_utils(timeout_uart2_test);

        config_dl_vseq dl_vseqh;
        config_fcr_14byte_vseq fcr_14byteh;
        uart1_thr_enb_vseq ier_thr_uart1;
        uart2_reciever_data_enb_vseq ier_rec_uart2;
        parity_enb_vseq parity_enb;
        char_5bit_vseq char_5bit;
        tx_rx_14byte_vseq1 txrx_h1;
        tx_rx_8byte_vseq2 txrx_h2;

        extern function new (string name = "timeout_uart2_test",uvm_component parent);
        extern function void build_phase (uvm_phase phase);
        extern task run_phase (uvm_phase phase);
    endclass:timeout_uart2_test

    function timeout_uart2_test::new(string name = "timeout_uart2_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void timeout_uart2_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task timeout_uart2_test::run_phase(uvm_phase phase);
        phase.raise_objection(this);

        dl_vseqh = config_dl_vseq::type_id::create("dl_vseqh");
        fcr_14byteh = config_fcr_14byte_vseq::type_id::create("fcr_14byteh");
        ier_thr_uart1 = uart1_thr_enb_vseq::type_id::create("ier_thr_uart1");    //THR empty enable 
        ier_rec_uart2 = uart2_reciever_data_enb_vseq::type_id::create("ier_rec_uart2");    //reciever data available enable
        txrx_h1 = tx_rx_14byte_vseq1::type_id::create("txrx_h1");
        txrx_h2 = tx_rx_8byte_vseq2::type_id::create("txrx_h2");
        
        dl_vseqh.start(env.v_sequencer);
        fcr_14byteh.start(env.v_sequencer);
        ier_thr_uart1.start(env.v_sequencer);
        ier_rec_uart2.start(env.v_sequencer);

        txrx_h1.start(env.v_sequencer);
    repeat(2)    txrx_h2.start(env.v_sequencer);

        #1000;
        phase.drop_objection(this);
    endtask

//----------------------------------------test scenario 10(framing error detection UART1)------------------------------------------------------------//
class framing_error_uart1_test extends base_test;
        
        `uvm_component_utils(framing_error_uart1_test);

        config_dl_vseq dl_vseqh;
        config_fcr_1byte_vseq fcr_1byteh;
        uart2_thr_enb_vseq ier_thr_uart2;
        uart1_reciever_data_enb_vseq ier_rec_uart1;
        parity_enb_vseq parity_enb;
        framing_error_vseq framing;
        tx_rx_1byte_vseq1 txrx_h1;
        tx_rx_1byte_vseq2 txrx_h2;

        extern function new (string name = "framing_error_uart1_test",uvm_component parent);
        extern function void build_phase (uvm_phase phase);
        extern task run_phase (uvm_phase phase);
    endclass:framing_error_uart1_test

    function framing_error_uart1_test::new(string name = "framing_error_uart1_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void framing_error_uart1_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task framing_error_uart1_test::run_phase(uvm_phase phase);
        phase.raise_objection(this);

        dl_vseqh = config_dl_vseq::type_id::create("dl_vseqh");
        fcr_1byteh = config_fcr_1byte_vseq::type_id::create("fcr_1byteh");
        ier_thr_uart2 = uart2_thr_enb_vseq::type_id::create("ier_thr_uart2");    //THR empty enable 
        ier_rec_uart1 = uart1_reciever_data_enb_vseq::type_id::create("ier_rec_uart1");    //reciever data available enable
        framing = framing_error_vseq::type_id::create("framing");
        txrx_h1 = tx_rx_1byte_vseq1::type_id::create("txrx_h1");
        txrx_h2 = tx_rx_1byte_vseq2::type_id::create("txrx_h2");
        
        dl_vseqh.start(env.v_sequencer);
        framing.start(env.v_sequencer);
        fcr_1byteh.start(env.v_sequencer);
        ier_thr_uart2.start(env.v_sequencer);
        ier_rec_uart1.start(env.v_sequencer);
        
        txrx_h2.start(env.v_sequencer);
        txrx_h1.start(env.v_sequencer);

        #1000;
        phase.drop_objection(this);
    endtask
//----------------------------------------test scenario 11(framing error detection UART2)------------------------------------------------------------//
class framing_error_uart2_test extends base_test;
        
        `uvm_component_utils(framing_error_uart2_test);

        config_dl_vseq dl_vseqh;
        config_fcr_1byte_vseq fcr_1byteh;
        uart1_thr_enb_vseq ier_thr_uart1;
        uart2_reciever_data_enb_vseq ier_rec_uart2;
        parity_enb_vseq parity_enb;
        framing_error_vseq framing;
        tx_rx_1byte_vseq1 txrx_h1;
        tx_rx_1byte_vseq2 txrx_h2;

        extern function new (string name = "framing_error_uart2_test",uvm_component parent);
        extern function void build_phase (uvm_phase phase);
        extern task run_phase (uvm_phase phase);
    endclass:framing_error_uart2_test

    function framing_error_uart2_test::new(string name = "framing_error_uart2_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void framing_error_uart2_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task framing_error_uart2_test::run_phase(uvm_phase phase);
        phase.raise_objection(this);

        dl_vseqh = config_dl_vseq::type_id::create("dl_vseqh");
        fcr_1byteh = config_fcr_1byte_vseq::type_id::create("fcr_1byteh");
        ier_thr_uart1 = uart1_thr_enb_vseq::type_id::create("ier_thr_uart1");    //THR empty enable 
        ier_rec_uart2 = uart2_reciever_data_enb_vseq::type_id::create("ier_rec_uart2");    //reciever data available enable
        framing = framing_error_vseq::type_id::create("framing");
        txrx_h1 = tx_rx_1byte_vseq1::type_id::create("txrx_h1");
        txrx_h2 = tx_rx_1byte_vseq2::type_id::create("txrx_h2");
        
        dl_vseqh.start(env.v_sequencer);
        framing.start(env.v_sequencer);
        fcr_1byteh.start(env.v_sequencer);
        ier_thr_uart1.start(env.v_sequencer);
        ier_rec_uart2.start(env.v_sequencer);
        
        txrx_h1.start(env.v_sequencer);
        txrx_h2.start(env.v_sequencer);

        #1000;
        phase.drop_objection(this);
    endtask

//----------------------------------------test scenario 12(overrun detection UART1)------------------------------------------------------------//
class overrun_uart1_test extends base_test;
        
        `uvm_component_utils(overrun_uart1_test);

        config_dl_vseq dl_vseqh;
        config_fcr_1byte_vseq fcr_1byteh;
        uart2_thr_enb_vseq ier_thr_uart2;
        uart1_reciever_data_enb_vseq ier_rec_uart1;
        parity_enb_vseq parity_enb;
        tx_rx_8byte_vseq1 txrx_h1;
        tx_rx_8byte_vseq2 txrx_h2;

        extern function new (string name = "overrun_uart1_test",uvm_component parent);
        extern function void build_phase (uvm_phase phase);
        extern task run_phase (uvm_phase phase);
    endclass:overrun_uart1_test

    function overrun_uart1_test::new(string name = "overrun_uart1_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void overrun_uart1_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task overrun_uart1_test::run_phase(uvm_phase phase);
        phase.raise_objection(this);

        dl_vseqh = config_dl_vseq::type_id::create("dl_vseqh");
        fcr_1byteh = config_fcr_1byte_vseq::type_id::create("fcr_1byteh");
        ier_thr_uart2 = uart2_thr_enb_vseq::type_id::create("ier_thr_uart2");    //THR empty enable 
        ier_rec_uart1 = uart1_reciever_data_enb_vseq::type_id::create("ier_rec_uart1");    //reciever data available enable
        txrx_h1 = tx_rx_8byte_vseq1::type_id::create("txrx_h1");
        txrx_h2 = tx_rx_8byte_vseq2::type_id::create("txrx_h2");
        
        dl_vseqh.start(env.v_sequencer);
        fcr_1byteh.start(env.v_sequencer);
        ier_thr_uart2.start(env.v_sequencer);
        ier_rec_uart1.start(env.v_sequencer);
        
         repeat(3) txrx_h2.start(env.v_sequencer);
        txrx_h1.start(env.v_sequencer);

        #1000;
        phase.drop_objection(this);
    endtask

