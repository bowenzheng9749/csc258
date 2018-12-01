module random (enable, clock, reset, out);

input clock, reset;
input enable;
output [7:0] out;
reg [7:0] temp_out;


wire linear_feedback;

assign linear_feedback = temp_out[7] ^ temp_out[3] ^ temp_out[2] ^ temp_out[0]; 
always @(posedge clock)
begin
  if (!reset)
    temp_out <= 8'hF;
  else if (enable)
    begin
      temp_out <= {temp_out[6:0], linear_feedback};
    end
  
end
assign out = temp_out;


endmodule