module lab4part2(SW, LEDR,KEY, HEX0, HEX4, HEX5);
	input [9:0] SW;
	input [3:0] KEY;
	output [9:0] LEDR;
	output [6:0] HEX0, HEX4, HEX5;
	wire [7:0] out;
	wire [7:0] regOut;

	aluFunctions f(SW[3:0], regOut[3:0], SW[7:5], out[7:0]);

	assign LEDR[7:0] = regOut[7:0];

	register r(out[7:0], KEY[0], SW[9], regOut[7:0]);

	hexa_decoder h0(SW[3:0], HEX0[6:0]); // display value of A
	hexa_decoder h4(regOut[3:0], HEX4[6:0]);
	hexa_decoder h5(regOut[7:4], HEX5[6:0]);

endmodule

module register(d, clk, reset_n, q);
	input [7:0]d;
	input clk, reset_n;
	output [7:0] q;
	always @(posedge clk)
		begin
			if (reset_n == 1'b0)
				q[7:0] <= 8'b00000000;
			else
				q[7:0] <= d[7:0];
		end
endmodule


module aluFunctions(A, B, Functions, funcOut);
	input [3:0] A;
	input [3:0] B;
	input [2:0] Functions;
	output [7:0] funcOut;
	wire [4:0] f0res, f1res;
	reg [7:0] funcOut;

	// case for A+1
	fourRippleCarryAdder f0 (A[3:0], 4'b0000, 1'b1, f0res[3:0], f0res[4]);


	// case for A+B
	fourRippleCarryAdder f1 (A[3:0], B[3:0], 1'b0, f1res[3:0], f1res[4]);


	always @(*)
	begin
		case (Functions)
			3'b111: funcOut = {3'b000, f0res[4:0]};
			3'b110: funcOut = {3'b000, f1res[4:0]};
			3'b101: funcOut = A + B;
			3'b100: funcOut = {A^B, A|B};
			3'b011: funcOut = | {A, B};
			3'b010: funcOut = {4'b0000, B << A};
			3'b001: funcOut = {4'b0000, B >> A};
			3'b000: funcOut = A * B;
			default: funcOut = 8'b00000000;
		endcase
	end
endmodule

module hexa_decoder(in,HEX);
	input [3:0] in;
	output [6:0] HEX;
	
	helper h0(
		.a(in[3]),
		.b(in[2]),
		.c(in[1]),
		.d(in[0]),
		.HEX0(HEX[0]),
		.HEX1(HEX[1]),
		.HEX2(HEX[2]),
		.HEX3(HEX[3]),
		.HEX4(HEX[4]),
		.HEX5(HEX[5]),
		.HEX6(HEX[6])
	);
endmodule


module helper(a,b,c,d,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6);
	input a;
	input b;
	input c;
	input d;
	output HEX0;
	output HEX1;
	output HEX2;
	output HEX3;
	output HEX4;
	output HEX5;
	output HEX6;

	assign HEX0 = ~a&~b&~c&d|~a&b&~c&~d|a&b&~c&d|a&~b&c&d;
	assign HEX1 = ~a&b&~c&d|a&c&d|b&c&~d|a&b&~d;
	assign HEX2 = a&b&~d|a&b&c|~a&~b&c&~d;
	assign HEX3 = ~a&~b&~c&d|~a&b&~c&~d|b&c&d|a&~b&c&~d;
	assign HEX4 = ~a&d|~b&~c&d|~a&b&~c;
	assign HEX5 = ~a&~b&d|~a&c&d|a&b&~c&d|~a&~b&c;
	assign HEX6 = ~a&~b&~c|a&b&~c&~d|~a&b&c&d;

endmodule

 
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
