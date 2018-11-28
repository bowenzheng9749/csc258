module try
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,					//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY; // KEY[1] go.  KEY[0] resetn

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;			//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];
	

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
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.

	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire wirteEn;
	//-------------------------------------------------------------------------
	wire [19:0] delay;
	wire [3:0] frame;

	wire finish_draw, stair1_finish_draw, stair2_finish_draw;
	wire erase, sclock;

	wire [7:0] x1, x2;
	wire [6:0] y1, y2;
	wire [2:0] colour1, colour2;
	wire en, en_d, draw;
	wire frame_en, change;
	//-------------------------------------------------------------------------
	slowclock s0(CLOCK_50, resetn, sclock);
	
	delay_counter d0(CLOCK_50, resetn, en_d, frame_en);
	
	frame_counter f0(CLOCK_50, resetn, frame_en, change);


//	assign draw1 = (stair1_finish_draw == 0 && draw == 1)? 1 : 0;
//	stair_datapath sd0(resetn, CLOCK_50, en, draw1, 8'd60, 7'd40, erase, x1, y1, colour1, stair1_finish_draw);
//
//	assign draw2 = (stair2_finish_draw == 0 && stair1_finish_draw == 1 && draw == 1) ? 1 : 0;
//	stair_datapath sd1(resetn, CLOCK_50, en, draw2, 8'd20, 7'd80, erase, x2, y2, colour2, stair2_finish_draw);
//
//	mux m0(resetn, stair1_finish_draw ,stair2_finish_draw, x1, x2, y1, y2, colour1, colour2, x, y, colour);
//	
//	assign finish_draw = stair1_finish_draw && stair2_finish_draw;
	stair_datapath sd0(resetn, CLOCK_50 , en, draw, change, 8'd60, 7'd40, erase, x, y, colour, finish_draw);
	//erase_count e0(finish_draw, erase);
	control c0(resetn, sclock, ~KEY[1], change, finish_draw,  en, en_d, draw, writeEn, erase);
endmodule

//----------------------------------------
//				Combined   
//----------------------------------------
module combined(resetn, go, sclock, clock, writeEn, x, y, colour);
	input resetn, go, sclock, clock;
	output writeEn;
	output [7:0] x;
	output [6:0] y;
	output [2:0] colour;
	
	wire finish_draw;
	wire erase;

	wire en, en_d, draw;
	wire frame_en, change;

	stair_datapath sd0(resetn, clock , en, draw, change, 8'd60, 7'd40, erase, x, y, colour, finish_draw);

	control c0(resetn, sclock, go, change, finish_draw,  en, en_d, draw, writeEn, erase);


	
	delay_counter d0(clock, resetn, en_d, frame_en);
	
	frame_counter f0(clock, resetn, frame_en, change);



endmodule





//----------------------------------------
//				Mux     
//----------------------------------------
module mux(
	input reset_n, stair1_finish_draw ,stair2_finish_draw,
	input [7:0] x1, x2,
	input [6:0] y1, y2,
	input [2:0] colour1, colour2,
	output reg [7:0] x, 
	output reg [6:0] y,
	output reg [2:0] colour
);

	always @(*)
		begin
			if(!reset_n)
				begin
					x <= 0;
					y <= 0;
					colour <= 0;
				end
			else if(stair1_finish_draw == 0 && stair2_finish_draw == 0)
				begin
					x <= x1;
					y <= y1;
					colour <= colour1;
				end
			else if(stair1_finish_draw == 1 && stair2_finish_draw == 0)
				begin
					x <= x2;
					y <= y2;
					colour <= colour2;
				end
		end
endmodule
//----------------------------------------
//			slower counter      
//----------------------------------------
module slowclock(clock,reset_n,enable);
	input clock, reset_n;
	output enable;
	
	reg [25:0] count;
	
	always@(posedge clock)
		begin
			if(!reset_n)
				count <= 26'd0;
			else
				begin
					if(count == 26'd400)
						count <= 26'd0;
					else
						count <= count + 1'b1;
				end
		end
	assign enable = (count == 26'd400) ? 1 : 0;
endmodule
	
//----------------------------------------
//			delay and frame counter      
//----------------------------------------
module delay_counter(
	input wire clock, reset_n, en_d, 
	output frame_en
);
	reg [19:0] delay;

	always @(posedge clock)
		begin: delay_counter
			if (!reset_n)
				delay <= 20'd833_334;
			else if (en_d == 1'b1)
				begin
					if (delay == 0)
						delay <= 20'd833_334;
					else
						delay <= delay - 1'b1;
				end
		end
		assign frame_en = (delay == 20'd0) ? 1 : 0;
endmodule

module frame_counter(
	input clock, reset_n, frame_en,
	//input [2:0] input_color,
	output change
	//output [2:0] output_color
);	
	reg [5:0] frame;

	always @(posedge clock)
		begin: frame_counter
			if (!reset_n)
				frame <= 6'd0;
			else if (frame_en == 1'b1)
				begin
					//if (frame == 4'd14)
					if (frame == 6'd14)
						frame <= 6'd0;
					else
						frame <= frame + 1'b1;
				end
		end
		assign change = (frame == 6'd14) ? 1 : 0;
		//assign output_color = (frame == 4'd14) ? 3'b000 : input_color;
			
endmodule



//----------------------------------------
//					FSM     
//----------------------------------------
module control(
	input reset_n, clock, go, change, finish_draw, 
	output reg en, en_d, draw, plot, erase
	
);

	reg [2:0] current_state, next_state;

	localparam  Start = 3'd0,
					Start_Wait = 3'd1,
					Draw = 3'd2,
					Draw_wait = 3'd3,
					Erase = 3'd4,
					Erase_wait = 3'd5,
					Load_new = 3'd6;

		
	always @(*)
	begin: state_table
		case (current_state)
			Start: next_state = go ? Start_Wait : Start;
			Start_Wait: next_state = go ? Start_Wait : Draw ;

			Draw: next_state = (finish_draw == 1) ? Draw_wait : Draw;
			Draw_wait: next_state = (change == 1) ? Erase : Draw_wait;

			Erase: next_state = (finish_draw == 1) ? Load_new : Erase;
			//Erase_wait: next_state = Load_new ;

			Load_new: next_state = Draw;
			default: next_state = Start;
		endcase
	end
	
	always @(*)
		begin: signals
			en = 1'b0; 
			en_d = 1'b0;
			draw = 1'b0;
			plot = 1'b0;
			erase = 1'b0;
			
			case (current_state)
				Draw: begin
						en_d = 1'b1;
						draw = 1'b1;
						plot = 1'b1;
					end
				Draw_wait: en_d = 1'b1;
				Erase:begin
						//en_d = 1'b1;
						draw = 1'b1;
						plot = 1'b1;
						erase = 1'b1;
					end
				//Erase_wait : en_d = 1'b1;
				Load_new: en = 1'b1;
			endcase
		end
	
	always@(posedge clock)
	    begin: state_FFs
			if(!reset_n)
			    current_state <= Start;
			else
			    current_state <= next_state;
		end
endmodule


//-----------------------------------------------
//				Stair modules
//-----------------------------------------------
module stair_datapath(
	input reset_n, clock, en, draw, change,
	input [7:0] stair_in_x,
	input [6:0] stair_in_y,
	input erase,
	output  [7:0] stair_out_x,
	output  [6:0] stair_out_y,
	output  [2:0] stair_out_colour,
	output stair_finish_draw
);

	wire [6:0] stair_y;
	wire [7:0] stair_q_x;
	wire [6:0] stair_q_y;
	reg [2:0] colour;
	
	always @(posedge clock)
		begin: load
			if (!reset_n) 
				begin
					colour = 3'b000;
				end
			else
				begin
					if (erase)
						colour <= 3'b000;
					else
						colour <= 3'b100;
				end

		end

	stair_y_counter s_y_c0(clock, reset_n, en, stair_in_y, stair_y);
	stair_draw s_d0(clock, reset_n, draw, stair_in_x, stair_y, stair_finish_draw, stair_out_x, stair_out_y);
	
//	assign stair_out_x = stair_in_x + stair_q_x;
//	assign stair_out_y = stair_y + stair_q_y;
	assign stair_out_colour = colour;
endmodule


module stair_y_counter(
	input clock, reset_n, en,
	input [6:0] stair_in_y,
	output reg [6:0] stair_y		
);
	always @(negedge reset_n , posedge en)
		begin: stair_y_counter
			if (!reset_n)
				stair_y <= stair_in_y;
			else if (en == 1)
				begin
				if(stair_y == 7'd0)
					stair_y <= 7'd116;
					else
						stair_y <= stair_y - 1'b1;
				end
		end
endmodule


module stair_x(clock, reset_n, enable, q);
	input clock, reset_n, enable;
	output reg [7:0] q;
	
	always @(posedge clock)
	begin
	
		if (reset_n == 1'b0)
			q <= 8'd0;
		else if (enable == 1'b1)
		begin
			if (q == 8'd40)
				q <= 8'd0;
			else
				q <= q + 1'b1;
		end
	end
endmodule

module stair_y(clock, reset_n, enable, q);
	input clock, reset_n, enable;
	output reg [6:0] q;
	
	always @(posedge clock)
	begin
	
		if (reset_n == 1'b0)
			q <= 7'd0;
		else if (enable == 1'b1)
			begin
				if (q == 7'd5)
					q <= 7'd0;
				else
					q <= q + 1'b1;
			end
	end
endmodule

module stair_draw(
	input clock, reset_n, draw,
	input [7:0]input_x, 
	input [6:0]input_y,
	output stair_finish_draw,
	output [7:0] stair_out_x,
	output [6:0] stair_out_y
);

	wire [7:0] stair_wire_x;
	wire [6:0] stair_wire_y;
	wire enable_y;
	

	stair_x x0(clock, reset_n, draw, stair_wire_x);

	assign enable_y = (stair_wire_x == 8'd39) ? 1 : 0;

	stair_y y0(clock, reset_n, enable_y, stair_wire_y);

	assign stair_finish_draw = (stair_wire_y  == 7'd4 && stair_wire_x == 8'd39) ? 1 : 0;

	assign stair_out_x = input_x + stair_wire_x;
	assign stair_out_y = input_y + stair_wire_y;
	
endmodule






