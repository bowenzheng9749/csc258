module hexa_display(SW,HEX0);
	input [3:0] SW;
	output [6:0] HEX0;
	
	zero mod0(
		.a(SW[0]),
		.b(SW[1]),
		.c(SW[2]),
		.d(SW[3]),
		.m(HEX0[0])
		);

	one mod1(
		.a(SW[0]),
		.b(SW[1]),
		.c(SW[2]),
		.d(SW[3]),
		.m(HEX0[1])
		);

	two mod2(
		.a(SW[0]),
		.b(SW[1]),
		.c(SW[2]),
		.d(SW[3]),
		.m(HEX0[2])
		);
	three mod3(
		.a(SW[0]),
		.b(SW[1]),
		.c(SW[2]),
		.d(SW[3]),
		.m(HEX0[3])
		);
   four mod4(
		.a(SW[0]),
		.b(SW[1]),
		.c(SW[2]),
		.d(SW[3]),
		.m(HEX0[4])
		);
	five mod5(
		.a(SW[0]),
		.b(SW[1]),
		.c(SW[2]),
		.d(SW[3]),
		.m(HEX0[5])
		);
	six mod6(
		.a(SW[0]),
		.b(SW[1]),
		.c(SW[2]),
		.d(SW[3]),
		.m(HEX0[6])
		);
endmodule

module zero(a,b,c,d,m);
	input a;
	input b;
	input c;
	input d;
	output m;
	
	assign m = ~a&~b&~c&d|~a&b&~c&~d|a&b&~c&d|a&~b&c&d;
endmodule

module one(a,b,c,d,m);
	input a;
	input b;
	input c;
	input d;
	output m;
	
	assign m = ~a&b&~c&d|a&b&~d|a&c&d|b&c&~d;
endmodule

module two(a,b,c,d,m);
	input a;
	input b;
	input c;
	input d;
	output m;
	
	assign m = a&b&~c&~d|a&b&c|~a&~b&c&~d;
endmodule

module three(a,b,c,d,m);
	input a;
	input b;
	input c;
	input d;
	output m;
	
	assign m = ~a&~b&~c&d|~a&b&~c&~d|b&c&d|a&~b&c&~d;
endmodule

module four(a,b,c,d,m);
	input a;
	input b;
	input c;
	input d;
	output m;

   assign m = ~a&d|~b&~c&d|~a&b&~c;
endmodule

module five(a,b,c,d,m);
	input a;
	input b;
	input c;
	input d;
	output m;
	
	assign m = ~a&~b&d|~a&~b&c|~a&c&d|a&b&~c&d;
endmodule

module six(a,b,c,d,m);
	input a;
	input b;
	input c;
	input d;
	output m;
	
	assign m = ~a&~b&~c|a&b&~c&~d|~a&b&c&d;
endmodule