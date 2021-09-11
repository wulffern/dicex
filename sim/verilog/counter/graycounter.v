module graycounter(out, clk, reset);

   parameter WIDTH = 8;

   output [WIDTH-1 : 0] out;
   input                clk, reset;

   logic [WIDTH-1 : 0]  out;
   wire                 clk, reset;

   logic [WIDTH-1 : 0]  q;


   always @(posedge clk or posedge reset) begin
      if (reset)
        q <= 0;
      else begin
         q <= q + 1;
      end
      out <= {q[WIDTH-1], q[WIDTH-1:1] ^ q[WIDTH-2:0]};
   end

endmodule // graycounter
