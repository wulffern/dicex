`timescale 1 ps / 1 fs

module IVX1_CV(A, Y);
   input A;
   output Y;
   assign #2 Y = ~A;
endmodule


module NDX1_CV(A, B, Y);
   input A,B;
   output Y;
   assign Y = ~(A & B);
endmodule

module ANX1_CV(A, B, Y);
   input A,B;
   output Y;
   assign Y = A& B;

endmodule // ANX1_CV

module ORX1_CV(A, B, Y);
   input A,B;
   output Y;
   assign Y = A | B;

endmodule // ORX1_CV

module EOX1_CV(A, B, Y);
   input A,B;
   output Y;
   assign Y = ~A & B | ~B & A;

endmodule // EOX1_CV

module ENX1_CV(A, B, Y);
   input A,B;
   output Y;
   assign Y = ~(~A & B | ~B & A);
endmodule



module NRX1_CV(A, B, Y);
   input A,B;
   output Y;
   assign Y = ~(A | B);
endmodule


module DFSRQNX1_CV(D,CK,S, R, Q, QN);
   input logic D,CK,S,R;
   output logic Q,QN;
   always @(posedge CK, posedge S, posedge R)
	if (S) begin
		Q <= 1'b1;
      QN <= 1'b0;
   end
	else if (R) begin
		Q <= 1'b0;
       QN <= 1'b1;

      end
	else begin
		Q <= D;
       QN <=~D;
   end

endmodule
