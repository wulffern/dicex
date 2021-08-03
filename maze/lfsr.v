module lfsr (output logic[15:0] out, input logic clk, input logic rst,input logic[15:0] seed);


   assign feedback = ~( out[15]^out[14] ^ out[12]^ out[3]);

   always @(posedge clk, posedge rst)
     begin
        if (rst)
          out = seed;
        else
          out = {out[14:0],feedback};
     end
endmodule
