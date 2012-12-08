/*A Byte of memory implemeted using D Flip Flops*/

module cacheByte(output[7:0] dataOut,input [7:0] dataIn,input WE,rst,clk);
	
	DFlipFlop byte[7:0] (dataOut,dataIn,WE,rst,clk);
	
endmodule
