class uart_sb extends uvm_scoreboard;

    `uvm_component_utils(uart_sb)

//declare analysis fifo to collect transaction from uart1 and uart2
    uvm_tlm_analysis_fifo #(uart_xtn) uart_fifo[];

//env configuration handle
    uart_env_config env_cfg;    

    uart_xtn data_0, store_rx;
    uart_xtn data_1, store_tx;

    logic BitsPerChar;

    extern function new(string name = "uart_sb", uvm_component parent);
    //extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task compare_t();
endclass: uart_sb

    function uart_sb::new(string name = "uart_sb", uvm_component parent);
        super.new(name, parent);
        if(!uvm_config_db #(uart_env_config)::get(this,"","uart_env_config",env_cfg))
        `uvm_fatal(get_full_name(),"unable to get config")

        uart_fifo = new[env_cfg.no_of_agt];
        foreach(uart_fifo[i])
        uart_fifo[i] = new($sformatf("uart_fifo[%0d]",i),this);
    endfunction

    task uart_sb::run_phase(uvm_phase phase);                                                                                

        fork
            forever
                begin
                    uart_fifo[0].get(data_0);
                    if(data_0.is_tx_data)
                    store_tx = data_0;
                
                    else if(data_0.is_rx_data)
                        begin
                        store_rx = data_0;
                        compare_t();
                        end
                end
            
            forever
                begin
                    uart_fifo[1].get(data_1);
                    if(data_1.is_tx_data)
                    store_tx = data_1;     //store_1.print(); $stop;
                    else if(data_1.is_rx_data)
                        begin
                        store_rx = data_1;
                        compare_t();
                        end    
                end
        join    

    endtask

    task uart_sb::compare_t();                                                    
        

                        if(!(store_rx.rx == store_tx.tx))     
                            begin
                            `uvm_info("Scoreboard","comparision failed",UVM_LOW);
                            store_tx.print();
                            store_rx.print();
                            $stop;
                            end
                        else
                            begin
                            `uvm_info("Scoreboard","comparision successful",UVM_LOW);
                            store_tx.print();
                            store_rx.print();
                            end
        
    endtask


