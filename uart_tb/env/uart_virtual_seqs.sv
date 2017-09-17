class uart_vbase_seq extends uvm_sequence#(uvm_sequence_item);

	`uvm_object_utils(uart_vbase_seq)
	//Physical Sequence Handle
	uart_sequencer seqrh[];

	//Virual Sequencer handle
	uart_virtual_sequencer vsqrh;

	//Config Object Handle
	uart_env_config env_cfg;

   config_dl_seq1 config1_xtn;
   config_dl_seq2 config2_xtn;
   fifo_trg_level_seq trig_seq[];
   ier_reg_seq ier_seqh[];

   interrupt_seq iir_h[];
   data_trans_seq tx_h[];
   data_rec_seq rx_h[];

	extern function new(string name = "uart_vbase_seq");
	extern task body();

endclass

function uart_vbase_seq::new(string name = "uart_vbase_seq");
	super.new(name);
endfunction

task uart_vbase_seq::body();

	if(!uvm_config_db#(uart_env_config)::get(null, get_full_name(), "uart_env_config", env_cfg))
		`uvm_fatal(get_type_name(), "Cannot get env_config")
	
	seqrh = new[env_cfg.no_of_agt];
   
   trig_seq = new[env_cfg.no_of_agt];
   ier_seqh = new[env_cfg.no_of_agt];
   iir_h = new[env_cfg.no_of_agt];
   tx_h = new[env_cfg.no_of_agt];
   rx_h = new[env_cfg.no_of_agt];
	
   assert($cast(vsqrh, m_sequencer)) 
	else 
	begin
		`uvm_error("get_type_name()", "Error in $cast of virtual sequencer")
	end
	foreach(seqrh[i])
		seqrh[i] = vsqrh.seqrh[i];
endtask

///////////////////////////////////////////////////////////////////////
// write to devisor latch UART1
///////////////////////////////////////////////////////////////////////
class config_vseq extends uart_vbase_seq;

	`uvm_object_utils(config_vseq)

	extern function new(string name = "config_vseq");
	extern task body();

endclass

function config_vseq::new(string name = "config_vseq");
	super.new(name);
endfunction

task config_vseq::body();
	super.body();

   config1_xtn = config_dl_seq1::type_id::create("config1_xtn");
   config2_xtn = config_dl_seq2::type_id::create("config2_xtn");
   foreach(trig_seq[i])
      trig_seq[i] = fifo_trg_level_seq::type_id::create($sformatf("trig_seq[%0d]",i));
   foreach(ier_seqh[i])
      ier_seqh[i] = ier_reg_seq::type_id::create($sformatf("ier_reg_seqh[%0d]",i));
      
   fork
      begin
         config1_xtn.start(seqrh[0]);
         trig_seq[0].start(seqrh[0]);
         ier_seqh[0].start(seqrh[0]);
      end
      begin
         config2_xtn.start(seqrh[1]);
         trig_seq[1].start(seqrh[1]);
         ier_seqh[1].start(seqrh[1]);
      end
   join
endtask

///////////////////////////////////////////////////////////////////////
// write to devisor latch UART1
///////////////////////////////////////////////////////////////////////
class tx_rx_vseq extends uart_vbase_seq;

	`uvm_object_utils(tx_rx_vseq)

	extern function new(string name = "tx_rx_vseq");
	extern task body();

endclass

function tx_rx_vseq::new(string name = "tx_rx_vseq");
	super.new(name);
endfunction

task tx_rx_vseq::body();
	super.body();

   foreach(iir_h[i])
      iir_h[i] = interrupt_seq::type_id::create($sformatf("iir_h[%0d]",i));
   foreach(tx_h[i])
      tx_h[i] = data_trans_seq::type_id::create($sformatf("tx_h[%0d]",i));
   foreach(rx_h[i])
      rx_h[i] = data_rec_seq::type_id::create($sformatf("rx_h[%0d]",i));
      
   fork
      begin:UART1
         iir_h[0].start(seqrh[0]);
         if(iir_h[0].req.iir == 8'hC4)
         rx_h[0].start(seqrh[0]);
         else
         tx_h[0].start(seqrh[0]);
      end
      begin:UART2
          iir_h[1].start(seqrh[1]);
         if(iir_h[1].req.iir == 8'hC4)
         rx_h[1].start(seqrh[1]);
         else
         tx_h[1].start(seqrh[1]);
      end
   join
endtask

