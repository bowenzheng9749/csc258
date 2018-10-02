module lab3part2(SW, LEDR, HEX0, HEX1, HEX3, HEX3, HEX4, HEX5);
	input [7:0] SW;
	input [2:0] KEY;
	output [7:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	wire [7:0] out;

