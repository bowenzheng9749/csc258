module lab5part3(SW, KEY, CLOCK_50, LEDR);
	input [2:0] SW;
	input [1:0] KEY;
	input CLOCK_50;
	output [1:0] LEDR;

	morseencode(SW[2:0], KEY[0], CLOCK_50, KEY[1], LEDR[0]);

endmodule


module morseencode(in, reset, clk, par_load, out);
	input [2:0] in;
	input reset;
	input par_load;
	input clk;
	output out;

	wire [13:0] w1;
	wire w2;
	lut l(in, w1);
	shifter s(reset,w2,par_load, w1, out);

	ratedivider r(reset, clk, w2);
endmodule

module lut(key, out);
	input [2:0] key;
	output reg [13:0] out;

	always @(*)
	begin
		case(key)
			3'd0: out = {8'd0, 6'b101010};
			3'd1: out = {10'd0, 4'b1110};
			3'd2: out = {6'd0, 8'b10101110};
			3'd3: out = {4'd0, 10'b1010101110};
			3'd4: out = {4'd0, 10'b1011101110};
			3'd5: out = {2'd0, 12'b111010101110};
			3'd6: out = {14'b11101011101110};
			3'd7: out = {2'd0, 12'b111011101010};
		endcase
	end
endmodule

module shifter(reset_n, clock, par_load, load, out);
	input reset_n, par_load, clock;
	input [13:0] load;
	output reg out;

	reg [13:0] q;

	always @(posedge clock, negedge reset_n, negedge par_load)
		begin
			if (reset_n == 0)
				q <= 14'b00000000000000;
			else if (par_load == 1'b0)
				q <= load;
				out <= q[13];
				q <= q << 1'b1;
		end

endmoudle


module ratedivider(reset_n, clock, q);
	input reset_n;
	input clock;
	output q;

	reg [27:0] rate;


	always @(posedge clock, negedge reset_n)
	begin
		if (reset_n == 1'b0)

			rate <= 0;

		else if (rate == 0)

			rate <= 28'd24999999;

		else

			rate <= rate - 1'b1;	
	end

	assign q = (rate == 0) ? 1 : 0;

endmodule
