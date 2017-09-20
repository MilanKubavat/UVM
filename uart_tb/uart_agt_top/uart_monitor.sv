class uart_monitor extends uvm_monitor;
    
    `uvm_component_utils(uart_monitor)

//virtual interface handle
    virtual uart_if.MON vif;
    uvm_analysis_port #(uart_xtn) mon_ap;

//config object handle
    uart_agent_config agt_cfg;

    uart_xtn send_data;
    bit[15:0] trigger_level;
    bit[7:0] tx[$];
    bit[7:0] rx[$];
    logic [1:0] BitsPerChar;

    extern function new(string name="uart_monitor",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task    collect_data();
    extern task reset_t();
    extern task lcr_reg_t();
    extern task dl_reg_t();
    extern task iir_reg_t();
    extern task    read_write_t();
    extern task ier_reg_t();
    extern task fcr_reg_t();
    extern task lsr_reg_t();

endclass:uart_monitor

//constructor
    function uart_monitor::new(string name="uart_monitor",uvm_component parent);    
        super.new(name,parent);
         mon_ap = new("mon_ap", this);
    endfunction:new

//build_phase
    function void uart_monitor::build_phase(uvm_phase phase);
        super.build_phase(phase);
            if(!uvm_config_db #(uart_agent_config)::get(this, "", "uart_agent_config", agt_cfg))
            `uvm_fatal(get_type_name(), "unable to get configuration in monitor")
    endfunction:build_phase

//connect_phase
    function void uart_monitor::connect_phase (uvm_phase phase);
        vif = agt_cfg.vif;
    endfunction

//run_phase
    task uart_monitor::run_phase(uvm_phase phase);
        forever collect_data;
    endtask:run_phase

//collect_data from interface
    task uart_monitor::collect_data();
            send_data = uart_xtn::type_id::create("send_data");
        if(vif.wb_rst_i)
            reset_t();
        else
            begin
            @(vif.mon_cb)
            wait(vif.mon_cb.wb_ack_o);
                begin    
                if((vif.mon_cb.wb_adr_i == 'd3) && (vif.mon_cb.wb_dat_i != 'd128))                            //update LCR reg
                    lcr_reg_t();
                else if(vif.mon_cb.wb_adr_i == 'd3 && vif.mon_cb.wb_dat_i == 'd128)                        //update dl reg            
                    dl_reg_t();    
                else if(vif.mon_cb.wb_adr_i == 'd2 && vif.mon_cb.wb_we_i == 'b0)                                //uapdate IIR in transaction field 
                    iir_reg_t();
                else if(vif.mon_cb.wb_adr_i == 'd5 && vif.mon_cb.wb_we_i == 'b0)                                //update LSR reg 
                    lsr_reg_t();
                else if(vif.mon_cb.wb_adr_i == 'd2 && vif.mon_cb.wb_we_i == 'b1)                                //uapdate FCR in transaction field 
                    fcr_reg_t();
                else if(vif.mon_cb.wb_adr_i == 'd1)                                                                                        //to update IER
                    ier_reg_t();
                else if(vif.mon_cb.wb_adr_i == 'd0)                                                                                        //data read/write
                    read_write_t();
                end
            end
        mon_ap.write(send_data);
    endtask:collect_data
//---------------------------------------------------------------------------------------------------------------------------//    
    task uart_monitor::reset_t();
        send_data.reset_value = vif.wb_rst_i;
        @(vif.mon_cb);
        send_data.rx_reg = vif.mon_cb.wb_dat_o;
    endtask:reset_t
//---------------------------------------------------------------------------------------------------------------------------//
    task uart_monitor::lcr_reg_t();                                                                                                //update LCR in transaction field
                    @(vif.mon_cb);
                    send_data.control_reg = vif.mon_cb.wb_adr_i;
                    send_data.write = vif.mon_cb.wb_we_i;
                    if(vif.mon_cb.wb_we_i == 1'b1)
                    begin
                    send_data.tx_reg = vif.mon_cb.wb_dat_i;
                    send_data.lcr = vif.mon_cb.wb_dat_i;
        `uvm_info("monitor","written value in LCR reg",UVM_MEDIUM);
                    send_data.print();
                    BitsPerChar = send_data.lcr[1:0];
                    end
                    else if(vif.mon_cb.wb_we_i == 1'b0)
                    begin
                    send_data.rx_reg = vif.mon_cb.wb_dat_o;
                    send_data.lcr = vif.mon_cb.wb_dat_o;
        `uvm_info("monitor","reading from LCR reg",UVM_MEDIUM);
                    send_data.print();
                    end
    endtask:lcr_reg_t
//---------------------------------------------------------------------------------------------------------------------------//
    task uart_monitor::ier_reg_t();                                                                                                //update IER reg in transaction field
                    @(vif.mon_cb);
                    send_data.control_reg = vif.mon_cb.wb_adr_i;
                    send_data.write = vif.mon_cb.wb_we_i;
                    if(vif.mon_cb.wb_we_i == 'b1) begin
                    send_data.tx_reg = vif.mon_cb.wb_dat_i;
                    send_data.ier = vif.mon_cb.wb_dat_i;
        `uvm_info("monitor","written data into IER reg",UVM_MEDIUM);
                    send_data.print();
                    end
                    if(vif.mon_cb.wb_we_i == 'b0) begin
                    send_data.rx_reg = vif.mon_cb.wb_dat_o;
                    send_data.ier = vif.mon_cb.wb_dat_o;
        `uvm_info("monitor","reading from IER reg",UVM_MEDIUM);
                    send_data.print();
                    end
    endtask:ier_reg_t
//---------------------------------------------------------------------------------------------------------------------------//
    task uart_monitor::fcr_reg_t();                                                                                                //update FCR reg in transaction field
                    @(vif.mon_cb);
                    send_data.control_reg = vif.mon_cb.wb_adr_i;
                    send_data.tx_reg = vif.mon_cb.wb_dat_i;
                    send_data.fcr = vif.mon_cb.wb_dat_i;
                    send_data.write = vif.mon_cb.wb_we_i;
                    if(send_data.fcr[7:6] == 'b00)
                    trigger_level = 1;
                    if(send_data.fcr[7:6] == 'b01)
                    trigger_level = 4;
                    if(send_data.fcr[7:6] == 'b10)
                    trigger_level = 8;
                    if(send_data.fcr[7:6] == 'b11)
                    trigger_level = 14;
                    //send_data.tx = {};    //delete queue elements before starting
                    //send_data.rx = {};    //or re-initialize queue
                    //$display($time,"queue size %0d",send_data.tx.size);
        `uvm_info("monitor","written data into FCR reg",UVM_MEDIUM);
                    send_data.print();
    endtask:fcr_reg_t
//---------------------------------------------------------------------------------------------------------------------------//
    task uart_monitor::dl_reg_t();                                                                                                //update DL reg in transaction field
                begin
                    send_data.control_reg = vif.mon_cb.wb_adr_i;
                    @(vif.mon_cb);
                    wait(vif.mon_cb.wb_ack_o);
                    if(vif.mon_cb.wb_adr_i == 'd0)    
                        begin
                        send_data.tx_reg = vif.mon_cb.wb_dat_i;
                        send_data.dl[7:0] = vif.mon_cb.wb_dat_i;
                        @(vif.mon_cb);
                        wait(vif.mon_cb.wb_ack_o);
                        send_data.dl[15:8] = vif.mon_cb.wb_dat_i;
                        end
                    else if(vif.mon_cb.wb_adr_i == 'd1)    
                        begin
                        send_data.tx_reg = vif.mon_cb.wb_dat_i;
                        send_data.dl[15:8] = vif.mon_cb.wb_dat_i;
                        @(vif.mon_cb);
                        wait(vif.mon_cb.wb_ack_o);
                        send_data.dl[7:0] = vif.mon_cb.wb_dat_i;
                        end
        `uvm_info("monitor","written data in DL reg",UVM_MEDIUM);
                    send_data.print();
                end
    endtask:dl_reg_t
//---------------------------------------------------------------------------------------------------------------------------//
    task uart_monitor::iir_reg_t();                                                                                                //update iir in transaction field
        @(vif.mon_cb);
        if(vif.mon_cb.wb_we_i == 1'b0)
                begin
                    send_data.control_reg = vif.mon_cb.wb_adr_i;
                    send_data.iir = vif.mon_cb.wb_dat_o;
                    send_data.write = vif.mon_cb.wb_we_i; 
                end
        `uvm_info("monitor","reading from IIR reg",UVM_MEDIUM);
                send_data.print();
    endtask:iir_reg_t
//---------------------------------------------------------------------------------------------------------------------------//
    task uart_monitor::lsr_reg_t();                                                                                                //update lsr in transaction field
        if(vif.mon_cb.wb_we_i == 1'b0)
                begin
                    send_data.control_reg = vif.mon_cb.wb_adr_i;
                    send_data.lsr = vif.mon_cb.wb_dat_o;
                    send_data.write = vif.mon_cb.wb_we_i; 
                end
        `uvm_info("monitor","reading from LSR reg",UVM_MEDIUM);
                send_data.print();
    endtask:lsr_reg_t

//---------------------------------------------------------------------------------------------------------------------------//
    task uart_monitor::read_write_t();                                                                                        //tx_reg or rx_reg update
                send_data.control_reg = vif.mon_cb.wb_adr_i;
                @(vif.mon_cb);
                if(vif.mon_cb.wb_we_i == 1'b1)
                    begin
                        send_data.write = vif.mon_cb.wb_we_i;
                        send_data.tx_reg = vif.mon_cb.wb_dat_i;
                        case(BitsPerChar)
                            2'b00: tx.push_back(send_data.tx_reg[4:0]);
                            2'b01: tx.push_back(send_data.tx_reg[5:0]);
                            2'b10: tx.push_back(send_data.tx_reg[6:0]);
                            2'b11: tx.push_back(send_data.tx_reg[7:0]);
                        endcase
                        if(tx.size == trigger_level)
                        begin
                        send_data.tx = tx;
                        send_data.is_tx_data = 1;
        `uvm_info("monitor","Transmission data",UVM_MEDIUM);
                        send_data.print();
                        end
                    end
                else if(vif.mon_cb.wb_we_i == 1'b0)
                    begin
                        send_data.write = vif.mon_cb.wb_we_i;
                        send_data.rx_reg = vif.mon_cb.wb_dat_o;
                        rx.push_back(send_data.rx_reg);
                        if(rx.size == trigger_level)
                        begin    
                        send_data.rx = rx;
                        send_data.is_rx_data = 1;
        `uvm_info("monitor","Reciever data",UVM_MEDIUM);
                        send_data.print();
                        end
                    end
    endtask:read_write_t
