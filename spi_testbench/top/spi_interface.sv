//----------------------------------------------------------
// Start Date: 8 Apr 2020
// Last Modified:
// Author: Milan Kubavat
// 
// Description: spi interface, needs modification to support
//              tri-state implementation
//----------------------------------------------------------

interface spi_interface (input clock);
  logic SCLK;
  logic MISO;
  logic MOSI;
  logic SSB;
endinterface	
