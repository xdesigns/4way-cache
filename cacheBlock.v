/*A 16 byte cache block*/

module cacheBlock(output[7:0] dataOut,input[7:0] dataIn,input[3:0] byteAddr,input WE,rst,clk,enable);

	wire[15:0] byteWE;
	wire[127:0] blockOut;
	
	assign decoderEnable=WE & enable;
	
	decoder_4x16 d(byteWE,byteAddr,decoderEnable);
	byteMux_16x1 m(dataOut,blockOut,byteAddr,enable);
	
	cacheByte bytes[15:0] (blockOut,dataIn,byteWE,rst,clk);

endmodule
