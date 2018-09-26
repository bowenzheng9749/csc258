module hexa_display(SW,HEX0);
	input [3:0] SW;
	output [6:0] HEX0;
	
	helper h0(
		.a(SW[0]),
		.b(SW[1]),
		.c(SW[2]),
		.d(SW[3]),
		.HEX0(HEX0[0]),
		.HEX1(HEX0[1]),
		.HEX2(HEX0[2]),
		.HEX3(HEX0[3]),
		.HEX4(HEX0[4]),
		.HEX5(HEX0[5]),
		.HEX6(HEX0[6])
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
	assign HEX1 = ~a&b&~c&d|a&b&~d|a&c&d|b&c&~d;
	assign HEX2 = a&b&~c&~d|a&b&c|~a&~b&c&~d;
	assign HEX3 = ~a&~b&~c&d|~a&b&~c&~d|b&c&d|a&~b&c&~d;
	assign HEX4 = ~a&d|~a&b&~c&~d|a&~b&~c&d;
	assign HEX5 = ~a&~b&d|~a&b&c&d|a&b&~c&d|~a&~b&c&~d;
	assign HEX6 = ~a&~b&~c|a&b&~c&~d|~a&b&c&d;

endmodule

/*
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

   assign m = ~a&d|~a&b&~c&~d|a&~b&~c&d;
endmodule

module five(a,b,c,d,m);
	input a;
	input b;
	input c;
	input d;
	output m;
	
	assign m = ~a&~b&d|~a&b&c&d|a&b&~c&d|~a&~b&c&~d;
endmodule

module six(a,b,c,d,m);
	input a;
	input b;
	input c;
	input d;
	output m;
	
	assign m = ~a&~b&~c|a&b&~c&~d|~a&b&c&d;
endmodule
*/