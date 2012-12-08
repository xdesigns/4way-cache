//8x256 decoder
module decoder_8x256(output reg[255:0]out,input [7:0]select);
	integer i;
	always @(select)
	begin
		out=256'b0;
		out[select]=1'b1;
	end
endmodule
