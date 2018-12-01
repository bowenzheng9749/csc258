module rand (
    input give_random,
    input clock,
    input reset,
    output [7:0] rnd 
    );

reg [7:0] random, random_next, random_done;

wire feedback = random[7] ^ random[3] ^ random[2] ^ random[0]; 
 


 
always @ (posedge clock)
begin
 if (!reset)
 begin
  random <= 8'hF; 

 end
  
 else
 begin
  random <= random_next;
  count <= count_next;
 end
end
 
always @ (*)
begin
 random_next = random; //default state stays the same
 count_next = count;
   
  random_next = {random[6:0], feedback}; //shift left the xor'd every posedge clock
  count_next = count + 1;
 
 if (give_random)
 begin
  count = 0;
  random_done = random; //assign the random number to output
 end
end

assign rnd = random_done;

endmodule
 