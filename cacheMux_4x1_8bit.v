module cacheMux_4x1_8bit(output reg[7:0] muxOut, input [31:0] muxIn, input[1:0] select);
	always @(muxIn or select)
	begin
		case(select)
			2'b00 : muxOut=muxIn[7:0];
			2'b01 : muxOut=muxIn[15:8];
			2'b10 : muxOut=muxIn[23:16];
			2'b11 : muxOut=muxIn[31:24];
		endcase

	end
endmodule
