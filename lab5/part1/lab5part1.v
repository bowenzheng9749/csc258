module lab5part1(SW, KEY,HEX0, HEX1);
	input [3:0] SW;
	input [1:0] KEY;
	output [6:0] HEX0;
	output [6:0] HEX1;
	wire [7:0] w;


	hexa_decoder h0(w[3:0], HEX0[6:0]);
	hexa_decoder h1(w[7:4], HEX1[6:0]);
	counter c (SW[1], KEY[0], SW[0], wire[7:0]);

endmodule


module counter(enable, clk, clear_b, Q);
	input enable, clk clear_b;
	output [7:0] Q;
	wire  w6, w5, w4, w3, w2, w1, w0;
	assign w6 = enable&Q[7];
	assign w5 = w6&Q[6];
	assign w4 = w5&Q[5];
	assign w3 = w4&Q[4];
	assign w2 = w3&Q[3];
	assign w1 = w2&Q[2];
	assign w0 = w1&Q[1];

	one_bit_counter c7(
		.T(enable),
		.clk(clk),
		.clear_b(clear_b),
		.Q(Q[7])
	);
	one_bit_counter c6(
		.T(w6),
		.clk(clk),
		.clear_b(clear_b),
		.Q(Q[6])
	);
	one_bit_counter c5(
		.T(w5),
		.clk(clk),
		.clear_b(clear_b),
		.Q(Q[5])
	);
	one_bit_counter c4(
		.T(w4),
		.clk(clk),
		.clear_b(clear_b),
		.Q(Q[4])
	);
	one_bit_counter c3(
		.T(w3),
		.clk(clk),
		.clear_b(clear_b),
		.Q(Q[3])
	);
	one_bit_counter c2(
		.T(w2),
		.clk(clk),
		.clear_b(clear_b),
		.Q(Q[2])
	);
	one_bit_counter c1(
		.T(w1),
		.clk(clk),
		.clear_b(clear_b),
		.Q(Q[1])
	);
	one_bit_counter c0(
		.T(w0),
		.clk(clk),
		.clear_b(clear_b),
		.Q(Q[0])
	);
endmodule


module one_bit_counter(T, clk, clear_b, Q);
	input T, clk, clear_b;
	output Q;
	reg Q;

	always @(posedge clk, negedge clear_b)
		begin
			if (clear_b == 1'b0)
				Q <= 1'b0;
			else
				Q <= T&~Q | ~T&Q;
		end
endmodule

module hexa_decoder(in,HEX);
	input [3:0] in;
	output [6:0] HEX;
	
	helper h(
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

 
