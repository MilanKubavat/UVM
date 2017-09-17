class uart_base_seq extends uvm_sequence#(uart_xtn);

	`uvm_object_utils(uart_base_seq)

	extern function new(string name = "uart_base_seq");

endclass

function  uart_base_seq::new(string name = "uart_base_seq");
	super.new(name);
endfunction

//////////////////////////////////////////////////////////////////////////////////////////////////
// Delay Sequence
/////////////////////////////////////////////////////////////////////////////////////////////////
class delay_seq extends uart_base_seq;

	`uvm_object_utils(delay_seq)

	extern function new(string name = "delay_seq");
	extern task body();

endclass

function delay_seq::new(string name = "delay_seq");
	super.new(name);
endfunction

task delay_seq::body();
	req = uart_xtn::type_id::create("req");
   $display($time,"body method called");
	start_item(req);
	$display($time,"through start_item.........");
	`uvm_info(get_type_name(), "Printing from write sequence", UVM_HIGH)
   #1;
	$display($time,"before finish item");
   finish_item(req);
endtask
//////////////////////////////////////////////////////////////////////////////////////////////////
// Configuration DL reg UART1 Sequence
/////////////////////////////////////////////////////////////////////////////////////////////////
class config_dl_seq1 extends uart_base_seq;

	`uvm_object_utils(config_dl_seq1)

	extern function new(string name = "config_dl_seq1");
	extern task body();
endclass:config_dl_seq1

function config_dl_seq1::new(string name = "config_dl_seq1");
	super.new(name);
endfunction

task config_dl_seq1::body();
	req = uart_xtn::type_id::create("req");
	start_item(req);
   assert(req.randomize() with {write == 1'b1; addr[7:0] == 8'd3; data_in[7:0] == 8'd128;});
   finish_item(req);

   start_item(req);
   assert(req.randomize() with {write == 1'b1; addr[7:0] == 8'd0; data_in[7:0] == 8'd27;});
   finish_item(req);

   start_item(req);
   assert(req.randomize() with {write == 1'b1; addr[7:0] == 8'd1; data_in[7:0] == 8'd0;});
   finish_item(req);

   start_item(req);
   assert(req.randomize() with {write == 1'b1; addr[7:0] == 8'd3; data_in[7:0] == 8'd3;});
   finish_item(req);
endtask
//////////////////////////////////////////////////////////////////////////////////////////////////
// Configuration DL reg UART2 Sequence
/////////////////////////////////////////////////////////////////////////////////////////////////
class config_dl_seq2 extends uart_base_seq;

	`uvm_object_utils(config_dl_seq2)

	extern function new(string name = "config_dl_seq2");
	extern task body();
endclass:config_dl_seq2

function config_dl_seq2::new(string name = "config_dl_seq2");
	super.new(name);
endfunction

task config_dl_seq2::body();
	req = uart_xtn::type_id::create("req");
	start_item(req);
   assert(req.randomize() with {write == 1'b1; addr[7:0] == 8'd3; data_in[7:0] == 8'd128;});
   finish_item(req);

   start_item(req);
   assert(req.randomize() with {write == 1'b1; addr[7:0] == 8'd0; data_in[7:0] == 8'd18;});
   finish_item(req);

   start_item(req);
   assert(req.randomize() with {write == 1'b1; addr[7:0] == 8'd1; data_in[7:0] == 8'd0;});
   finish_item(req);

   start_item(req);
   assert(req.randomize() with {write == 1'b1; addr[7:0] == 8'd3; data_in[7:0] == 8'd3;});
   finish_item(req);
endtask:body
//////////////////////////////////////////////////////////////////////////////////////////////////
// Configuration FIFO trig level reg Sequence
/////////////////////////////////////////////////////////////////////////////////////////////////
class fifo_trg_level_seq extends uart_base_seq;

	`uvm_object_utils(fifo_trg_level_seq)

	extern function new(string name = "fifo_trg_level_seq");
	extern task body();
endclass:fifo_trg_level_seq

function fifo_trg_level_seq::new(string name = "fifo_trg_level_seq");
	super.new(name);
endfunction

task fifo_trg_level_seq::body();
	req = uart_xtn::type_id::create("req");
	start_item(req);
   assert(req.randomize() with {write == 1'b1; addr[7:0] == 8'd2; data_in[7:6] == 2'b01; data_in[5:0] == 6'd0;});
   finish_item(req);
endtask
//////////////////////////////////////////////////////////////////////////////////////////////////
// Configuration IER reg Sequence
/////////////////////////////////////////////////////////////////////////////////////////////////
class ier_reg_seq extends uart_base_seq;

	`uvm_object_utils(ier_reg_seq)

	extern function new(string name = "ier_reg_seq");
	extern task body();
endclass:ier_reg_seq

function ier_reg_seq::new(string name = "ier_reg_seq");
	super.new(name);
endfunction

task ier_reg_seq::body();
	req = uart_xtn::type_id::create("req");
	start_item(req);
   assert(req.randomize() with {write == 1'b1; addr[7:0] == 8'd1; data_in[3:0] == 4'b0111; data_in[7:4] == 4'd0;});
   finish_item(req);
endtask
//////////////////////////////////////////////////////////////////////////////////////////////////
// IIR reg reading Sequence
/////////////////////////////////////////////////////////////////////////////////////////////////
class interrupt_seq extends uart_base_seq;

	`uvm_object_utils(interrupt_seq)

	extern function new(string name = "interrupt_seq");
	extern task body();
endclass:interrupt_seq

function interrupt_seq::new(string name = "interrupt_seq");
	super.new(name);
endfunction

task interrupt_seq::body();
	req = uart_xtn::type_id::create("req");
	start_item(req);
   assert(req.randomize() with {write == 1'b0; addr[7:0] == 8'd1; data_in[7:0] == 8'd0;});
   finish_item(req);
endtask
//////////////////////////////////////////////////////////////////////////////////////////////////
// writing THR Sequence
/////////////////////////////////////////////////////////////////////////////////////////////////
class data_trans_seq extends uart_base_seq;

	`uvm_object_utils(data_trans_seq)

	extern function new(string name = "data_trans_seq");
	extern task body();
endclass:data_trans_seq

function data_trans_seq::new(string name = "data_trans_seq");
	super.new(name);
endfunction

task data_trans_seq::body();
	req = uart_xtn::type_id::create("req");
   repeat(4) begin
	start_item(req);
   assert(req.randomize() with {write == 1'b1; addr[7:0] == 8'd0;});
   finish_item(req);
             end
endtask
//////////////////////////////////////////////////////////////////////////////////////////////////
// reading from reciever buffer Sequence
/////////////////////////////////////////////////////////////////////////////////////////////////
class data_rec_seq extends uart_base_seq;

	`uvm_object_utils(data_rec_seq)

	extern function new(string name = "data_rec_seq");
	extern task body();
endclass:data_rec_seq

function data_rec_seq::new(string name = "data_rec_seq");
	super.new(name);
endfunction

task data_rec_seq::body();
	req = uart_xtn::type_id::create("req");
   repeat(4) begin
	start_item(req);
   assert(req.randomize() with {write == 1'b0; addr[7:0] == 8'd0; data_in == 8'd0;});
   finish_item(req);
             end
endtask
