module stairs (clock, in_x, in_y, reset_n, colour, go, out_x, out_y, out_colour, plot);
	input clock, reset_n, go;

	input [2:0] colour;
	input [7:0] in_x;
	input [6:0] in_y;
	output [7:0] out_x;
	output [6:0] out_y;
	output [2:0] out_colour;
	output plot;
	
	wire  en, en_d, down, select_colour, draw, change, finish_draw;
	
	// Instansiate datapath
	datapath d0(
		.reset_n(reset_n),
		.clock(clock),
		.in_x(in_x),
		.in_y(in_y),
		.colour(colour),
		.en(en),
		.en_d(en_d),
		.down(down),
		.select_colour(select_colour),
		.draw(draw),
		
		.out_x(out_x),
		.out_y(out_y),
		.out_colour(out_colour),
		.change(change),
		.finish_draw(finish_draw)
	);

    // Instansiate FSM control
   control c0(
		.clock(clock),
		.reset_n(reset_n),
		.go(go),
		
		.change(change),
		.finish_draw(finish_draw),
		.out_x(out_x),
		.out_y(out_y),
		
		.en(en),
		.en_d(en_d),
		.down(down),
		.select_colour(select_colour),
		.draw(draw),
		.plot(plot)
		);
	
endmodule

module datapath(colour, in_x, in_y, reset_n, clock, draw, en, en_d, select_colour, out_x, out_y, out_colour, change, finish_draw);
	input [2:0] colour;
	input reset_n, clock;
	input en, en_d, select_colour, draw;
	input [7:0] in_x;
	input [6:0] in_y;
	
	output reg finish_draw;
	output  [7:0] out_x;
	output  [6:0] out_y;
	output reg [2:0] out_colour;
	output change;
	
	reg [6:0] y;
	reg [3:0] q_x, q_y, frame;
	reg [19:0] delay;
	wire frame_en;
	
	always @(posedge clock)
	begin: load
		if (!reset_n) begin
			out_colour = 3'b111;
			end
		else 
			begin
				if (select_colour)
					out_colour = 3'b111;
				else
					out_colour = colour;
			end
	end
	
	always @(posedge clock)
	begin: delay_counter
		if (!reset_n)
			delay <= 20'd833_333;
		else if (en_d == 1'b1)
			begin
				if (delay == 0)
					delay <= 20'd833_333;
				else
					delay <= delay - 1'b1;
			end
		else
			delay <= delay;
	end
	
	assign frame_en = (delay == 20'd0) ? 1 : 0;
	
	always @(posedge clock)
	begin: frame_counter
		if (!reset_n)
			frame <= 4'b0000;
		else if (frame_en == 1'b1)
			begin
				if (frame == 4'd14)
					frame <= 4'd0;
				else
					frame <= frame + 1'b1;
			end
		else
			frame <= frame;
	end
	
	assign change = (frame == 4'd14) ? 1 : 0;
	
	
	always @(posedge clock)
	begin: y_counter
		if (!reset_n)
			y <= in_y;
		else if (en == 1'b1)
			begin
				y <= y - 1'b1;
			end
		else
			y <= y;
	end

	always @(posedge clock)
	begin: counter
		if (! reset_n) begin
			q_x <= 6'b000000;
			q_y <= 4'b0000;
			finish_draw <= 1'b0;
			end
		else if (draw)
			begin
				if (q_x == 6'b100111) 
				begin
					q_x <= 6'b000000;
					q_y <= q_y + 1'b1;
				end
				else if (q_y == 4'b1001) 
				begin
					q_x <= 6'b000000;
					q_y <= 4'b0000;
					finish_draw <= 1'b1;
				end
				else 
				begin
					q_x <= q_x + 1'b1;
					finish_draw <= 1'b0;
				end
			end
	end
	
	assign out_x = in_x + q_x;
	assign out_y = y + q_y;
	
endmodule

module control(clock, reset_n, go, change, finish_draw, out_x, out_y, en, en_d, select_colour, draw, plot);
	input reset_n, clock, go, change, finish_draw, out_x, out_y;
	output reg en, en_d, select_colour, draw, plot;

	reg [2:0] current_state, next_state;
	
	localparam Start = 3'd0,
					Draw = 3'd1,
					Erase= 3'd2,
					New_y = 3'd3;
					

	always @(*)
	begin: state_table
		case (current_state)
			Start: next_state = go ? Draw : Start;
			Draw: next_state = change ?  Erase: Draw;
			Erase: next_state = finish_draw ? New_y : Erase;
			New_y: next_state = Draw;
			default: next_state = Start;
		endcase
	end
	
	always @(*)
	begin: signals
		en = 1'b0; 
		en_d = 1'b0;
		select_colour = 1'b0;
		draw = 1'b0;
		plot = 1'b0;
		
		case (current_state)
		Start: begin
			en_d = 1'b1;
			end
		Draw: begin 
			select_colour = 1'b0;
			draw = 1'b1;
			plot = 1'b1;
			end
		Erase: begin
			select_colour = 1'b1;
			draw = 1'b1;
			plot = 1'b1;
			end
		New_y : 
			en = 1'b1;
	end
	
always@(posedge clock)
    begin: state_FFs
        if(!reset_n)
            current_state <= Start;
        else
            current_state <= next_state;
    end // state_FFS
endmodule
