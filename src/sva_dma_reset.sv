module dma_checker_sva_reset(busInterface busIf);

`define SI 6'b000001
`define SO 6'b000010
`define S1 6'b000100
`define S2 6'b001000
`define S3 6'b010000
`define S4 6'b100000

default clocking c0 @(posedge busIf.CLK); endclocking

//assertions on signals/registers on reset
stateTransistionOnReset_a : assert property (busIf.RESET |=> (dma.tC.state == `SI) );

commandRegZeroOnReset_a : assert property (busIf.RESET |=> (dma.intRegIf.commandReg == '0) );

statusRegZeroOnReset_a : assert property (busIf.RESET |=> (dma.intRegIf.statusReg == '0) );

modeRegZeroOnReset_a : assert property (busIf.RESET |=> ( (dma.intRegIf.modeReg[0] == '0) &&
																													(dma.intRegIf.modeReg[1] == '0) &&
																													(dma.intRegIf.modeReg[2] == '0) &&
																													(dma.intRegIf.modeReg[3] == '0) ) );
//modeRegZeroOnReset_a : assert property (busIf.RESET |=> ( for (int i=0; i<CHANNELS;i=i+1) dma.intRegIf.modeReg[i] == '0 ) ); //doesn't compile

writeBufferZeroOnReset_a : assert property (busIf.RESET |=> (dma.d.writeBuffer == '0));

readBufferZeroOnReset_a : assert property (busIf.RESET |=> (dma.d.readBuffer == '0));

baseAddressRegZeroOnReset_a : assert property (busIf.RESET |=> ( (dma.d.baseAddressReg[0] == '0) &&
																																 (dma.d.baseAddressReg[1] == '0) &&
																																 (dma.d.baseAddressReg[2] == '0) &&
																																 (dma.d.baseAddressReg[3] == '0) ) );
//baseAddressRegZeroOnReset_a :  assert property (busIf.RESET |=> ( for (int i=0; i<CHANNELS;i=i+1) dma.d.baseAddressReg[i] == '0 ) ); //doesn't compile

currentAddressRegZeroOnReset_a : assert property (busIf.RESET |=> ( (dma.d.currentAddressReg[0] == '0) &&
																																		(dma.d.currentAddressReg[1] == '0) &&
																																		(dma.d.currentAddressReg[2] == '0) &&
																																		(dma.d.currentAddressReg[3] == '0) ) );
//currentAddressRegZeroOnReset_a : assert property (busIf.RESET |=> ( for (int i=0; i<CHANNELS;i=i+1) dma.d.currentAddressReg[i] == '0 ) ); //doesn't compile

baseWordCountRegZeroOnReset_a : assert property (busIf.RESET |=> ( (dma.d.baseWordCountReg[0] == '0) &&
																																	 (dma.d.baseWordCountReg[1] == '0) &&
																																	 (dma.d.baseWordCountReg[2] == '0) &&
																																	 (dma.d.baseWordCountReg[3] == '0) ) );
//baseWordCountRegZeroOnReset_a : assert property (busIf.RESET |=> ( for (int i=0; i<CHANNELS;i=i+1) (dma.d.baseWordCountReg[i] == '0) ) ); //doesn't compile

currentWordCountRegZeroOnReset_a : assert property (busIf.RESET |=> ( (dma.d.currentWordCountReg[0] == '0) &&
																																			(dma.d.currentWordCountReg[1] == '0) &&
																																			(dma.d.currentWordCountReg[2] == '0) &&
																																			(dma.d.currentWordCountReg[3] == '0) ) );
//currentWordCountRegZeroOnReset_a : assert property (busIf.RESET |=> ( for (int i=0; i<CHANNELS;i=i+1) (dma.d.currentWordCountReg[i] == '0) ) ); //doesn't compile

tempAddressRegZeroOnReset_a : assert property (busIf.RESET |=> (dma.intRegIf.temporaryAddressReg == '0));

tempWordCountRegZeroOnReset_a : assert property (busIf.RESET |=> (dma.intRegIf.temporaryWordCountReg == '0));

internalFFzeroOnReset_a : assert property (busIf.RESET |=> (dma.d.internalFF == 1'b0));

ioAddressBufferZeroOnReset_a : assert property (busIf.RESET |=> (dma.d.ioAddressBuffer == '0));

outputAddressBufferZeroOnReset_a : assert property (busIf.RESET |=> (dma.d.outputAddressBuffer == '0));

priorityOrderDefaultOnReset_a : assert property (busIf.RESET |=> dma.pL.priorityOrder == 8'b11_10_01_00); //default priority order

DACKisZeroOnReset_a : assert property (busIf.RESET |=> busIf.DACK == 4'b0000);

endmodule
