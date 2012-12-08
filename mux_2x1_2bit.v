module refMux_2x1_2bit(output reg[1:0] muxOut, input [3:0] muxIn, input select);

	always @(muxIn or select)
	begin
		case(select)
			1'b0 : muxOut=muxIn[1:0];
			1'b1 : muxOut=muxIn[3:2];
		endcase

	end

endmodule
