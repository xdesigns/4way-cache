/*Multiplexer that select the block output from a way based on the
 8-bit address passed.*/

module blockMux_256x1(output reg[7:0] out,input[2047:0] inp,input[7:0] select,input enable);
	integer i;
	
	always @(inp or select or enable)
	begin
		if (enable)
		begin
			for (i=0;i<8;i=i+1)
				out[i]<=inp[select*8+i];
		end
	end
	
endmodule
