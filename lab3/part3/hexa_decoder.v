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
