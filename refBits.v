//8 reference bits for each set
module refBits(output[7:0]dataOut,input [7:0] dataIn,input WE,rst);

	DFlipFlop refBit[7:0] (dataOut,dataIn,WE,rst,WE);
	
endmodule
