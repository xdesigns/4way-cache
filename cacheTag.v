/*Valid bit + 11-bit Tag implemeted using D Flip Flops*/

module cacheTag(output[11:0]dataOut,input [11:0] dataIn,input WE,rst,clk);

	DFlipFlop auxEle[11:0] (dataOut,dataIn,WE,rst,clk);
	
endmodule

