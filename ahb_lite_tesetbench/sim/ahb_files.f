// set UVM_HOME variable to point to uvm/src dir
+incdir+$UVM_HOME
$UVM_HOME/uvm_pkg.sv

+incdir+../ahb_common
+incdir+../ahb_master
+incdir+../ahb_slave
+incdir+../ahb_env
+incdir+../test

../ahb_common/ahb_common_pkg.sv
../ahb_master/ahb_master_pkg.sv
../ahb_slave/ahb_slave_pkg.sv
../ahb_env/ahb_env_pkg.sv
../test/test_pkg.sv
../top/ahb_interface.sv
../top/top.sv
