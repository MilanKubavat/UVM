//----------------------------------------------------------
// Start Date: 8 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: spi master driving logic 
//----------------------------------------------------------

class spi_master_driver extends uvm_driver#(spi_transaction);

  `uvm_component_utils(spi_master_driver)

  virtual spi_interface spi_vif;
  spi_master_cfg cfg;

  extern function new(string name = "spi_master_driver", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task drive(spi_transaction req);
  extern task mode_0();
  extern task mode_1();
  extern task mode_2();
  extern task mode_3();

endclass: spi_master_driver

function spi_master_driver::new(string name = "spi_master_driver", uvm_component parent);
  super.new(name, parent);
endfunction

function void spi_master_driver::build_phase(uvm_phase phase);
  // fatal error if cfg not found in config db
  if(!uvm_config_db#(spi_master_cfg)::get(this, "", "spi_master_cfg", cfg)) begin
     `uvm_fatal(get_full_name(), "Cannot get m_agt_cfg from configuration database!")
  end
  super.build_phase(phase);
endfunction

function void spi_master_driver::connect_phase(uvm_phase phase);
  spi_vif = cfg.spi_vif;
endfunction

task spi_master_driver::run_phase(uvm_phase phase);
  forever begin
    seq_item_port.get_next_item(req);
    drive(req);
    seq_item_port.item_done(req);
  end
endtask

task spi_master_driver::drive(spi_transaction req);
  `uvm_info(get_full_name(), "Inside master driver drive task!!", UVM_LOW)
   req.print;

   // select mode based on clock polarity
   // and clock phase
   case ({cfg.cpol, cfg.cpha})
     0: mode_0();
     1: mode_1();
     2: mode_2();
     3: mode_3();
     default : mode_0();
   endcase
endtask

task spi_master_driver::mode_0();
  spi_vif.SSB <= 1;
  @(posedge spi_vif.clock);
  spi_vif.SSB <= 0;
  // drive command and address (instruction)
  // MSB first
  for(int i = 7; i >= 0; i--) begin
    spi_vif.SCLK <= 0;
    spi_vif.MOSI <= req.instruction[i];
    @(posedge spi_vif.clock);
    spi_vif.SCLK <= 1;
    @(posedge spi_vif.clock);
  end
  
  if(req.instruction[7] == 0) begin
    // drive data
    // MSB first
    for(int i = 7; i >= 0; i--) begin
      spi_vif.SCLK <= 0;
      spi_vif.MOSI <= req.data[i];
      @(posedge spi_vif.clock);
      spi_vif.SCLK <= 1;
      @(posedge spi_vif.clock);
    end
  end
  else begin
    // recieve data
    // MSB first
    for(int i = 7; i >= 0; i--) begin
      spi_vif.SCLK <= 0;
      @(posedge spi_vif.clock);
      spi_vif.SCLK <= 1;
      req.data[i]  <= spi_vif.MISO;
      @(posedge spi_vif.clock);
    end
  end
  
  // signals to defualt when operation completes
  spi_vif.SCLK <= 0;
  @(posedge spi_vif.clock);
  spi_vif.SSB <= 1;
endtask

task spi_master_driver::mode_1();
  `uvm_error(get_full_name(), "Mode 1 is not defined");
endtask

task spi_master_driver::mode_2();
  `uvm_error(get_full_name(), "Mode 2 is not defined");
endtask

task spi_master_driver::mode_3();
  `uvm_error(get_full_name(), "Mode 3 is not defined");
endtask
