#Makefile for UART UVM Testbench

RTLV = ../uart_rtl/*.v
RTLSV = ../uart_rtl/*.sv
INC = +incdir+../uart_agt_top +incdir+../test +incdir+../env +incdir+../uart_rtl
SVTB =  ../env/top.sv
SVTB1 = ../test/uart_test_pkg.sv
work = work

COVOP = -coveropt 3 +cover=sbf +acc
VSIMOPT= -coverage -novopt -assertdebug -sva -sv_seed random -l s.log work.top

VSIMBATCH0 = -c -do "coverage save -onexit -assert -directive -cvg -codeAll uart_cov0; $(EXCCOV); run -all;exit"
VSIMBATCH1 = -c -do "coverage save -onexit -assert -directive -cvg -codeAll uart_cov1; $(EXCCOV); run -all;exit"
VSIMBATCH2 = -c -do "coverage save -onexit -assert -directive -cvg -codeAll uart_cov2; $(EXCCOV); run -all;exit"
VSIMBATCH3 = -c -do "coverage save -onexit -assert -directive -cvg -codeAll uart_cov3; $(EXCCOV); run -all;exit"
VSIMBATCH4 = -c -do "coverage save -onexit -assert -directive -cvg -codeAll uart_cov4; $(EXCCOV); run -all;exit"
VSIMBATCH5 = -c -do "coverage save -onexit -assert -directive -cvg -codeAll uart_cov5; $(EXCCOV); run -all;exit"
VSIMBATCH6 = -c -do "coverage save -onexit -assert -directive -cvg -codeAll uart_cov6; $(EXCCOV); run -all;exit"

lib:
	vlib $(work)
	vmap work $(work)

sv_cmp: lib comp0
         
run_sim:
	vsim $(VSIMOPT) $(VSIMBATCH1)    
	#vcover report -html router_cov1

gui:
	vsim $(VSIMOPT) -coverage +UVM_OBJECTION_TRACE +UVM_TESTNAME=uart_test_txrx #TestName +UVM_VERBOSITY=UVM_MEDIUM #The Default Verbosity is medium
	#vcover report -html router_cov1
	
comp0:
	vlog -work $(work) $(COVOP) $(RTLV) $(RTLSV) $(INC) $(SVTB1) $(SVTB)  

run_gui: clean lib comp0 gui

run_test1:
	vsim $(VSIMBATCH0) -coverage -novopt -sva -sv_seed random -l test0_sim.log work.top +UVM_OBJECTION_TRACE +UVM_TESTNAME=uart_test_txrx
	vcover report -html uart_cov0

clean:
	rm -rf modelsim.* transcript* *log* work vsim.wlf fcover* covhtml* uart_cov*
	clear


