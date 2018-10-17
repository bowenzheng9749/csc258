module morsecode(SW, KEY,CLOCK_50,LEDR0);
	input [3:0] SW; // SW[2:0] selcet, SW[3] enable for rate divider
	input [1:0] KEY;
	input CLOCK_50;
	output LEDR0;
	
	wire [13:0] load;
	wire en;
	
	LUT l0(
		.select(SW[2:0]),
		.out(load)
		);
		
	RateDivider r0 (
		.enable(SW[3]),
		.clock(CLOCK_50),
		.reset_n(KEY[1]),
		.q(en)
		);
		
	ShifterRegister s0 (
		.en(en),
		.load(load),
		.par_load(KEY[1]),
		.clk(CLOCK_50),
		.clear_b(KEY[0]),
		.out(LEDR0)
		);

endmodule

module LUT(select, out);
	input [2:0] select;
	output reg [13:0] out;

	always @(*)
	begin
		case (select)
			3'b000: out = 14'b10101000000000;
			3'b001: out = 14'b11100000000000;
			3'b010: out = 14'b10101110000000;
			3'b011: out = 14'b10101011100000;
			3'b100: out = 14'b10111011100000;
			3'b101: out = 14'b11101010111000;
			3'b110: out = 14'b11101011101110;
			3'b111: out = 14'b11101110101000;
		endcase
	end
	
endmodule

module RateDivider(enable,clock, reset_n,q);
	input enable,clock,reset_n;
	output q;
	
	wire [24:0] load;
	assign load = 25'd24_999_999;
	
	reg [24:0] out;
	
	always@(posedge clock)
	begin
		if (reset_n == 1'b0)
			out <= load;
		else if (enable == 1'b1)
			begin
				if (out == 25'd0)
					out <= load;
				else
					out <= out - 1'b1;
			end
	end
	
	assign q = (out == 25'd0) ? 1 : 0;
endmodule

module ShifterRegister(en,load,par_load,clk,clear_b,out);
	input en, clk,clear_b,par_load;
	input [13:0] load;
	output reg out;
	
	reg [13:0] shifter;
	
	always @(posedge clk, negedge clear_b)
	begin
		if (clear_b == 1'b0)
			begin
				out <= 0;
				shifter <= 0;
			end
		else if (par_load == 1'b0)
			begin
				shifter <= load;
				out <= 0;
			end
		else if (en == 1'b1)
			begin
				out <= shifter[13];
				shifter <= shifter << 1'b1;
			end
	end
	
	
endmodule