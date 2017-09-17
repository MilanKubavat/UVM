#Makefile for UART UVM Testbench

RTL = ../uart_rtl/*
INC = +incdir+../uart_agt_top +incdir+../test +incdir+../env +incdir+../uart_rtl
SVTB =  ../env/top.sv
SVTB1 = ../test/uart_test_pkg.sv
work = work

COVOP = -coveropt 3 +cover=sbf +acc
VSIMOPT= -coverage -novopt -assertdebug -sva -sv_seed random -l s.log work.top

VSIMBATCH0 = -c -do "coverage save -onexit -assert -directive -cvg -codeAll router_cov0; $(EXCCOV); run -all;exit"
VSIMBATCH1 = -c -do "coverage save -onexit -assert -directive -cvg -codeAll router_cov1; $(EXCCOV); run -all;exit"

lib:
	vlib $(work)
	vmap work $(work)

sv_cmp: lib comp0
         
run_sim:
	vsim $(VSIMOPT) $(VSIMBATCH1)    
	#vcover report -html router_cov1

gui:
	vsim $(VSIMOPT) -coverage +UVM_OBJECTION_TRACE #+UVM_TESTNAME=router_wait_till_empty_pkt #TestName +UVM_VERBOSITY=UVM_MEDIUM #The Default Verbosity is medium
	#vcover report -html router_cov1
	
comp0:
	vlog -work $(work) $(COVOP) $(RTL) $(INC) $(SVTB1) $(SVTB)  

run_gui: clean lib comp0 gui

run_test:
	vsim $(VSIMBATCH0) -coverage -novopt -sva -sv_seed random -l test0_sim.log work.top +UVM_OBJECTION_TRACE
	#vcover report -html router_cov0

clean:
	rm -rf modelsim.* transcript* *log* work vsim.wlf fcover* covhtml* router_cov*
	clear
#report:
#	vcover merge router_cover router_cov0 router_cov1 router_cov2 router_cov3 router_cov4 router_cov5 router_cov6 router_cov7 router_cov8 router_cov9 router_cov10 
#	vcover report -html router_cover

#regress: clean lib comp0 run_test run_test1 run_test2 run_test3 run_test4 run_test5 run_test6 run_test7 run_test8 run_test9 run_test10 report html
