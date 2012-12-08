//D Flip Flop implementation. Output is updated during positive
//edge of the clock cycle. Asynchronous reset input is active high.
//The flip flop is writable only when WE signal is active high.

 
module DFlipFlop(output reg Q,input D,WE,rst,clk);

	always @(posedge clk or posedge rst )
	begin
		if (rst)
			Q<=1'b0;
   	else if(WE)
			Q<=D;
 	end
 	
endmodule		

