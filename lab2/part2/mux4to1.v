//SW[2:0] data inputs
//SW[9] select signal

//LEDR[0] output display



module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output
  
    assign m = s & y | ~s & x;
    // OR
    // assign m = s ? y : x;

endmodule

module mux4to1(SW, LEDR);
	input [9:0] SW; // we will use switch 0,1,2,3,8,9 as inputs
	output [9:0] LEDR;
	
	wire connect0; // connect first block to third block
	wire connect1;
	
	mux2to1 first(
		.x(SW[0]), // u
		.y(SW[1]), // v
		.s(SW[9]), // s0
		.m(connect0) // output to third block
	
	);
	
	mux2to1 second(
		.x(SW[2]), // w
		.y(SW[3]), // x
		.s(SW[9]), // s0
		.m(connect1) // output to third block
	
	);
	
	mux2to1 third(
		.x(connect0), // output from first block
		.y(connect1), // output from second block
		.s(SW[8]), // s1
		.m(LEDR[0]) // output to LEDR[0]
	
	);
endmodule 
