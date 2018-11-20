// Part 2 skeleton

module part2
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.

    
    combined c1 (SW[6:0], SW[9:7], ~KEY[3], ~KEY[1], x, y, color, writeEn, CLOCK_50, reset_n);
    
endmodule

module combined (data, color, ld, go, out_x, out_y, out_c, writeN, clock, resetn);
	input clock, resetn, ld, go;
	input [6:0] data;
	input [2:0] color;
	output [7:0] out_x;
	output [6:0] out_y;
	output [2:0] out_c;
	output writeN;
	
	wire ld_x, ld_y, ld_r,  draw;
	
	//datapath
	datapath d0(data, color, resetn, clock, ld_x, ld_y, ld_r, draw, out_x, out_y, out_c);

	// control
   control c0(clock, resetn, go, ld, ld_x, ld_y, ld_r, draw, writeN);
endmodule


module datapath(data, color, resetn, clock, ld_x, ld_y, ld_r, draw, out_x, out_y, out_c);
	input [6:0] data;
	input [2:0] color;
	input resetn, clock;
	input ld_x, ld_y, ld_r, draw;
	
	output  [7:0] out_x;
	output  [6:0] out_y;
	output reg [2:0] out_c;
	
	reg [7:0] x;
	reg [6:0] y;
	reg [3:0] q;

	assign out_x = x + q[1:0];
	assign out_y = y + q[3:2];
	
	always @(posedge clock)
	begin: load
		if (!resetn) 
			begin
				x <= 0;
				y <= 0;
				out_c = 3'b111;
			end
		else 
			begin
				if (ld_x) 
					begin
						x <= {1'b0, data}; 
					end
				else if (ld_y)
						y <= data;
				else if (ld_r)
						out_c = color;
			end
	end

	always @(posedge clock)
	begin: counter
		if (! resetn)
			q <= 4'b0000;
		else if (draw)
			begin
				if (q == 4'b1111)
					q <= 0;
				else
					q <= q + 1'b1;
			end
	end
endmodule

module control(clock, resetn, go, ld, ld_x, ld_y, ld_r, draw, writeN);
	input resetn, clock, go, ld;
	output reg ld_x, ld_y, ld_r, draw, writeN;

	reg [2:0] current_state, next_state;
	
	localparam Load_x = 3'd0,
				Load_x_wait= 3'd1,
				Load_y = 3'd2,
				Load_y_wait = 3'd3,
				Load_color = 3'd4,	
				Load_color_wait = 3'd5,				
				Draw = 3'd6;

	always @(*)
	begin: state_table
		case (current_state)
			Load_x: next_state = ld ? Load_x_wait : Load_x;
			Load_x_wait: next_state = ld ? Load_x_wait : Load_y;
			Load_y: next_state = ld ? Load_y_wait : Load_y;
			Load_y_wait: next_state = ld ? Load_y_wait : Load_color;
			Load_color: next_state = go ? Load_color_wait : Load_color;
			Load_color_wait: next_state = go ? Load_color_wait : Draw;
			Draw: next_state = ld ? Load_x : Draw;
			default: next_state = Load_x;
		endcase
	end
	
	always @(*)
	begin: signals
		ld_x = 1'b0;
		ld_y = 1'b0;
		ld_r = 1'b0;
		draw = 1'b0;
		writeN = 1'b0;
		
		case (current_state)
		Load_x: 
			begin 
			ld_x = 1'b1;
			end
		Load_y: 
			begin
			ld_y = 1'b1;
			end
		Load_color : 
			begin
			ld_r = 1'b1;
			end
		Draw: 
			begin
			draw = 1'b1;
			writeN = 1'b1;
			end
		endcase
	end
	
	always@(posedge clock)
    begin: state_FFs
        if(!resetn)
            current_state <= Load_x;
        else
            current_state <= next_state;
    end 
endmodule
