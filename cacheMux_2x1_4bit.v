module cacheMux_2x1_4bit(output reg[3:0] muxOut, input [7:0] muxIn, input select);
	always @(muxIn or select)
	begin
		case(select)
			1'b0 : muxOut=muxIn[3:0];
			1'b1 : muxOut=muxIn[7:4];
		endcase

	end
endmodule
