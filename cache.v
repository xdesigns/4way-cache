//This is the main cache module. The outputs and inputs are
//dataOut 		: The byte output from the cache
//memAddr 		: 16-bit address of the memory byte read during cache read miss
//memWrite 		: Asserted when memory write is performed
//memRead 		: Asserted when memory read is performed
//validMemData : Asserted when valid memory data is available in the dataIn input
//dataIn			: Byte input to the cache
//byteAddr		: 23-bit address of the byte accessed
//validBit		: Used to validate or invalidate the byte at the address
//WE				: Asserted when cache write is to be performed
//rst				: Clears all the memory elements
//clk				: External clock


module cache(output [7:0]dataOut, output [15:0]memAddr, output memWrite, memRead, input validMemData,
							input[7:0] dataIn, input [22:0] byteAddr, input validBit, input WE, rst, clk);
			
	//Address of the byte accessed.
	wire [22:0] addr;
	
	//The set selected amongst the 256 available sets.
	wire[255:0] setSelected;
	decoder_8x256 decoder(setSelected,addr[11:4]);
		
	//The last 16 bits of the byte address since the memory is 64K.
	assign memAddr=addr[15:0];	
	
	
	//Indicate whether any tag has matched with the tag part of the address.
	wire tagMatch;
	
	//Indicate whether cache hit has occured.
	wire cacheHit;
	
	//Whether to use FIFO replacement algorithm.
	wire enableRefDec;
	
	//Implementation for reading a block on cache read miss.
	wire memBlockRead;
	wire initBlockRead;
	wire memReadFinish;
	wire[3:0] byteRead;
	wire countInc;
	
	assign countInc=memBlockRead & validMemData;
		
	upCounter_5bit cacheCounter({memReadFinish,byteRead},countInc,~memBlockRead,rst);
	
	assign memRead=memBlockRead & ~validMemData;
	
	assign initBlockRead=(~tagMatch & ~WE) | memReadFinish; 

	DFlipFlop blockReadReg(memBlockRead,~memReadFinish,{1'b1},rst,initBlockRead);
	
	//Write through write no-allocate
	assign memWrite=(~cacheHit & WE);
	
	assign cacheHit=tagMatch & ~memBlockRead;
	
	
	//Indicate whether to write enable the cache.
	wire cacheWE;
	assign cacheWE=(cacheHit & WE)|(~cacheHit & ~WE);
	
	assign enableRefDec=(~cacheHit & ~WE);
	
	assign addr[22:4]=byteAddr[22:4];
	cacheMux_2x1_4bit cacheAddrMux(addr[3:0],{byteRead,byteAddr[3:0]},enableRefDec);
	
	//The 4x12 bits of outputs from the auxilary array for a given address.
	wire[47:0] arrOuts;
	
	//Indicates which way is selected for replacement by FIFO.
	wire [3:0] replacementWay;
	
	fifo_replacement fr(replacementWay,{arrOuts[47],arrOuts[35],arrOuts[23],arrOuts[11]},enableRefDec,
																									setSelected,addr[11:4],rst);
	
	//Indicate which all auxilary arrays to write enable
	wire[3:0] auxWE;
	assign auxWE=replacementWay & enableRefDec;
	
	//4 auxilary arrays for the 4 ways
	cacheAuxArray auxArrays_0 (arrOuts[11:0],{validBit,addr[22:12]},setSelected,addr[11:4],auxWE[0],rst,clk);
	cacheAuxArray auxArrays_1 (arrOuts[23:12],{validBit,addr[22:12]},setSelected,addr[11:4],auxWE[1],rst,clk);
	cacheAuxArray auxArrays_2 (arrOuts[35:24],{validBit,addr[22:12]},setSelected,addr[11:4],auxWE[2],rst,clk);
	cacheAuxArray auxArrays_3 (arrOuts[47:36],{validBit,addr[22:12]},setSelected,addr[11:4],auxWE[3],rst,clk);
	
	//The outputs from the comparator
	wire[3:0] compareResults;

	comparator_11bit c0 (compareResults[0],arrOuts[10:0],addr[22:12]);
	comparator_11bit c1 (compareResults[1],arrOuts[22:12],addr[22:12]);
	comparator_11bit c2 (compareResults[2],arrOuts[34:24],addr[22:12]);
	comparator_11bit c3 (compareResults[3],arrOuts[46:36],addr[22:12]);
	
	//'And'ing of comparator results and the valid bit
	wire[3:0] hitBlock;
	assign hitBlock[0]=compareResults[0] & arrOuts[11];
	assign hitBlock[1]=compareResults[1] & arrOuts[23];
	assign hitBlock[2]=compareResults[2] & arrOuts[35];
	assign hitBlock[3]=compareResults[3] & arrOuts[47];
	
	assign tagMatch=(hitBlock[0] | hitBlock[1] | hitBlock[2] | hitBlock[3]);
	
	//4x8 bits of data outputs from the selected cache blocks
	wire[31:0] wayOuts;
	
	//Indicate which all ways to enable. Disabled ways are considered
	//to be in sleep state.
	wire[3:0] wayEnable;
	
	//4 ways used in the cache
	cacheWay ways[3:0] (wayOuts,dataIn,setSelected,addr[11:0],cacheWE,rst,clk,wayEnable);
	
	wire[1:0] priorityOut;
	priorityEncoder_4x2 cachePriEncoder(priorityOut,hitBlock);
	wire [3:0] hitWaySelect;
	decoder_2x4 cacheWayDecoder(hitWaySelect,priorityOut);
	
	cacheMux_2x1_4bit cacheWayMux(wayEnable,{hitWaySelect,replacementWay},cacheHit);
	cacheMux_4x1_8bit cacheDataMux(dataOut,wayOuts,priorityOut);

endmodule
