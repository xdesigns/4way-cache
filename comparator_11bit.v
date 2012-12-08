//11-bit comparator used for comparing the tag bits
module comparator_11bit(output reg equals,input[10:0] data1,data2);

	always @(data1 or data2)
	begin
		if (data1==data2)
			equals=1'b1;
		else
			equals=1'b0;
	end	

endmodule
