`include "timescale.v"
module top;

	import uart_test_pkg::*;
	import uvm_pkg::*;

	//Define and Generate Clock
	bit clock0;
   bit clock1;

	initial
	begin
		clock0 = 0;
		forever #10 clock0 = ~clock0;
	end

   initial
	begin
		clock1 = 0;
		forever #10 clock1 = ~clock1;
	end
	

	//Interface Inst
	uart_if if0(clock0);
	uart_if if1(clock1);

	//DUT Inst
   uart_top UART1(.wb_clk_i(clock0),.wb_rst_i(if0.wb_rst_i),.wb_adr_i(if0.wb_adr_i),.wb_dat_i(if0.wb_dat_i),.wb_dat_o(if0.wb_dat_o),.wb_we_i(if0.wb_we_i),.wb_stb_i(if0.wb_stb_i),
                  .wb_cyc_i(if0.wb_cyc_i),.wb_ack_o(if0.wb_ack_o),.wb_sel_i(if0.wb_sel_i),.int_o(if0.int_o),.stx_pad_o(s1),.srx_pad_i(s2),.rts_pad_o(if0.rts_pad_o),.cts_pad_i(if0.cts_pad_i),
                  .dtr_pad_o(if0.dtr_pad_o),.dsr_pad_i(if0.dsr_pad_i),.ri_pad_i(if0.ri_pad_i),.dcd_pad_i(if0.dcd_pad_i));

   uart_top UART2(.wb_clk_i(clock1),.wb_rst_i(if1.wb_rst_i),.wb_adr_i(if1.wb_adr_i),.wb_dat_i(if1.wb_dat_i),.wb_dat_o(if1.wb_dat_o),.wb_we_i(if1.wb_we_i),.wb_stb_i(if1.wb_stb_i),
                  .wb_cyc_i(if1.wb_cyc_i),.wb_ack_o(if1.wb_ack_o),.wb_sel_i(if1.wb_sel_i),.int_o(if1.int_o),.stx_pad_o(s2),.srx_pad_i(s1),.rts_pad_o(if1.rts_pad_o),.cts_pad_i(if1.cts_pad_i),
                  .dtr_pad_o(if1.dtr_pad_o),.dsr_pad_i(if1.dsr_pad_i),.ri_pad_i(if1.ri_pad_i),.dcd_pad_i(if1.dcd_pad_i));

	initial
	begin
		
		//Set Intf to Database
		uvm_config_db#(virtual uart_if)::set(null, "*", "if0", if0);
		uvm_config_db#(virtual uart_if)::set(null, "*", "if1", if1);
		
		run_test("test1");
		
	end

endmodule

