/*Multiplexer that select the output from the aux array based on the
 8-bit address passed.*/

module tagMux_256x1(output reg[11:0]out,input[3071:0]inp,input [7:0]select);
	integer i;
	always @(inp or select)
	begin
		for (i=0;i<12;i=i+1)
			out[i]<=inp[select*12+i];
	end
endmodule
