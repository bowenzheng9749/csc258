

module lab3part2(SW,LEDR);
	input [8:0] SW; //SW[7:4] for A, SW[3:0] for B, SW[8] for cin. 
	output [4:0] LEDR; //

	wire c1, c2, c3;

	fulladder FA1(SW[0],SW[4],SW[8], c1, LEDR[0]);
	fulladder FA2(SW[1],SW[5],c1, c2, LEDR[1]);
	fulladder FA3(SW[2],SW[6],c2, c3, LEDR[2]);
	fulladder FA4(SW[3],SW[7],c3, LEDR[4],LEDR[3]);

endmodule


module fulladder(a,b,c,x,y);
	input a,b,c;
	output x; // this is for carry
	output y; // this is for output

	assign x = (a&b)|(a&c)|(b&c)|(a&b&c);
	assign y = a^b^c;
endmodule