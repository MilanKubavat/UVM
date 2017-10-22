module dut(
   input clock, reset_b,
   input rw,
   input [1:0] addr,
   input [31:0] wdata,
   output reg [31:0] rdata
);

   reg [31:0] dreg0, dreg1;

   always@(posedge clock, negedge reset_b)
   begin
      if(!reset_b) rdata = 0;
      else
      begin
         if(rw) //Read
         begin
            if(addr == 2'b00)
               rdata <= dreg0;
            else if(addr == 2'b01)
               rdata <= dreg1;
            else
               rdata <= 'X;
         end
         else //Write
         begin
            if(addr == 2'b00)
               dreg0 <= wdata;
            if(addr == 2'b01)
               dreg1 <= wdata;
         end
      end

endmodule

