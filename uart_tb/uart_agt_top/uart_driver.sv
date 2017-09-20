class uart_driver extends uvm_driver #(uart_xtn);
    
    `uvm_component_utils(uart_driver)

//virtual interface handle
    virtual uart_if vif;
    
//config object handle
    uart_agent_config agt_cfg;

    extern function new(string name="uart_driver",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase (uvm_phase phase);
    extern task run_phase (uvm_phase phase);
    extern task drive_to_dut (uart_xtn xtn);
    extern task reset_dut();

endclass:uart_driver

//constructor
    function uart_driver::new(string name="uart_driver",uvm_component parent);        
        super.new(name,parent);
    endfunction:new

//build_phase
    function void uart_driver::build_phase(uvm_phase phase);
        super.build_phase(phase);
            if(!uvm_config_db #(uart_agent_config)::get(this, "", "uart_agent_config", agt_cfg))
            `uvm_fatal(get_type_name(), "unable to get configuration in driver")

    endfunction:build_phase

//connect_phase
    function void uart_driver::connect_phase (uvm_phase phase);
        vif = agt_cfg.vif;
    endfunction

//run_phase 
    task uart_driver::run_phase(uvm_phase phase);
        `uvm_info("driver","run_phase in driver",UVM_MEDIUM);
         reset_dut();
         forever
            begin: DRIVE
                seq_item_port.get_next_item(req);
                drive_to_dut(req);
                seq_item_port.item_done(req);
            end

    endtask

//reset_dut
    task uart_driver::reset_dut();
        #10;
        vif.wb_rst_i <= 1;
         vif.wb_we_i <= 0;
         vif.wb_stb_i <= 0;
         vif.wb_cyc_i <= 0;
         vif.wb_dat_i <= 0;
         vif.wb_adr_i <= 0;
        #25;
        vif.wb_rst_i <= 0;
    endtask:reset_dut

//drive to dut
    task uart_driver::drive_to_dut(uart_xtn xtn);
        `uvm_info("driver","drive_to_dut task in driver",UVM_MEDIUM);
        wait(!vif.wb_rst_i);
    
    if(xtn.write == 1'b0 && xtn.control_reg == 8'd2) begin                                                                    //to check IIR value
         @(vif.dr_cb); 
         wait(vif.dr_cb.int_o);
         vif.dr_cb.wb_we_i <= 0;
         vif.dr_cb.wb_cyc_i <= 1;
         vif.dr_cb.wb_stb_i <= 1;
         vif.dr_cb.wb_adr_i <= xtn.control_reg;
     wait(vif.dr_cb.wb_ack_o)
         vif.dr_cb.wb_cyc_i <= 0;
         vif.dr_cb.wb_stb_i <= 0;
             //@(vif.dr_cb);
             xtn.iir = vif.dr_cb.wb_dat_o;
        end

    else if(xtn.write == 1'b1) begin                                                                                                                //write logic
         @(vif.dr_cb);
         vif.dr_cb.wb_we_i <= 1;
         vif.dr_cb.wb_cyc_i <= 1;
         vif.dr_cb.wb_stb_i <= 1;
         vif.dr_cb.wb_adr_i <= xtn.control_reg;
         vif.dr_cb.wb_dat_i <= xtn.tx_reg;
         wait(vif.dr_cb.wb_ack_o)
         vif.dr_cb.wb_cyc_i <= 0;
         vif.dr_cb.wb_stb_i <= 0;
         end

    else if(xtn.write == 1'b0) begin                                                                                                                //read logic
         @(vif.dr_cb);
         vif.dr_cb.wb_we_i <= 0;
         vif.dr_cb.wb_cyc_i <= 1;
         vif.dr_cb.wb_stb_i <= 1;
         vif.dr_cb.wb_adr_i <= xtn.control_reg;
     wait(vif.dr_cb.wb_ack_o)
         vif.dr_cb.wb_cyc_i <= 0;
         vif.dr_cb.wb_stb_i <= 0;
         end

    endtask:drive_to_dut
