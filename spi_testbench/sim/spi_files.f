// set UVM_HOME variable to point to uvm/src dir
+incdir+$UVM_HOME
$UVM_HOME/uvm_pkg.sv

+incdir+../spi_common
+incdir+../spi_master
+incdir+../spi_slave
+incdir+../spi_env
+incdir+../test

../spi_common/spi_common_pkg.sv
../spi_master/spi_master_pkg.sv
../spi_slave/spi_slave_pkg.sv
../spi_env/spi_env_pkg.sv
../test/spi_test_lib_pkg.sv
../top/spi_interface.sv
../top/top.sv
