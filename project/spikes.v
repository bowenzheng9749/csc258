module spikes (clock, resetn, go, spike_out_x, spike_out_y, out_colour, plot);
	input clock, resetn, go;
	output [7:0] spike_out_x;
	output [7:0] spike_out_y;
	output [2:0] out_colour;
	output plot;
	
	wire draw;
	
	// Instansiate datapath
	datapath d0(
		.resetn(resetn),
		.clock(clock),
		.draw(draw),	
		.out_x(spike_out_x),
		.out_y(spike_out_y),
		.out_colour(out_colour)
	);

    // Instansiate FSM control
   control c0(
		.clock(clock),
		.resetn(resetn),
		.go(go),
		.draw(draw),
		.plot(plot)
		);
	
endmodule



module datapath(resetn, clock, draw, out_x, out_y, out_colour);

	input resetn, clock, draw;
	
	output  [7:0] out_x;
	output  [7:0] out_y;
	output  [2:0] out_colour;
	
	reg [7:0] q_x;
	reg [7:0] q_y;
	
	always @(posedge clock)
	begin: counter
		if (! resetn)
			begin
			q_x <= 8'b00000000;
			q_y <= 8'b00000000;
			end
		else if (draw)
			begin
				if (q_x == 8'b10100000)
					begin
					q_x <= 8'b00000000;
					q_y <= q_y + 1'b1;
					end
				else if (q_y == 8'b00010100)
					begin
					q_y <= 8'b00000000;
					q_x <= 8'b00000000;
					end
				else
					q_x <= q_x + 1'b1;

			end
	end
	
	assign out_x = q_x; 
	assign out_y = q_y; 
	assign out_colour = 3'b101;
	
endmodule

module control(clock, resetn, go, draw, plot);
	input resetn, clock, go;
	output reg draw, plot;

	reg [2:0] current_state, next_state;
	
	localparam Start = 3'd0,
				Draw = 3'd1;

	always @(*)
	begin: state_table
		case (current_state)
			Start: next_state = go ? Draw : Start;
			Draw: next_state = Draw;
			default: next_state = Start;
		endcase
	end
	
	always @(*)
	begin: signals
		draw = 1'b0;
		plot = 1'b0;
		
		case (current_state)
		Draw: begin
			draw = 1'b1;
			plot = 1'b1;
			end
		endcase
	end
	
always@(posedge clock)
    begin: state_FFs
        if(!resetn)
            current_state <= Start;
        else
            current_state <= next_state;
    end // state_FFS
endmodule
