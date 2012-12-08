/*A 256 block cache way*/
module cacheWay(output[7:0] dataOut,input[7:0] dataIn,input [255:0] setSelected,
																		input[11:0] addr,input WE,rst,clk,enable);
	
	wire[255:0] blockWE;
	assign blockWE=setSelected & {256{WE}} & {256{enable}};
	
	wire[2047:0] wayOuts;

	blockMux_256x1 m(dataOut,wayOuts,addr[11:4],enable);
	
	cacheBlock blocks[255:0] (wayOuts,dataIn,addr[3:0],blockWE,rst,clk,enable);

endmodule
