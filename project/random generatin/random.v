module random (enable, clock, reset, out);

input clock, reset;
input enable;
output reg [7:0] out;


wire linear_feedback;

assign linear_feedback = out[7] ^ out[3] ^ out[2] ^ out[0]; 
always @(posedge clock, posedge enable)
begin
  if (!reset)
    out <= 8'hF;
  else if (enable)
    begin
      out <= {out[6:0], linear_feedback};
    end
  
end


endmodule