module lab5part2(SW, KEY, HEX0, CLOCK_50);
	input CLOCK_50;
	input [1:0] SW;
	input [1:0] KEY;
	output [6:0] HEX0;

	wire [3:0] w;

	counter(SW,  KEY[0], CLOCK_50, w);

	hexa_decoder h(w, HEX0);

endmodule



module counter(enable, key, reset_n, clock, out);
	input [1:0] key;
	input enable, reset_n;
	input clock;

	output [3:0] out;
	wire w;

	reg [27:0] freq;

	always @(*)
		begin
			case(key)
				2'b00: freq = 0;
				2'b01: freq = 28'd49999999;
				2'b10: freq = 28'd99999999;
				2'b11: freq = 28'd199999999;
			endcase
		end

		ratedivider r(enable, freq, reset_n, clock, w);

		displaycounter d(w, reset_n, clock, out);
endmodule

module displaycounter(enable, reset_n, clock, q);
	input enable, reset_n;
	input clock;
	output [3:0] q;
	reg [3:0] q;

	always @(posedge clock, negedge reset_n)
	begin
		if (reset_n == 1'b0)
			q <= 4'b0000;
		else if (enable == 1'b1)
			begin
				if (q == 4'b1111)
					q <= 4'b0000;
				else
					q <= q + 1'b1;
			end
	end
endmodule


module ratedivider(enable, load, reset_n, clock, q);
	input [27:0] load;
	input reset_n, enable;
	input clock;
	output q;

	reg [27:0] rate;


	always @(posedge clock, negedge reset_n)
	begin
		if (reset_n == 1'b0)

			rate <= 0;

		else if (rate == 0)

			rate <= load;

		else

			rate <= rate - 1'b1;	
	end

	assign q = (rate == 0) ? 1 : 0;

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

 
