/*Array of valid(1)+tag(11) bits*/

module cacheAuxArray(output [11:0]dataOut,input [11:0]dataIn,input [255:0] setSelected,
																					input[7:0]addr,input WE,rst,clk);

	wire[255:0] eleWE;
	assign eleWE=setSelected & {256{WE}};
	wire[3071:0] eleOuts;
	
	tagMux_256x1 m(dataOut,eleOuts,addr);
	
	cacheTag tags[255:0] (eleOuts,dataIn,eleWE,rst,clk);
	
endmodule
