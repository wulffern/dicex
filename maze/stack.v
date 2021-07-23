// Copy from https://electrobinary.blogspot.com/2020/05/stack-or-lifo.html
module stack(
 clk,
 rst,
 pop,
 push,
 empty,
 full,
 din,
 dout
    );

parameter WIDTH = 8;
parameter DEPTH = 8;

input clk;
input rst;
input pop;
input push;
input [WIDTH-1:0]din;

output [WIDTH-1:0]dout;
output empty;
output full;

reg [WIDTH-1:0]stack[DEPTH-1:0]; //memory
reg [WIDTH-1:0]index, next_index;
reg [WIDTH-1:0]dout, next_dout;

wire empty, full;

always @ (posedge clk) //Sequential block
begin
  if(rst)
  begin
    dout  <= 8'd0;
    index <= 1'b0;
  end
  else
  begin
    dout  <= next_dout;
    index <= next_index;
  end
end

assign empty = !(|index);
assign full  = !(|(index ^ DEPTH));

always @ (*) //Combinational Block
begin
  if(push) //write
  begin
  stack[index] = din;
  next_index   = index+1'b1;
  end
  else if(pop)  //read
  begin
  next_dout  = stack[index-1'b1];
  next_index = index-1'b1;
  end
  else
  begin
  next_dout  = dout;
  next_index = index;
  end

end
endmodule
