module fifo_replacement(output[3:0] waySelect, input [3:0] validBits, input enable, 
															input[255:0] setSelected, input[7:0] addr, input rst);
	wire[255:0] setEnable;
	assign setEnable=setSelected & {256{enable}};
	
	wire[7:0] refBitsIn,refBitsOut;
	wire[2047:0] refWayOut;
	
	refBits refSets[255:0] (refWayOut,refBitsIn,setEnable,rst);
	
	refMux_256x1_8bit refMux_256x1(refBitsOut,refWayOut,addr);
	
	//Indicate which all blocks within the set are available for replacement
	wire[3:0] blockAvail;
	
	assign blockAvail={	((~refBitsOut[7] & ~refBitsOut[6]) | ~validBits[3]),
								((~refBitsOut[5] & ~refBitsOut[4]) | ~validBits[2]),
								((~refBitsOut[3] & ~refBitsOut[2]) | ~validBits[1]),
								((~refBitsOut[1] & ~refBitsOut[0]) | ~validBits[0])
							};
							
	//Prioritize the blocks within the set selected
	wire[1:0] priorityOut;
	priorityEncoder_4x2 refEncoder(priorityOut,blockAvail);
	wire[3:0] decoderOut;
	decoder_2x4 refDecoder(decoderOut,priorityOut);
	
	replacementWay repWay(waySelect,decoderOut,enable,rst);
		
	//Decremented Reference Values if valid Bit is set
	wire[7:0] decRefBits;
	
	assign decRefBits={	(refBitsOut[7] & (refBitsOut[6] | ~validBits[3])),
								((refBitsOut[7] & ~refBitsOut[6] & validBits[3]) | (~validBits[3] & refBitsOut[6])),
								(refBitsOut[5] & (refBitsOut[4] | ~validBits[2])),
								((refBitsOut[5] & ~refBitsOut[4] & validBits[2]) | (~validBits[2] & refBitsOut[4])),
								(refBitsOut[3] & (refBitsOut[2] | ~validBits[1])),
								((refBitsOut[3] & ~refBitsOut[2] & validBits[1]) | (~validBits[1] & refBitsOut[2])),
								(refBitsOut[1] & (refBitsOut[0] | ~validBits[0])),
								((refBitsOut[1] & ~refBitsOut[0] & validBits[0]) | (~validBits[0] & refBitsOut[0]))
						};
	
	
	refMux_2x1_2bit refMux_2x1_0(refBitsIn[1:0],{2'b11,decRefBits[1:0]},decoderOut[0]);
	refMux_2x1_2bit refMux_2x1_1(refBitsIn[3:2],{2'b11,decRefBits[3:2]},decoderOut[1]);
	refMux_2x1_2bit refMux_2x1_2(refBitsIn[5:4],{2'b11,decRefBits[5:4]},decoderOut[2]);
	refMux_2x1_2bit refMux_2x1_3(refBitsIn[7:6],{2'b11,decRefBits[7:6]},decoderOut[3]);
			
endmodule
