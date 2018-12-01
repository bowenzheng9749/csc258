module random (enable, clock, reset, out);

input clock, reset;
input enable;
output reg [7:0] out;


wire linear_feedback;

assign linear_feedback = !(out[7] ^ out[3]);

always @(posedge clock)
begin
  if (!reset)
    out <= 8'b01101011;
  else if (enable)
    begin
      out <= {out[6],out[5],out[4],out[3],out[2],out[1],out[0],linear_feedback};
    end
end


endmodule