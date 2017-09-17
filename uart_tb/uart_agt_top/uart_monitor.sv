class uart_monitor extends uvm_monitor;

	`uvm_component_utils(uart_monitor)

	virtual uart_if.MON_MP vif;

	uart_agent_config agt_cfg;
   uart_xtn send2sb;
	uvm_analysis_port#(uart_xtn) monitor_ap;

	extern function new(string name = "uart_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	extern task reset_t();
	extern task lcr_reg_t();
	extern task dl_reg_t();
	extern task iir_reg_t();
	extern task read_write_t();
	extern task ier_reg_t();
	extern task fcr_reg_t();
endclass: uart_monitor


function uart_monitor::new(string name = "uart_monitor", uvm_component parent);
	super.new(name, parent);
	monitor_ap = new("monitor_port", this);
endfunction


function void uart_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db#(uart_agent_config)::get(this, "", "uart_agent_config", agt_cfg))
		`uvm_fatal("uart_monitor", ": Cannot get router_wr_config from uvm_config")
endfunction


function void uart_monitor::connect_phase(uvm_phase phase);
	vif = agt_cfg.vif;
endfunction


task uart_monitor::run_phase(uvm_phase phase);
	forever
    collect_data();
endtask


task uart_monitor::collect_data();
$display("collect data task running");
   send2sb = uart_xtn::type_id::create("send2sb");

   if(vif.wb_rst_i)
      reset_t();
   else
      begin
         @(vif.mon_cb);
         wait(vif.mon_cb.wb_ack_o);
      begin 
         if(vif.mon_cb.wb_adr_i == 'd3 && vif.mon_cb.wb_dat_i != 'd128)                                         //update LCR reg in transaction field
            lcr_reg_t();
         else if(vif.mon_cb.wb_adr_i == 'd3 && vif.mon_cb.wb_dat_i == 'd128)                                    //update DL reg  
            dl_reg_t();
         else if(vif.mon_cb.wb_adr_i == 'd2 && vif.mon_cb.wb_we_i == 'b0)                                       //update IIR reg
            iir_reg_t();
         else if(vif.mon_cb.wb_adr_i == 'd2 && vif.mon_cb.wb_we_i == 'b1)                                       //update FCR reg
            fcr_reg_t();
         else if(vif.mon_cb.wb_adr_i == 'd1)                                                                    //update IER reg
            ier_reg_t();
         else if(vif.mon_cb.wb_adr_i == 'd0)                                                                    //update data_in or data_out
            read_write_t();
      end
   end
   send2sb.print();
   $display($time,"send2sb printing");
endtask:collect_data

//------------------------------------------------------------------------//
   task uart_monitor::reset_t();
      send2sb.reset = vif.wb_rst_i;
      @(vif.mon_cb)
      send2sb.data_out = vif.mon_cb.wb_dat_o;
   endtask:reset_t
//-----------------------------------------------------------------------//
   task uart_monitor::lcr_reg_t();
      @(vif.mon_cb)
      send2sb.addr = vif.mon_cb.wb_adr_i;
      send2sb.write = vif.mon_cb.wb_we_i;
      if(send2sb.write == 'b1)
      begin
      send2sb.data_in = vif.mon_cb.wb_dat_i;
      send2sb.lcr = vif.mon_cb.wb_dat_i;
      `uvm_info("monitor","written value in LCR reg",UVM_MEDIUM)
      end
      else if(send2sb.write == 'b0)
      begin
      send2sb.data_out = vif.mon_cb.wb_dat_o;
      send2sb.lcr = vif.mon_cb.wb_dat_o;
      `uvm_info("monitor","reading from LCR reg",UVM_MEDIUM)
      end
   endtask:lcr_reg_t
//------------------------------------------------------------------------//
  task uart_monitor::ier_reg_t();
      @(vif.mon_cb)
      send2sb.addr = vif.mon_cb.wb_adr_i;
      send2sb.write = vif.mon_cb.wb_we_i;
      if(send2sb.write == 'b1)
      begin
      send2sb.data_in = vif.mon_cb.wb_dat_i;
      send2sb.ier = vif.mon_cb.wb_dat_i;
      `uvm_info("monitor","written value in IER reg",UVM_MEDIUM)
      end
      else if(send2sb.write == 'b0)
      begin
      send2sb.data_out = vif.mon_cb.wb_dat_o;
      send2sb.lcr = vif.mon_cb.wb_dat_o;
      `uvm_info("monitor","reading from IER reg",UVM_MEDIUM)
      end
   endtask:ier_reg_t
//------------------------------------------------------------------------//
  task uart_monitor::fcr_reg_t();
      @(vif.mon_cb)
      send2sb.addr = vif.mon_cb.wb_adr_i;
      send2sb.data_in = vif.mon_cb.wb_dat_i;
      send2sb.fcr = vif.mon_cb.wb_dat_i;
      send2sb.write = vif.mon_cb.wb_we_i;
      `uvm_info("monitor","written data into FCR reg",UVM_MEDIUM)
   endtask:fcr_reg_t
//-----------------------------------------------------------------------//
 task uart_monitor::dl_reg_t();
 begin
      send2sb.addr = vif.mon_cb.wb_adr_i;
      send2sb.write = vif.mon_cb.wb_we_i;
      @(vif.mon_cb)
      wait(vif.mon_cb.wb_ack_o);
      if(vif.mon_cb.wb_adr_i == 'd0)
      begin
      send2sb.data_in = vif.mon_cb.wb_dat_i;
      send2sb.dl[7:0] = vif.mon_cb.wb_dat_i;
      //send2sb.print(); $stop;
      @(vif.mon_cb)
      wait(vif.mon_cb.wb_ack_o);
      send2sb.dl[15:8] = vif.mon_cb.wb_dat_i;
      end
      else if(vif.mon_cb.wb_adr_i == 'd1)
      begin
      send2sb.data_in = vif.mon_cb.wb_dat_i;
      send2sb.dl[15:8] = vif.mon_cb.wb_dat_i;
      @(vif.mon_cb)
      wait(vif.mon_cb.wb_ack_o);
      send2sb.dl[7:0] = vif.mon_cb.wb_dat_i;
      end
      `uvm_info("monitor","written data in DL reg",UVM_MEDIUM)
   end
   endtask:dl_reg_t
//------------------------------------------------------------------------//
   task uart_monitor::iir_reg_t();
      @(vif.mon_cb)
      if(vif.mon_cb.wb_we_i == 'b0)
      begin
      send2sb.addr = vif.mon_cb.wb_adr_i;
      send2sb.iir = vif.mon_cb.wb_dat_o;
      send2sb.write = vif.mon_cb.wb_we_i;
      end
      `uvm_info("monitor","written data in DL reg",UVM_MEDIUM)
   endtask:iir_reg_t
//------------------------------------------------------------------------//
   task uart_monitor::read_write_t();
      send2sb.addr = vif.mon_cb.wb_adr_i;
      @(vif.mon_cb)
      if(vif.mon_cb.wb_we_i == 'b1)
      begin
      send2sb.write = vif.mon_cb.wb_we_i;
      send2sb.data_in = vif.mon_cb.wb_dat_i;
      end
      else if(vif.mon_cb.wb_we_i == 'b0)
      begin
      send2sb.write = vif.mon_cb.wb_we_i;
      send2sb.data_out = vif.mon_cb.wb_dat_o;
      end
   endtask:read_write_t

