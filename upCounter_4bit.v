//5 bit up counter used in reading a memory block on cache read miss.
//rst1 and rst2 are reset pins.
module upCounter_5bit(output reg[4:0] out,input doInc,input rst1, rst2);
	always @(posedge rst1 or posedge rst2 or posedge doInc)
	begin
		if (rst1)
			out=5'b00000;
		else if(rst2)
			out=5'b00000;
		else if(doInc)
			out=out+1;
	end
endmodule
