/*Multiplexer that select the byte output from the block based on the
 4-bit address passed.*/

module byteMux_16x1(output reg[7:0] out,input[127:0] inp,input[3:0] select,input enable);
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
