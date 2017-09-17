class uart_driver extends uvm_driver#(uart_xtn);

	//Factory Registration
	`uvm_component_utils(uart_driver)

	virtual uart_if.DR_MP vif;

	uart_agent_config agt_cfg;

	
	//---------------------------------------
	// Methods
	//---------------------------------------

	extern function new(string name ="uart_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(ref uart_xtn xtn);
	extern task reset_dut(); 
endclass: uart_driver


function uart_driver::new(string name = "uart_driver", uvm_component parent);
	super.new(name, parent);
endfunction


function void uart_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(uart_agent_config)::get(this, "", "uart_agent_config", agt_cfg))
		`uvm_fatal("Router_wr_driver", ": Cannot get uart_agent_config from uvm_config_db")
endfunction


function void uart_driver::connect_phase(uvm_phase phase);
vif = agt_cfg.vif;
endfunction

task uart_driver::run_phase(uvm_phase phase);
   reset_dut();
	forever
	begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done(req);
	end
endtask


task uart_driver::send_to_dut(ref uart_xtn xtn);
   wait(!vif.wb_rst_i);
   @(vif.dr_cb);   
   if(xtn.addr == 'd2 && xtn.write == 'd0)
   begin
      wait(vif.dr_cb.int_o)
      vif.dr_cb.wb_we_i <= xtn.write;
      vif.dr_cb.wb_stb_i <= 1;
      vif.dr_cb.wb_cyc_i <= 1;
      //vif.dr_cb.wb_sel_i
      vif.dr_cb.wb_adr_i <= xtn.addr;
      wait(vif.dr_cb.wb_ack_o)
      vif.dr_cb.wb_stb_i <= 0;
      vif.dr_cb.wb_cyc_i <= 0;
      @(vif.dr_cb)
      xtn.iir <= vif.dr_cb.wb_dat_o;
   end

   else if(xtn.addr != 'd2 && xtn.write == 'd1)
   begin
      vif.dr_cb.wb_we_i <= xtn.write;
      vif.dr_cb.wb_stb_i <= 1;
      vif.dr_cb.wb_cyc_i <= 1;
      vif.dr_cb.wb_adr_i <= xtn.addr;
      vif.dr_cb.wb_dat_i <= xtn.data_in;
      wait(vif.dr_cb.wb_ack_o)
      vif.dr_cb.wb_stb_i <= 0;
      vif.dr_cb.wb_cyc_i <= 0;
   end

   else if(xtn.addr != 'd2 && xtn.write == 'd0)
   begin
      vif.dr_cb.wb_we_i <= xtn.write;
      vif.dr_cb.wb_stb_i <= 1;
      vif.dr_cb.wb_cyc_i <= 1;
      vif.dr_cb.wb_adr_i <= xtn.addr;
      wait(vif.dr_cb.wb_ack_o)
      vif.dr_cb.wb_stb_i <= 0;
      vif.dr_cb.wb_cyc_i <= 0;
   end
   xtn.print();
endtask

task uart_driver::reset_dut();
#5;
vif.wb_rst_i <= 1;
#15;
vif.wb_rst_i <= 0;
endtask:reset_dut
