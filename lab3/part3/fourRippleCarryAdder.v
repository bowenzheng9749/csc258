 
module fourRippleCarryAdder(A,B,cin, S, cout);
	input [3:0] A;
	input [3:0] B;
	input cin;
	output [3:0] S;
	output cout;

	wire c1, c2, c3;

	fulladder FA1(A[0],B[0],cin, c1, S[0]);
	fulladder FA2(A[1],B[1],c1, c2, S[1]);
	fulladder FA3(A[2],B[2],c2, c3, S[2]);
	fulladder FA4(A[3],B[3],c3, cout,S[3]);

endmodule


module fulladder(a,b,ci,co,s);
	input a,b,ci;
	output co; // this is for carry
	output s; // this is for output

	assign co = (a&b)|(a&ci)|(b&ci)|(a&b&ci);
	assign s = a^b^ci;
endmodule
