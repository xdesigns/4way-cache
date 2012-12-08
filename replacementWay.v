module replacementWay(output[3:0]dataOut,input [3:0] dataIn,input WE,rst);
	DFlipFlop repWay[3:0] (dataOut,dataIn,WE,rst,WE);
endmodule
