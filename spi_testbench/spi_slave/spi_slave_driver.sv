//----------------------------------------------------------
// Start Date: 8 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: spi slave driver logic 
//----------------------------------------------------------

class spi_slave_driver extends uvm_driver#(spi_transaction);

  `uvm_component_utils(spi_slave_driver)

  virtual spi_interface spi_vif;
  spi_slave_cfg cfg;

  logic [7:0] addr;
  logic [7:0] recieve_data;
  logic [7:0] send_data;

  extern function new(string name = "spi_slave_driver", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task drive();
endclass: spi_slave_driver

function spi_slave_driver::new(string name = "spi_slave_driver", uvm_component parent);
  super.new(name, parent);
endfunction

function void spi_slave_driver::build_phase(uvm_phase phase);
  // fatal error if cfg not found in config db
  if(!uvm_config_db#(spi_slave_cfg)::get(this, "", "spi_slave_cfg", cfg)) begin
     `uvm_fatal(get_full_name(), "Cannot get s_cfg from configuration database!")
  end

  super.build_phase(phase);
endfunction

function void spi_slave_driver::connect_phase(uvm_phase phase);
  spi_vif = cfg.spi_vif;
endfunction

task spi_slave_driver::run_phase(uvm_phase phase);
  forever begin
    seq_item_port.get_next_item(req);
      @(negedge spi_vif.SSB)
      fork
        drive();
        wait(spi_vif.SSB == 1);
      join_any
      disable fork;
    seq_item_port.item_done(req);
  end
endtask

task spi_slave_driver::drive();
  `uvm_info(get_full_name(), "Inside slave driver drive task!!", UVM_LOW)
  if(spi_vif.SCLK == 0) begin

    // recieve command and address (instruction)
    // MSB first
    `uvm_info(get_full_name(), "Recieving serial instruction..", UVM_LOW)
    for(int i = 7; i >= 0; i--) begin
      @(posedge spi_vif.SCLK)
      addr[i] <= spi_vif.MOSI;
    end

    // recieve data
    `uvm_info(get_full_name(), "Recieving serial data... ", UVM_LOW)
    if(addr[7] == 0) begin
      for(int i = 7; i >= 0; i--) begin
        @(posedge spi_vif.SCLK)
        recieve_data[i] <= spi_vif.MOSI;
      end
    cfg.slave_mem[addr[6:0]] = recieve_data;
    send_data = cfg.slave_mem[addr[6:0]];
    end

    // driving MISO
    else begin
    `uvm_info(get_full_name(), "Sending serial data... ", UVM_LOW)
      for(int i = 7; i >= 0; i--) begin
        @(negedge spi_vif.SCLK)
        spi_vif.MISO <= send_data[i];
      end
    end
  end
endtask
