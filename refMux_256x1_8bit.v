module refMux_256x1_8bit(output reg[7:0] out,input[2047:0] inp,input[7:0] select);
   integer i;
	
	always @(inp or select)
	begin
		for (i=0;i<8;i=i+1)
			out[i]<=inp[select*8+i];
	end
				
endmodule
