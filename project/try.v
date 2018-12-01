
//----------------------------------------
//				Combined   
//----------------------------------------
module combined(resetn, go, sclock, clock, writeEn, x, y, colour, current_state, next_state);
	input resetn, go, sclock, clock;
	output writeEn;
	output [7:0] x;
	output [6:0] y;
	output [2:0] colour;
	output [2:0] current_state, next_state;

	wire finish_draw;
	wire erase;

	wire en, en_d, draw;
	wire frame_en, change;

	stair_datapath sd0(resetn, clsock , en, draw, change, 8'd60, 7'd40, erase, x, y, colour, finish_draw);

	control c0(resetn, clock, go, change, finish_draw,  en, en_d, draw, writeEn, erase, current_state ,next_state);

	
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
				//delay <= 20'd833_334;
				delay <= 20'd5;
			else if (en_d == 1'b1)
				begin
					if (delay == 0)
						delay <= 20'd833_334;
						//delay <= 20'd5;
					else
						delay <= delay - 1'b1;
				end
		end
		assign frame_en = (delay == 20'd0) ? 1 : 0;
endmodule

module frame_counter(
	input clock, reset_n, frame_en,
	output change
);	
	reg [3:0] frame;

	always @(posedge clock)
		begin: frame_counter
			if (!reset_n)
				frame <= 4'd0;
			else if (frame_en == 1'b1)
				begin
					if (frame == 4'd14)
					//if (frame == 6'd4)
						frame <= 4'd0;
					else
						frame <= frame + 1'b1;
				end
		end
		assign change = (frame == 4'd14) ? 1 : 0;
		
endmodule



//----------------------------------------
//					FSM     
//----------------------------------------
module control(
	input reset_n, clock, go, change, finish_draw, 
	output reg en, en_d, draw, plot, erase,
	output reg [2:0] current_state, next_state
	
);

	//reg [2:0] next_state;

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
						//en_d = 1'b1;
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
			if (q == 8'd39)
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
				if (q == 7'd4)
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






