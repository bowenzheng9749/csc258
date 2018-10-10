module lab4part3(SW, LEDR, KEY);
	input [9:0] SW;
	input [3:0] KEY;
	output [7:0] LEDR;

	shifter s(KEY[3], KEY[2], SW[7:0], KEY[1], KEY[0], SW[9], LEDR[7:0]);

endmodule


module shifter(asr_in, shift, load_val, load_n, clk, reset_n, Q);
	input asr_in, load_n, clk, reset_n;
	input shift;
	input [7:0] load_val;
	output [7:0] Q;
	wire w;

	mux2to1 asr(1'b0, Q[7], asr_in, w);

	shifterBit s7(w, shift, load_val[7], load_n, clk, reset_n, Q[7]);
	shifterBit s6(Q[7], shift, load_val[6], load_n, clk, reset_n, Q[6]);
	shifterBit s5(Q[6], shift, load_val[5], load_n, clk, reset_n, Q[5]);
	shifterBit s4(Q[5], shift, load_val[4], load_n, clk, reset_n, Q[4]);
	shifterBit s3(Q[4], shift, load_val[3], load_n, clk, reset_n, Q[3]);
	shifterBit s2(Q[3], shift, load_val[2], load_n, clk, reset_n, Q[2]);
	shifterBit s1(Q[2], shift, load_val[1], load_n, clk, reset_n, Q[1]);
	shifterBit s0(Q[1], shift, load_val[0], load_n, clk, reset_n, Q[0]);

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
	output q;
	reg q;
	always @(posedge clk)
		begin
			if (reset_n == 1'b0)
				q <= 1'b0;
			else
				q <= d;
		end
endmodule