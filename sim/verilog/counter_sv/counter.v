module counter(
               output logic [WIDTH-1:0] out,
               input logic             clk,
               input logic             reset
               );

   parameter WIDTH = 8;

   always_ff @(posedge clk or posedge reset) begin
      if (reset)
        out <= 0;
      else
        out <= out + 1;
   end

endmodule // counter
