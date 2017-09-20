class coverage_collector extends uvm_subscriber #(uart_xtn);
    
    `uvm_component_utils(coverage_collector)

//        uart_env_config env_cfg;
        uart_xtn xtn;
        int xtn_count;
    
    extern function new(string name="coverage_collector",uvm_component parent);
    extern function void write(uart_xtn t);
    
    covergroup cov1;
        option.per_instance=1;
        IIR_REG: coverpoint xtn.iir[3:0] {
            bins Receiver_Line_Status = {'b0110};
            bins Receiver_Data_Available = {'b0100};
            bins Timeout_Indication = {'b1100};
            bins THR_empty = {'b0010};
            bins Modem_Status = {'b0000};
            }
        /*IER_REG: coverpoint xtn.ier[3:0] {
            bins received_data_available_interrupt = {[0:1]};
            bins THR_empty_interrupt[2] = {[0:1]};
            bins Receivre_Line_Status_interrupt[2] = {[0:1]};
            bins Modem_Status_interrupt[2] = {[0:1]};
            }*/
        FCR_REG: coverpoint xtn.fcr[7:6] {
            bins trigger_1byte = {'b00};
            bins trigger_4bytes = {'b01};
            bins trigger_8bytes = {'b10};
            bins trigger_14bytes = {'b11};
            }
        LSR_REG: coverpoint xtn.lsr[4:1] {
            bins Overrun_error = {1};
            bins Parity_error = {2};
            bins Framing_error = {4};
            bins Break_interrupt = {8};
            }
        LCR_DL_Acess: coverpoint xtn.lcr[7] {
            bins DL_Access[] = {[0:1]};
            }
        LCR_Break_Control: coverpoint xtn.lcr[6] {
            bins Break_Control[] = {[0:1]};
            }
        LCR_Parity_Enable: coverpoint xtn.lcr[3] {
            bins Parity_Enable[] = {[0:1]};
            }
        LCR_Stop_Bit: coverpoint xtn.lcr[2] {
            bins No_of_stop_bit[] = {[0:1]};
            }
        LCR_Parity_Select: coverpoint xtn.lcr[4] {
            bins Even_Parity_select[] = {[0:1]};
            }
        LCR_BitsPerChar: coverpoint xtn.lcr[1:0] {
            bins bits_in_char[] = {'b00,'b01,'b10,'b11};
            }
    endgroup : cov1

endclass:coverage_collector

    function coverage_collector::new(string name = "coverage_collector",uvm_component parent);
        super.new(name, parent);
        cov1 = new();
    endfunction

    function void coverage_collector::write(uart_xtn t);
        real current_coverage;
        xtn = t;
        xtn_count++;
        cov1.sample();        //sampling of coverpoint
        current_coverage = $get_coverage();
        uvm_report_info("COVERAGE", $psprintf("%0d Packets sampled, Coverage = %f%% ",xtn_count,current_coverage));
    endfunction

