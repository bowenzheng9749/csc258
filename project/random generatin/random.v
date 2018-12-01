module random (enable, clock, reset, out);

input clock, reset;
input enable;
output reg [7:0] out;


wire linear_feedback;

assign linear_feedback = random[7] ^ random[3] ^ random[2] ^ random[0]; 
always @(posedge clock)
begin
  if (!reset)
    out <= 8'hF;
  else if (enable)
    begin
      out <= {out[6:0], linear_feedback};
    end
end


endmodule