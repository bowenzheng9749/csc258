module lab4part3(SW, LEDR, KEY);
	input [9:0] SW;
	input [3:0] KEY;
	output [7:0] LEDR;

	shifter s(KEY[3], KEY[2], SW[7:0], KEY[1], KEY[0], SW[9], LEDR[7:0]);

endmodule


module shifter(asr_in, shift, load_val, load_n, clk, reset_n, Q);
	input asr_in, load_n, clk, reset_n;
	input [7:0] load_val;
	output [7:0] Q;
	wire w7, w6, w5, w4, w3, w2, w1, W0;

	mux2to1 asr(1'b0, Q[7], asr_in, w7);

	shifterBit s7(w7, shift, load_val[7], load_n, clk, reset_n, w6);
	shifterBit s6(w6, shift, load_val[6], load_n, clk, reset_n, w5);
	shifterBit s5(w5, shift, load_val[5], load_n, clk, reset_n, w4);
	shifterBit s4(w4, shift, load_val[4], load_n, clk, reset_n, w3);
	shifterBit s3(w3, shift, load_val[3], load_n, clk, reset_n, w2);
	shifterBit s2(w2, shift, load_val[2], load_n, clk, reset_n, w1);
	shifterBit s1(w1, shift, load_val[1], load_n, clk, reset_n, w0);
	shifterBit s0(w0, shift, load_val[0], load_n, clk, reset_n, Q[0]);
	assign w6 = Q[7];
	assign w5 = Q[6];
	assign w4 = Q[5];
	assign w3 = Q[4];
	assign w2 = Q[3];
	assign w1 = Q[2];
	assign w0 = Q[1];

endmodule

module shifterBit(in, shift, load_val, load_n, clk, reset_n, out);
	input in, shift, load_val, load_n, clk, reset_n;
	output out;
	wire w0, w1;
	mux2to1 m0(out, in, shift, w0);
	mux2to1 m1(load_val, w0, load_n, w1);
	flipflop f0(w1, clk,reset_n, out);

endmodule

module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output
  
    assign m = s & y | ~s & x;
endmodule


module flipflop(d, clk, reset_n, q);
	input d;
	input clk, reset_n;
	output  q;
	always @(posedge clk)
		begin
			if (reset_n == 1'b0)
				q <= 1'b0;
			else
				q <= d;
		end
endmodule