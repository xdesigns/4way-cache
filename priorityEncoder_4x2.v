module priorityEncoder_4x2(output reg[1:0] out, input[3:0] in);
	always @(in)
		begin
			casex(in)
				4'b1xxx : out=4'b11;
				4'b01xx : out=4'b10;
				4'b001x : out=4'b01;
				4'b0001 : out=4'b00;
			endcase
		end
endmodule
