class uart_base_seq extends uvm_sequence #(uart_xtn);

    `uvm_object_utils(uart_base_seq)

    function new(string name="uart_base_seq");
        super.new(name);
    endfunction:new

endclass: uart_base_seq

//-----------------------------------------for writing into uart1 divisor latch----------------------------------------//
class dl1_write_seq extends uart_base_seq;

    `uvm_object_utils(dl1_write_seq)

    extern function new (string name = "dl1_write_seq");
    extern task body();
endclass: dl1_write_seq

    function dl1_write_seq::new(string name = "dl1_write_seq");
        super.new(name);
    endfunction

    task dl1_write_seq::body();
            begin
                req = uart_xtn::type_id::create("req");
                start_item(req);
                assert(req.randomize() with {write == 1'b1; control_reg[7:0]== 8'd3; tx_reg[7] == 1'b1; tx_reg[6:0]==0;});
                finish_item(req);

                start_item(req);    //to write devisor latch value 27
                assert(req.randomize() with {write == 1'b1; control_reg[7:0]== 8'd0; tx_reg[7:0] == 8'd27;});    
                finish_item(req);

                start_item(req);
                assert(req.randomize() with {write == 1'b1 ; control_reg[7:0]== 8'd1; tx_reg[7:0] == 8'd0;});
                finish_item(req);

                start_item(req);
                assert(req.randomize() with {write == 1'b1; control_reg[7:0]== 8'd3; tx_reg[7] == 8'd0; tx_reg[6:0] == 7'b0000011;});
                finish_item(req);
            end
    endtask

//-----------------------------------------for writing into uart2 divisor latch----------------------------------------//
class dl2_write_seq extends uart_base_seq;

    `uvm_object_utils(dl2_write_seq)

    extern function new (string name = "dl2_write_seq");
    extern task body();
endclass: dl2_write_seq

    function dl2_write_seq::new(string name = "dl2_write_seq");
        super.new(name);
    endfunction

    task dl2_write_seq::body();
            begin
                req = uart_xtn::type_id::create("req");
                start_item(req);    //lcr 7th bit high
                assert(req.randomize() with {write == 1'b1; control_reg[7:0]== 8'd3; tx_reg[7] == 1'b1; tx_reg[6:0]==0;});
                finish_item(req);

                start_item(req);    //to write devisor latch value 18
                assert(req.randomize() with {write == 1'b1; control_reg[7:0]== 8'd0; tx_reg[7:0] == 8'd18;});
                finish_item(req);

                start_item(req);    //write msb of dl reg
                assert(req.randomize() with {write == 1'b1; control_reg[7:0]== 8'd1; tx_reg[7:0] == 8'd0;});
                finish_item(req);

                start_item(req);    //lcr 7th bit low
                assert(req.randomize() with {write == 1'b1; control_reg[7:0]== 8'd3; tx_reg[7] == 8'd0; tx_reg[6:0] == 7'b0000011;});
                finish_item(req);
            end
    endtask
//-----------------------------------------------------Write LCR reg(for odd parity calc)------------------------------------------------------------------//
class odd_parity_enb_seq extends uart_base_seq;                                                                //Note- write LCR reg after setting DL reg value

    `uvm_object_utils(odd_parity_enb_seq)

    extern function new (string name = "odd_parity_enb_seq");
    extern task body();
endclass: odd_parity_enb_seq

    function odd_parity_enb_seq::new(string name = "odd_parity_enb_seq");
        super.new(name);
    endfunction

    task odd_parity_enb_seq::body();
            begin 
                req = uart_xtn::type_id::create("req");
                start_item(req);                                                        //parity enable (with odd parity)
                assert(req.randomize() with {write == 1'b1; control_reg[7:0]== 8'd3; tx_reg[7:5] == 'b0; tx_reg[4:0]=='b01011;});
                finish_item(req);
            end
    endtask
//-----------------------------------------------------Write LCR reg(for even parity calc)------------------------------------------------------------------//
class even_parity_enb_seq extends uart_base_seq;                                                                //Note- write LCR reg after setting DL reg value

    `uvm_object_utils(even_parity_enb_seq)

    extern function new (string name = "even_parity_enb_seq");
    extern task body();
endclass: even_parity_enb_seq

    function even_parity_enb_seq::new(string name = "even_parity_enb_seq");
        super.new(name);
    endfunction

    task even_parity_enb_seq::body();
            begin 
                req = uart_xtn::type_id::create("req");
                start_item(req);                                                        //parity enable (with even parity)
                assert(req.randomize() with {write == 1'b1; control_reg[7:0]== 8'd3; tx_reg[7:5] == 'b0; tx_reg[4:0]=='b11011;});
                finish_item(req);
            end
    endtask

//-----------------------------------------------------Write LCR to transmit 7bit in each char-----------------------------------------------------------//
class char_7bit_seq extends uart_base_seq;                                                                //Note- write LCR reg after setting DL reg value

    `uvm_object_utils(char_7bit_seq)

    extern function new (string name = "char_7bit_seq");
    extern task body();
endclass: char_7bit_seq

    function char_7bit_seq::new(string name = "char_7bit_seq");
        super.new(name);
    endfunction

    task char_7bit_seq::body();
            begin 
                req = uart_xtn::type_id::create("req");
                start_item(req);                                                        //even parity enable and 7bit char
                assert(req.randomize() with {write == 1'b1; control_reg[7:0]== 8'd3; tx_reg[7:5] == 'b0; tx_reg[4:0]=='b00110;});
                finish_item(req);
            end
    endtask

//-----------------------------------------------------Write LCR to transmit 7bit in each char-----------------------------------------------------------//
class char_6bit_seq extends uart_base_seq;                                                                //Note- write LCR reg after setting DL reg value

    `uvm_object_utils(char_6bit_seq)

    extern function new (string name = "char_6bit_seq");
    extern task body();
endclass: char_6bit_seq

    function char_6bit_seq::new(string name = "char_6bit_seq");
        super.new(name);
    endfunction

    task char_6bit_seq::body();
            begin 
                req = uart_xtn::type_id::create("req");
                start_item(req);                                                        //even parity enable and 6bit char
                assert(req.randomize() with {write == 1'b1; control_reg[7:0]== 8'd3; tx_reg[7:5] == 'b0; tx_reg[4:0]=='b00101;});
                finish_item(req);
            end
    endtask

//-----------------------------------------------------Write LCR to transmit 5bit in each char-----------------------------------------------------------//
class char_5bit_seq extends uart_base_seq;                                                                //Note- write LCR reg after setting DL reg value

    `uvm_object_utils(char_5bit_seq)

    extern function new (string name = "char_5bit_seq");
    extern task body();
endclass: char_5bit_seq

    function char_5bit_seq::new(string name = "char_5bit_seq");
        super.new(name);
    endfunction

    task char_5bit_seq::body();
            begin 
                req = uart_xtn::type_id::create("req");
                start_item(req);                                                        //even parity enable and 5bit char
                assert(req.randomize() with {write == 1'b1; control_reg[7:0]== 8'd3; tx_reg[7:5] == 'b0; tx_reg[4:0]=='b00100;});
                finish_item(req);
            end
    endtask

//-----------------------------------------set FIFO interrupt trigger level 4byte for both the UARTs----------------------------------------//
class config_fcr_4byte_seq extends uart_base_seq;

    `uvm_object_utils(config_fcr_4byte_seq)

    extern function new (string name = "config_fcr_4byte_seq");
    extern task body();
endclass: config_fcr_4byte_seq

    function config_fcr_4byte_seq::new(string name = "config_fcr_4byte_seq");
        super.new(name);
    endfunction

    task config_fcr_4byte_seq::body();
            begin
                req = uart_xtn::type_id::create("req");
            
                start_item(req);                //to set fifo interrupt trigger level to 4 bytes
                assert(req.randomize() with {write == 1'b1; control_reg[7:0]== 8'd2; tx_reg[7:6] == 2'b01; tx_reg[5:0] == 6'd0;});
                finish_item(req);

            end
    endtask

//-----------------------------------------set FIFO interrupt trigger level 1byte for both the UARTs----------------------------------------//
class config_fcr_1byte_seq extends uart_base_seq;

    `uvm_object_utils(config_fcr_1byte_seq)

    extern function new (string name = "config_fcr_1byte_seq");
    extern task body();
endclass: config_fcr_1byte_seq

    function config_fcr_1byte_seq::new(string name = "config_fcr_1byte_seq");
        super.new(name);
    endfunction

    task config_fcr_1byte_seq::body();
            begin
                req = uart_xtn::type_id::create("req");
            
                start_item(req);                //to set fifo interrupt trigger level to 1 bytes
                assert(req.randomize() with {write == 1'b1; control_reg[7:0]== 8'd2; tx_reg[7:6] == 2'b00; tx_reg[5:0] == 6'd0;});
                finish_item(req);

            end
    endtask

//-----------------------------------------set FIFO interrupt trigger level 8byte for both the UARTs----------------------------------------//
class config_fcr_8byte_seq extends uart_base_seq;

    `uvm_object_utils(config_fcr_8byte_seq)

    extern function new (string name = "config_fcr_8byte_seq");
    extern task body();
endclass: config_fcr_8byte_seq

    function config_fcr_8byte_seq::new(string name = "config_fcr_8byte_seq");
        super.new(name);
    endfunction

    task config_fcr_8byte_seq::body();
            begin
                req = uart_xtn::type_id::create("req");
            
                start_item(req);                //to set fifo interrupt trigger level to 8 bytes
                assert(req.randomize() with {write == 1'b1; control_reg[7:0]== 8'd2; tx_reg[7:6] == 2'b10; tx_reg[5:0] == 6'd0;});
                finish_item(req);

            end
    endtask

//-----------------------------------------set FIFO interrupt trigger level 14byte for both the UARTs----------------------------------------//
class config_fcr_14byte_seq extends uart_base_seq;

    `uvm_object_utils(config_fcr_14byte_seq)

    extern function new (string name = "config_fcr_14byte_seq");
    extern task body();
endclass: config_fcr_14byte_seq

    function config_fcr_14byte_seq::new(string name = "config_fcr_14byte_seq");
        super.new(name);
    endfunction

    task config_fcr_14byte_seq::body();
            begin
                req = uart_xtn::type_id::create("req");
            
                start_item(req);                //to set fifo interrupt trigger level to 14 bytes
                assert(req.randomize() with {write == 1'b1; control_reg[7:0]== 8'd2; tx_reg[7:6] == 2'b11; tx_reg[5:0] == 6'd0;});
                finish_item(req);

            end
    endtask


//-----------------------------------------set Interrupt Enable Registor of UART1 as per requirement----------------------------------------//
class config_ier_thr_seq extends uart_base_seq;

    `uvm_object_utils(config_ier_thr_seq)

    extern function new (string name = "config_ier_thr_seq");
    extern task body();
endclass: config_ier_thr_seq

    function config_ier_thr_seq::new(string name = "config_ier_thr_seq");
        super.new(name);
    endfunction

    task config_ier_thr_seq::body();
            begin
                req = uart_xtn::type_id::create("req");
            
                start_item(req);                //to set interrupt enable register(IER 1 bit high)
                assert(req.randomize() with {write == 1'b1; control_reg[7:0]== 8'd1; tx_reg[3:0] == 4'b0110; tx_reg[7:4] == 4'd0;});
                finish_item(req);
            end
    endtask

//-----------------------------------------set Interrupt Enable Registor of UART2 as per requirement----------------------------------------//
class ier_reciever_data_enb extends uart_base_seq;

    `uvm_object_utils(ier_reciever_data_enb)

    extern function new (string name = "ier_reciever_data_enb");
    extern task body();
endclass: ier_reciever_data_enb

    function ier_reciever_data_enb::new(string name = "ier_reciever_data_enb");
        super.new(name);
    endfunction

    task ier_reciever_data_enb::body();
            begin
                req = uart_xtn::type_id::create("req");
            
                start_item(req);                //to set interrupt enable register(IER 0 bit high)
                assert(req.randomize() with {write == 1'b1; control_reg[7:0]== 8'd1; tx_reg[3:0] == 4'b0101; tx_reg[7:4] == 4'd0;});
                finish_item(req);
            end
    endtask


//--------------------------------------------------------------IIR reading sequence--------------------------------------------------------------//
class interrupt_seq extends uart_base_seq;

    `uvm_object_utils(interrupt_seq)

    extern function new (string name = "interrupt_seq");
    extern task body();
endclass: interrupt_seq

    function interrupt_seq::new(string name = "interrupt_seq");
        super.new(name);
    endfunction

    task interrupt_seq::body();
            begin 
                req = uart_xtn::type_id::create("req");
            
                start_item(req);                //to read value from IIR 
                assert(req.randomize() with {write == 1'b0; control_reg[7:0]== 8'd2; tx_reg[7:0] == 8'd0;}); 
                finish_item(req); 
            end
    endtask

//--------------------------------------------------------------LSR reading sequence--------------------------------------------------------------//
class lsr_read_seq extends uart_base_seq;

    `uvm_object_utils(lsr_read_seq)

    extern function new (string name = "lsr_read_seq");
    extern task body();
endclass: lsr_read_seq

    function lsr_read_seq::new(string name = "lsr_read_seq");
        super.new(name);
    endfunction

    task lsr_read_seq::body();
            begin
                req = uart_xtn::type_id::create("req");
            
                start_item(req);                //to read value from LSR
                assert(req.randomize() with {write == 1'b0; control_reg[7:0]== 8'd5; tx_reg[7:0] == 8'd0;});
                finish_item(req);
            end
    endtask


//-----------------------------------------write into transmitter holding registor(paraller data transmission)----------------------------------------//
class data_trans_seq extends uart_base_seq;

    `uvm_object_utils(data_trans_seq)

    extern function new (string name = "data_trans_seq");
    extern task body();
endclass: data_trans_seq

    function data_trans_seq::new(string name = "data_trans_seq");
        super.new(name);
    endfunction

    task data_trans_seq::body();
            begin
                req = uart_xtn::type_id::create("req");
            
            repeat(1) begin                                                            //write 1 bytes of data
                start_item(req);        
                assert(req.randomize() with {write == 1'b1; control_reg[7:0]== 8'd0; tx_reg[7:0] != 00; });
                finish_item(req);
                end

            end
    endtask

//-----------------------------------------read from receiver buffer(parallel data receiving)----------------------------------------//
class data_rec_seq extends uart_base_seq;

    `uvm_object_utils(data_rec_seq)

    extern function new (string name = "data_rec_seq");
    extern task body();
endclass: data_rec_seq

    function data_rec_seq::new(string name = "data_rec_seq");
        super.new(name);
    endfunction

    task data_rec_seq::body();
            begin
                req = uart_xtn::type_id::create("req");
            
            repeat(1) begin                                                        //read 1 bytes of data
                start_item(req);        
                assert(req.randomize() with {write == 1'b0; control_reg[7:0]== 8'd0; tx_reg[7:0] == 8'd0; });
                finish_item(req);
                end

            end
    endtask

