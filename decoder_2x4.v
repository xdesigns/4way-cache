module decoder_2x4(output reg[3:0] out,input[1:0] select);

	always @(select)
	begin
		case(select)
			2'b11: out=4'b1000;
			2'b10: out=4'b0100;
			2'b01: out=4'b0010;
			2'b00: out=4'b0001;
		endcase
	end
		

endmodule
