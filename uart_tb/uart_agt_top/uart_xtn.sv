class uart_xtn extends uvm_sequence_item;
  
// UVM Factory Registration Macro
    	`uvm_object_utils(uart_xtn)

//------------------------------------------
// DATA MEMBERS
//------------------------------------------
	rand bit [7:0] data_in;
	rand bit [7:0] addr;  
	bit [7:0] data_out;
   bit reset;  
	bit [7:0] iir;  
	bit [7:0] fcr;  
	bit [7:0] ier;  
	bit [7:0] lcr;  
	bit [15:0] dl;  
	rand bit write;
//------------------------------------------
// Constraints
//------------------------------------------
	

//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
extern function new(string name = "uart_xtn");
extern function void do_print(uvm_printer printer);
endclass:uart_xtn

//-----------------  constructor new method  -------------------//
//Add code for new()

	function uart_xtn::new(string name = "uart_xtn");
		super.new(name);
	endfunction:new

//-----------------  do_print method  -------------------//
   function void  uart_xtn::do_print (uvm_printer printer);
    super.do_print(printer);

   
    //                   srting name   		bitstream value     size       radix for printing
    printer.print_field( "write", 		this.write, 	    1,		 UVM_BIN		);
    printer.print_field( "addr", 		this.addr, 	8,		 UVM_DEC		);
    printer.print_field( "data_in", 		this.data_in, 	    8,		 UVM_DEC		);
    printer.print_field( "data_out",    this.data_out, 	    8,		 UVM_DEC		);
    printer.print_field( "iir", 		this.iir,     8,		 UVM_BIN		);
    printer.print_field( "lcr", 		this.lcr,     8,		 UVM_BIN		);
    printer.print_field( "fcr", 		this.fcr,     8,		 UVM_BIN		);
    printer.print_field( "ier", 		this.ier,     8,		 UVM_BIN		);
    printer.print_field( "dl", 		this.dl,     16,		 UVM_DEC		);
   
   endfunction:do_print
    



