class uart_vseq_base extends uvm_sequence #(uvm_sequence_item);

    `uvm_object_utils(uart_vseq_base)

//sequencer handle
    uart_sequencer seqrh[];

//handle of virtual sequencer
    uart_virtual_sequencer v_sqrh;

//handles for uart sequences
    dl1_write_seq config_dl1;                                
    dl2_write_seq config_dl2;

    config_fcr_4byte_seq fcr_4byte[];
    config_fcr_8byte_seq fcr_8byte[];
    config_fcr_14byte_seq fcr_14byte[];
    config_fcr_1byte_seq fcr_1byte[];

    config_ier_thr_seq ier_thr;
    ier_reciever_data_enb ier_rec_enb;
    odd_parity_enb_seq odd_parity;
    even_parity_enb_seq    even_parity;
    char_7bit_seq char_7bit[];
    char_6bit_seq char_6bit[];
    char_5bit_seq char_5bit[];

//interrupt sequence to read from the IIR & LSR
    interrupt_seq iir_h[];
    lsr_read_seq lsr_read[];

    data_trans_seq tx_h[];
    data_rec_seq rx_h[];

//declare handle of environment config
    uart_env_config env_cfg;

    extern function new(string name = "uart_vseq_base");
    extern task body();

endclass: uart_vseq_base
    

//constructor 
    function uart_vseq_base::new(string name = "uart_vseq_base");
        super.new(name);
    endfunction

    task uart_vseq_base::body();

        if(!uvm_config_db #(uart_env_config)::get(null,get_full_name(),"uart_env_config", env_cfg))
            `uvm_fatal(get_full_name(), "unable to get configuration")

            seqrh = new[env_cfg.no_of_agt];

            fcr_1byte = new[env_cfg.no_of_agt];
            fcr_4byte = new[env_cfg.no_of_agt];
            fcr_8byte = new[env_cfg.no_of_agt];
            fcr_14byte = new[env_cfg.no_of_agt];

            iir_h = new[env_cfg.no_of_agt];
            lsr_read = new[env_cfg.no_of_agt];
            tx_h = new[env_cfg.no_of_agt];
            rx_h = new[env_cfg.no_of_agt];
            char_7bit = new[env_cfg.no_of_agt];
            char_6bit = new[env_cfg.no_of_agt];
            char_5bit = new[env_cfg.no_of_agt];

        assert($cast(v_sqrh, m_sequencer))
        else begin
                    `uvm_error(get_full_name(),"error in $cast of virtual sequencer")
                 end

        foreach(seqrh[i])
            seqrh[i] = v_sqrh.sqrh[i];

    endtask:body


//-----------------------------------------------config uart to write into divisor latch----------------------------------------------------//
    class config_dl_vseq extends uart_vseq_base;
        
        `uvm_object_utils(config_dl_vseq)

        extern function new(string name = "config_dl_vseq");
        extern task body();

    endclass:config_dl_vseq

    function config_dl_vseq::new(string name = "config_dl_vseq");
        super.new(name);
    endfunction

    task config_dl_vseq::body();
        super.body();                                                                                                                

            config_dl1 = dl1_write_seq::type_id::create("config_dl1");
            config_dl2 = dl2_write_seq::type_id::create("config_dl2");
    
                    fork
                        begin:UART1
                        config_dl1.start(seqrh[0]);                //to write into divisor latch
                        end
                        begin:UART2
                        config_dl2.start(seqrh[1]);                //to write into divisor latch
                        end
                    join

                    
    endtask

//-----------------------------------------------config uart to send 7 bit per char----------------------------------------------------//
    class char_7bit_vseq extends uart_vseq_base;
        
        `uvm_object_utils(char_7bit_vseq)

        extern function new(string name = "char_7bit_vseq");
        extern task body();

    endclass:char_7bit_vseq

    function char_7bit_vseq::new(string name = "char_7bit_vseq");
        super.new(name);
    endfunction

    task char_7bit_vseq::body();
        super.body();                                                                                                                

            foreach(char_7bit[i])
                char_7bit[i] = char_7bit_seq::type_id::create($sformatf("char_7bit[%0d]",i));

                    fork
                        begin:UART1
                        char_7bit[0].start(seqrh[0]);                //write LCR to send 7bit per char
                        end
                        begin:UART2
                        char_7bit[1].start(seqrh[1]);                //write LCR to send 7bit per char
                        end
                    join

                    
    endtask

//-----------------------------------------------config uart to send 6 bit per char----------------------------------------------------//
    class char_6bit_vseq extends uart_vseq_base;
        
        `uvm_object_utils(char_6bit_vseq)

        extern function new(string name = "char_6bit_vseq");
        extern task body();

    endclass:char_6bit_vseq

    function char_6bit_vseq::new(string name = "char_6bit_vseq");
        super.new(name);
    endfunction

    task char_6bit_vseq::body();
        super.body();                                                                                                                

            foreach(char_6bit[i])
                char_6bit[i] = char_6bit_seq::type_id::create($sformatf("char_6bit[%0d]",i));

                    fork
                        begin:UART1
                        char_6bit[0].start(seqrh[0]);                //write LCR to send 6bit per char
                        end
                        begin:UART2
                        char_6bit[1].start(seqrh[1]);                //write LCR to send 6bit per char
                        end
                    join

                    
    endtask

//-----------------------------------------------config uart to send 6 bit per char----------------------------------------------------//
    class char_5bit_vseq extends uart_vseq_base;
        
        `uvm_object_utils(char_5bit_vseq)

        extern function new(string name = "char_5bit_vseq");
        extern task body();

    endclass:char_5bit_vseq

    function char_5bit_vseq::new(string name = "char_5bit_vseq");
        super.new(name);
    endfunction

    task char_5bit_vseq::body();
        super.body();                                                                                                                

            foreach(char_5bit[i])
                char_5bit[i] = char_5bit_seq::type_id::create($sformatf("char_5bit[%0d]",i));

                    fork
                        begin:UART1
                        char_5bit[0].start(seqrh[0]);                //write LCR to send 5bit per char
                        end
                        begin:UART2
                        char_5bit[1].start(seqrh[1]);                //write LCR to send 5bit per char
                        end
                    join

                    
    endtask
//-----------------------------------------------config uart to send different bit per char----------------------------------------------------//
    class framing_error_vseq extends uart_vseq_base;
        
        `uvm_object_utils(framing_error_vseq)

        extern function new(string name = "framing_error_vseq");
        extern task body();

    endclass:framing_error_vseq

    function framing_error_vseq::new(string name = "framing_error_vseq");
        super.new(name);
    endfunction

    task framing_error_vseq::body();
        super.body();                                                                                                                

                char_5bit[0] = char_5bit_seq::type_id::create("char_5bit[0]");
                char_6bit[0] = char_6bit_seq::type_id::create("char_6bit[0]");

                    fork
                        begin:UART1
                        char_5bit[0].start(seqrh[0]);                //write LCR to send/rec 5bit per char
                        end
                        begin:UART2
                        char_6bit[0].start(seqrh[1]);                //write LCR to send/rec 6bit per char
                        end
                    join

                    
    endtask

//-----------------------------------------------config uart to write FCR for trigger level 1bytes----------------------------------------------------//
    class config_fcr_1byte_vseq extends uart_vseq_base;
        
        `uvm_object_utils(config_fcr_1byte_vseq)

        extern function new(string name = "config_fcr_1byte_vseq");
        extern task body();

    endclass:config_fcr_1byte_vseq

    function config_fcr_1byte_vseq::new(string name = "config_fcr_1byte_vseq");
        super.new(name);
    endfunction

    task config_fcr_1byte_vseq::body();
        super.body();                

                foreach(fcr_1byte[i])
            fcr_1byte[i] = config_fcr_1byte_seq::type_id::create($sformatf("fcr_1byte[%0d]",i));
    
                    fork
                        begin:UART1
                        fcr_1byte[0].start(seqrh[0]);                //to write into fcr
                        end
                        begin:UART2
                        fcr_1byte[1].start(seqrh[1]);                //to write into fcr
                        end
                    join

                    
    endtask


//-----------------------------------------------config uart to write FCR for trigger level 4bytes----------------------------------------------------//
    class config_fcr_4byte_vseq extends uart_vseq_base;
        
        `uvm_object_utils(config_fcr_4byte_vseq)

        extern function new(string name = "config_fcr_4byte_vseq");
        extern task body();

    endclass:config_fcr_4byte_vseq

    function config_fcr_4byte_vseq::new(string name = "config_fcr_4byte_vseq");
        super.new(name);
    endfunction

    task config_fcr_4byte_vseq::body();
        super.body();                

                foreach(fcr_4byte[i])
            fcr_4byte[i] = config_fcr_4byte_seq::type_id::create($sformatf("fcr_4byte[%0d]",i));
    
                    fork
                        begin:UART1
                        fcr_4byte[0].start(seqrh[0]);                //to write into fcr
                        end
                        begin:UART2
                        fcr_4byte[1].start(seqrh[1]);                //to write into fcr
                        end
                    join

                    
    endtask

//-----------------------------------------------config uart to write FCR for trigger level 8bytes----------------------------------------------------//
    class config_fcr_8byte_vseq extends uart_vseq_base;
        
        `uvm_object_utils(config_fcr_8byte_vseq)

        extern function new(string name = "config_fcr_8byte_vseq");
        extern task body();

    endclass:config_fcr_8byte_vseq

    function config_fcr_8byte_vseq::new(string name = "config_fcr_8byte_vseq");
        super.new(name);
    endfunction

    task config_fcr_8byte_vseq::body();
        super.body();                

                foreach(fcr_8byte[i])
            fcr_8byte[i] = config_fcr_8byte_seq::type_id::create($sformatf("fcr_8byte[%0d]",i));
    
                    fork
                        begin:UART1
                        fcr_8byte[0].start(seqrh[0]);                //to write into fcr
                        end
                        begin:UART2
                        fcr_8byte[1].start(seqrh[1]);                //to write into fcr
                        end
                    join

                    
    endtask

//-----------------------------------------------config uart to write FCR for trigger level 14bytes----------------------------------------------------//
    class config_fcr_14byte_vseq extends uart_vseq_base;
        
        `uvm_object_utils(config_fcr_14byte_vseq)

        extern function new(string name = "config_fcr_14byte_vseq");
        extern task body();

    endclass:config_fcr_14byte_vseq

    function config_fcr_14byte_vseq::new(string name = "config_fcr_14byte_vseq");
        super.new(name);
    endfunction

    task config_fcr_14byte_vseq::body();
        super.body();                

                foreach(fcr_14byte[i])
            fcr_14byte[i] = config_fcr_14byte_seq::type_id::create($sformatf("fcr_14byte[%0d]",i));
    
                    fork
                        begin:UART1
                        fcr_14byte[0].start(seqrh[0]);                //to write into fcr
                        end
                        begin:UART2
                        fcr_14byte[1].start(seqrh[1]);                //to write into fcr
                        end
                    join

                    
    endtask

//-----------------------------------------------config uart1 to write IER----------------------------------------------------//
    class uart1_thr_enb_vseq extends uart_vseq_base;
        
        `uvm_object_utils(uart1_thr_enb_vseq)

        extern function new(string name = "uart1_thr_enb_vseq");
        extern task body();

    endclass:uart1_thr_enb_vseq

    function uart1_thr_enb_vseq::new(string name = "uart1_thr_enb_vseq");
        super.new(name);
    endfunction

    task uart1_thr_enb_vseq::body();
        super.body();                

            ier_thr = config_ier_thr_seq::type_id::create("ier_thr");
    
                        ier_thr.start(seqrh[0]);                //to write into ier of uart1

                    
    endtask

    //-----------------------------------------------config uart1 to write IER----------------------------------------------------//
    class uart2_thr_enb_vseq extends uart_vseq_base;
        
        `uvm_object_utils(uart2_thr_enb_vseq)

        extern function new(string name = "uart2_thr_enb_vseq");
        extern task body();

    endclass:uart2_thr_enb_vseq

    function uart2_thr_enb_vseq::new(string name = "uart2_thr_enb_vseq");
        super.new(name);
    endfunction

    task uart2_thr_enb_vseq::body();
        super.body();                

            ier_thr = config_ier_thr_seq::type_id::create("ier_thr");
    
                        ier_thr.start(seqrh[1]);                //to write into ier of uart1

                    
    endtask


//-----------------------------------------------config uart1 to write IER----------------------------------------------------//
    class uart1_reciever_data_enb_vseq extends uart_vseq_base;
        
        `uvm_object_utils(uart1_reciever_data_enb_vseq)

        extern function new(string name = "uart1_reciever_data_enb_vseq");
        extern task body();

    endclass:uart1_reciever_data_enb_vseq

    function uart1_reciever_data_enb_vseq::new(string name = "uart1_reciever_data_enb_vseq");
        super.new(name);
    endfunction

    task uart1_reciever_data_enb_vseq::body();
        super.body();                

            ier_rec_enb = ier_reciever_data_enb::type_id::create("ier_thr");
    
                        ier_rec_enb.start(seqrh[0]);                //to write into ier of uart2

                    
    endtask

//-----------------------------------------------config uart2 to write IER----------------------------------------------------//
    class uart2_reciever_data_enb_vseq extends uart_vseq_base;
        
        `uvm_object_utils(uart2_reciever_data_enb_vseq)

        extern function new(string name = "uart2_reciever_data_enb_vseq");
        extern task body();

    endclass:uart2_reciever_data_enb_vseq

    function uart2_reciever_data_enb_vseq::new(string name = "uart2_reciever_data_enb_vseq");
        super.new(name);
    endfunction

    task uart2_reciever_data_enb_vseq::body();
        super.body();                

            ier_rec_enb = ier_reciever_data_enb::type_id::create("ier_thr");
    
                        ier_rec_enb.start(seqrh[1]);                //to write into ier of uart2

                    
    endtask

//-----------------------------------------------parity enable sequence----------------------------------------------------//
    class parity_enb_vseq extends uart_vseq_base;
        
        `uvm_object_utils(parity_enb_vseq)

        extern function new(string name = "parity_enb_vseq");
        extern task body();

    endclass:parity_enb_vseq

    function parity_enb_vseq::new(string name = "parity_enb_vseq");
        super.new(name);
    endfunction

    task parity_enb_vseq::body();
        super.body();                

            odd_parity = odd_parity_enb_seq::type_id::create("odd_parity");
            even_parity = even_parity_enb_seq::type_id::create("even_parity");
                        fork
                        odd_parity.start(seqrh[0]);                //parity enable with odd parity
                        even_parity.start(seqrh[1]);                //parity enable with even parity
                        join
                    
    endtask



//-----------------------------------------------transmission and receiving 1byte sesquence for UART1----------------------------------------------------//

    class tx_rx_1byte_vseq1 extends uart_vseq_base;
        
        `uvm_object_utils(tx_rx_1byte_vseq1)

        extern function new(string name = "tx_rx_1byte_vseq1");
        extern task body();

    endclass:tx_rx_1byte_vseq1

    function tx_rx_1byte_vseq1::new(string name = "tx_rx_1byte_vseq1");
        super.new(name);
    endfunction

    task tx_rx_1byte_vseq1::body();
        super.body();                                                                                                                
                iir_h[0] = interrupt_seq::type_id::create("iir_h[0]");
                tx_h[0] = data_trans_seq::type_id::create("tx_h[0]");
                rx_h[0] = data_rec_seq::type_id::create("rx_h[0]");
                lsr_read[0] = lsr_read_seq::type_id::create("lsr_read[0]");

                        begin:UART1
                        iir_h[0].start(seqrh[0]);
                            if(iir_h[0].req.iir == 8'hC4)
                                rx_h[0].start(seqrh[0]);
                            else if(iir_h[0].req.iir == 8'hC2)
                                begin
                                $display($time,"transmission started");
                                tx_h[0].start(seqrh[0]);
                                end
                            else if(iir_h[0].req.iir == 8'hC6)
                                begin
                                lsr_read[0].start(seqrh[0]);
                                end

                        end
    endtask

//-----------------------------------------------transmission and receiving 4byte sesquence for UART1----------------------------------------------------//

    class tx_rx_4byte_vseq1 extends uart_vseq_base;
        
        `uvm_object_utils(tx_rx_4byte_vseq1)

        extern function new(string name = "tx_rx_4byte_vseq1");
        extern task body();

    endclass:tx_rx_4byte_vseq1

    function tx_rx_4byte_vseq1::new(string name = "tx_rx_4byte_vseq1");
        super.new(name);
    endfunction

    task tx_rx_4byte_vseq1::body();
        super.body();                                                                                                                
                iir_h[0] = interrupt_seq::type_id::create("iir_h[0]");
                tx_h[0] = data_trans_seq::type_id::create("tx_h[0]");
                rx_h[0] = data_rec_seq::type_id::create("rx_h[0]");
                lsr_read[0] = lsr_read_seq::type_id::create("lsr_read[0]");

                        begin:UART1
                        iir_h[0].start(seqrh[0]);
                            if(iir_h[0].req.iir == 8'hC4)
                            repeat(4)    rx_h[0].start(seqrh[0]);
                            else if(iir_h[0].req.iir == 8'hC2)
                                begin
                            repeat(4)    tx_h[0].start(seqrh[0]);
                                end
                            else if(iir_h[0].req.iir == 8'hC6)
                                begin
                                lsr_read[0].start(seqrh[0]);
                                end

                        end
    endtask
//-----------------------------------------------transmission and receiving 8byte sesquence for UART1----------------------------------------------------//

    class tx_rx_8byte_vseq1 extends uart_vseq_base;
        
        `uvm_object_utils(tx_rx_8byte_vseq1)

        extern function new(string name = "tx_rx_8byte_vseq1");
        extern task body();

    endclass:tx_rx_8byte_vseq1

    function tx_rx_8byte_vseq1::new(string name = "tx_rx_8byte_vseq1");
        super.new(name);
    endfunction

    task tx_rx_8byte_vseq1::body();
        super.body();                                                                                                                
                iir_h[0] = interrupt_seq::type_id::create("iir_h[0]");
                tx_h[0] = data_trans_seq::type_id::create("tx_h[0]");
                rx_h[0] = data_rec_seq::type_id::create("rx_h[0]");
                lsr_read[0] = lsr_read_seq::type_id::create("lsr_read[0]");

                        begin:UART1
                        iir_h[0].start(seqrh[0]);
                            if(iir_h[0].req.iir == 8'hC4)
                            repeat(8)    rx_h[0].start(seqrh[0]);
                            else if(iir_h[0].req.iir == 8'hC2)
                                begin
                            repeat(8)    tx_h[0].start(seqrh[0]);
                                end
                            else if(iir_h[0].req.iir == 8'hC6)
                                begin
                                lsr_read[0].start(seqrh[0]);
                                end

                        end
    endtask

//-----------------------------------------------transmission and receiving 14byte sesquence for UART1----------------------------------------------------//

    class tx_rx_14byte_vseq1 extends uart_vseq_base;
        
        `uvm_object_utils(tx_rx_14byte_vseq1)

        extern function new(string name = "tx_rx_14byte_vseq1");
        extern task body();

    endclass:tx_rx_14byte_vseq1

    function tx_rx_14byte_vseq1::new(string name = "tx_rx_14byte_vseq1");
        super.new(name);
    endfunction

    task tx_rx_14byte_vseq1::body();
        super.body();                                                                                                                
                iir_h[0] = interrupt_seq::type_id::create("iir_h[0]");
                tx_h[0] = data_trans_seq::type_id::create("tx_h[0]");
                rx_h[0] = data_rec_seq::type_id::create("rx_h[0]");
                lsr_read[0] = lsr_read_seq::type_id::create("lsr_read[0]");

                        begin:UART1
                        iir_h[0].start(seqrh[0]);
                            if(iir_h[0].req.iir == 8'hC4)
                            repeat(14)    rx_h[0].start(seqrh[0]);
                            else if(iir_h[0].req.iir == 8'hC2)
                                begin
                            repeat(14)    tx_h[0].start(seqrh[0]);
                                end
                            else if(iir_h[0].req.iir == 8'hC6)
                                begin
                                lsr_read[0].start(seqrh[0]);
                                end

                        end
    endtask



//-----------------------------------------------transmission and receiving 1byte sesquence for UART2----------------------------------------------------//

    class tx_rx_1byte_vseq2 extends uart_vseq_base;
        
        `uvm_object_utils(tx_rx_1byte_vseq2)

        extern function new(string name = "tx_rx_1byte_vseq2");
        extern task body();

    endclass:tx_rx_1byte_vseq2

    function tx_rx_1byte_vseq2::new(string name = "tx_rx_1byte_vseq2");
        super.new(name);
    endfunction

    task tx_rx_1byte_vseq2::body();
        super.body();                                                                                                                
                iir_h[1] = interrupt_seq::type_id::create("iir_h[1]");
                tx_h[1] = data_trans_seq::type_id::create("tx_h[1]");
                rx_h[1] = data_rec_seq::type_id::create("rx_h[1]");
                lsr_read[1] = lsr_read_seq::type_id::create("lsr_read[1]");

                        begin:UART2
                        iir_h[1].start(seqrh[1]);    $display($time,"interrupt value %0h",iir_h[1].req.iir); 
                            if(iir_h[1].req.iir == 8'hC4)
                                begin
                                rx_h[1].start(seqrh[1]);
                                end
                            else if(iir_h[1].req.iir == 8'hC2)
                                begin  
                                tx_h[1].start(seqrh[1]);
                                end
                            else if(iir_h[1].req.iir == 8'hC6)
                                begin
                                lsr_read[1].start(seqrh[1]);
                                end

                        end
                                
    endtask
//-----------------------------------------------transmission and receiving 4byte sesquence for UART2----------------------------------------------------//

    class tx_rx_4byte_vseq2 extends uart_vseq_base;
        
        `uvm_object_utils(tx_rx_4byte_vseq2)

        extern function new(string name = "tx_rx_4byte_vseq2");
        extern task body();

    endclass:tx_rx_4byte_vseq2

    function tx_rx_4byte_vseq2::new(string name = "tx_rx_4byte_vseq2");
        super.new(name);
    endfunction

    task tx_rx_4byte_vseq2::body();
        super.body();                                                                                                                
                iir_h[1] = interrupt_seq::type_id::create("iir_h[1]");
                tx_h[1] = data_trans_seq::type_id::create("tx_h[1]");
                rx_h[1] = data_rec_seq::type_id::create("rx_h[1]");
                lsr_read[1] = lsr_read_seq::type_id::create("lsr_read[1]");

                        begin:UART2
                        iir_h[1].start(seqrh[1]);
                            if(iir_h[1].req.iir == 8'hC4)
                                begin
                                repeat(4) rx_h[1].start(seqrh[1]);
                                end
                            else if(iir_h[1].req.iir == 8'hC2)
                                begin  
                                repeat(4) tx_h[1].start(seqrh[1]);
                                end
                            else if(iir_h[1].req.iir == 8'hC6)
                                begin
                                lsr_read[1].start(seqrh[1]);
                                end

                        end
                                
    endtask
//-----------------------------------------------transmission and receiving 8byte sesquence for UART2----------------------------------------------------//

    class tx_rx_8byte_vseq2 extends uart_vseq_base;
        
        `uvm_object_utils(tx_rx_8byte_vseq2)

        extern function new(string name = "tx_rx_8byte_vseq2");
        extern task body();

    endclass:tx_rx_8byte_vseq2

    function tx_rx_8byte_vseq2::new(string name = "tx_rx_8byte_vseq2");
        super.new(name);
    endfunction

    task tx_rx_8byte_vseq2::body();
        super.body();                                                                                                                
                iir_h[1] = interrupt_seq::type_id::create("iir_h[1]");
                tx_h[1] = data_trans_seq::type_id::create("tx_h[1]");
                rx_h[1] = data_rec_seq::type_id::create("rx_h[1]");
                lsr_read[1] = lsr_read_seq::type_id::create("lsr_read[1]");

                        begin:UART2
                        iir_h[1].start(seqrh[1]);    $display($time,"interrupt value %0h",iir_h[1].req.iir); 
                            if(iir_h[1].req.iir == 8'hC4)
                                begin
                                repeat(8) rx_h[1].start(seqrh[1]);
                                end
                            else if(iir_h[1].req.iir == 8'hC2)
                                begin  
                                repeat(8) tx_h[1].start(seqrh[1]);
                                end
                            else if(iir_h[1].req.iir == 8'hC6)
                                begin
                                lsr_read[1].start(seqrh[1]);
                                end

                        end
                                
    endtask
//-----------------------------------------------transmission and receiving 14bytes sesquence for UART2--------------------------------------------------//

    class tx_rx_14byte_vseq2 extends uart_vseq_base;
        
        `uvm_object_utils(tx_rx_14byte_vseq2)

        extern function new(string name = "tx_rx_14byte_vseq2");
        extern task body();

    endclass:tx_rx_14byte_vseq2

    function tx_rx_14byte_vseq2::new(string name = "tx_rx_14byte_vseq2");
        super.new(name);
    endfunction

    task tx_rx_14byte_vseq2::body();
        super.body();                                                                                                                
                iir_h[1] = interrupt_seq::type_id::create("iir_h[1]");
                tx_h[1] = data_trans_seq::type_id::create("tx_h[1]");
                rx_h[1] = data_rec_seq::type_id::create("rx_h[1]");
                lsr_read[1] = lsr_read_seq::type_id::create("lsr_read[1]");

                        begin:UART2
                        iir_h[1].start(seqrh[1]);    $display($time,"interrupt value %0h",iir_h[1].req.iir); 
                            if(iir_h[1].req.iir == 8'hC4)
                                begin
                                repeat(14) rx_h[1].start(seqrh[1]);
                                end
                            else if(iir_h[1].req.iir == 8'hC2)
                                begin  
                                repeat(14) tx_h[1].start(seqrh[1]);
                                end
                            else if(iir_h[1].req.iir == 8'hC6)
                                begin
                                lsr_read[1].start(seqrh[1]);
                                end

                        end
                                
    endtask

//-----------------------------------------------transmission and LCR checking sesquence for UART1----------------------------------------------------//

    class trans_vseq1 extends uart_vseq_base;
        
        `uvm_object_utils(trans_vseq1)

        extern function new(string name = "trans_vseq1");
        extern task body();

    endclass:trans_vseq1

    function trans_vseq1::new(string name = "trans_vseq1");
        super.new(name);
    endfunction

    task trans_vseq1::body();
        super.body();                                                                                                                
                iir_h[0] = interrupt_seq::type_id::create("iir_h[0]");
                tx_h[0] = data_trans_seq::type_id::create("tx_h[0]");
                lsr_read[0] = lsr_read_seq::type_id::create("lsr_read[0]");

                        begin:UART1
                        iir_h[0].start(seqrh[0]);
                            if(iir_h[0].req.iir == 8'hC4)
                                rx_h[0].start(seqrh[0]);
                            else if(iir_h[0].req.iir == 8'hC2)
                                begin
                                $display($time,"transmission started");
                                tx_h[0].start(seqrh[0]);
                                end
                            else if(iir_h[0].req.iir == 8'hC6)
                                begin
                                //$display($time,"Parity error found at reciever side");
                                lsr_read[0].start(seqrh[0]);
                                end

                        end
    endtask
