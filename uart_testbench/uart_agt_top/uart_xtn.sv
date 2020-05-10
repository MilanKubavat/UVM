class uart_xtn extends uvm_sequence_item;

    `uvm_object_utils(uart_xtn)

//transaction fields
  rand bit [7:0] control_reg;    
    rand bit [7:0] tx_reg;    
    bit [7:0] rx_reg;
    bit [7:0] tx[$];    
    bit [7:0] rx[$];    
  bit reset_value;
    rand bit write;
    bit is_tx_data;
    bit is_rx_data;
    constraint TX_DATA{tx_reg inside{[0:255]};}

//properties to store register values
    logic [7:0] iir;
    logic [7:0] lsr;
    logic [7:0] ier;
    logic [7:0] fcr;
    logic [7:0] lcr;
    logic [15:0] dl;

//trasaction class methods
        extern function new (string name = "uart_xtn");
        extern function void do_print (uvm_printer printer);

endclass:uart_xtn

//constructor
function uart_xtn::new (string name = "uart_xtn");
        super.new (name);
    endfunction

//print method
    function void uart_xtn::do_print (uvm_printer printer);
      super.do_print(printer);

    printer.print_field( "reset_value",         reset_value,         1,         UVM_BIN        );
    printer.print_field( "write",         write,         1,         UVM_BIN        );
    printer.print_field( "control_reg",         control_reg,         8,         UVM_BIN        );
    printer.print_field( "iir",         iir,         8,         UVM_BIN        );
    printer.print_field( "lsr",         lsr,         8,         UVM_BIN        );
    printer.print_field( "ier",         ier,         8,         UVM_BIN        );
    printer.print_field( "fcr",         fcr,         8,         UVM_BIN        );
    printer.print_field( "lcr",         lcr,         8,         UVM_BIN        );
    printer.print_field( "dl",         dl,         8,         UVM_BIN        );
        printer.print_field( "tx_reg",         tx_reg,         8,         UVM_BIN        );
    printer.print_field( "rx_reg",         rx_reg,         8,         UVM_BIN        );
    foreach(tx[i])
        printer.print_field( $sformatf("tx[%0d]",i),         tx[i],         8,         UVM_DEC        );
    foreach(rx[i])
        printer.print_field( $sformatf("rx[%0d]",i),         rx[i],         8,         UVM_DEC        );
    printer.print_field( "is_tx_data",         is_tx_data,         1,         UVM_BIN        );
    printer.print_field( "is_rx_data",         is_rx_data,         1,         UVM_BIN        );

  endfunction:do_print
