module dma_checker_sva(busInterface busIf);

`define SI 6'b000001
`define SO 6'b000010
`define S1 6'b000100
`define S2 6'b001000
`define S3 6'b010000
`define S4 6'b100000


default clocking c0 @(posedge busIf.CLK); endclocking

//assume the DMA controller is always active
CS_NisLow_assume : assume property (busIf.CS_N == 1'b0);
HLDAisActive_assume : assume property (busIf.HLDA == 1'b1);

//cover for Data request
//DREQ0isOne_c : cover property (busIf.DREQ == 4'b0001);
//DREQ1isOne_c : cover property (busIf.DREQ == 4'b0010);
//DREQ2isOne_c : cover property (busIf.DREQ == 4'b0100);
//DREQ3isOne_c : cover property (busIf.DREQ == 4'b1000);

//cover for data acknowledgement
DACK0isOne_c : cover property (busIf.DACK == 4'b0001);
DACK1isOne_c : cover property (busIf.DACK == 4'b0010);
DACK2isOne_c : cover property (busIf.DACK == 4'b0100);
DACK3isOne_c : cover property (busIf.DACK == 4'b1000);

//cover for input output read or write signal from timing and control
ioRead_c : cover property (busIf.IOR_N == 1'b0);
ioWrite_c : cover property (busIf.IOW_N == 1'b0);
memoryRead_c : cover property (busIf.MEMR_N == 1'b0);
memoryWrite_c : cover property (busIf.MEMW_N == 1'b0);

AENactive_c : cover property (busIf.AEN == 1'b1);
ADSTBactive_c : cover property (busIf.ADSTB == 1'b1);
HRQactive_c : cover property (busIf.HRQ == 1'b1);

stateSI_c : cover property (dma.tC.state == `SI);
stateSO_c : cover property (dma.tC.state == `SO);
stateS1_c : cover property (dma.tC.state == `S1);
stateS2_c : cover property (dma.tC.state == `S2);
stateS4_c : cover property (dma.tC.state == `S4);

stateTransistionSItoSO_a : assert property( disable iff (busIf.RESET) ( !busIf.CS_N && (dma.tC.state == `SI) ) |-> (dma.tC.nextState == `SO) );
stateTransistionSOtoS1_a : assert property( disable iff (busIf.RESET) ( !busIf.CS_N && (dma.tC.state == `SO) ) |-> (dma.tC.nextState == `S1) );
stateTransistionS1toS2_a : assert property( disable iff (busIf.RESET) ( !busIf.CS_N && (dma.tC.state == `S1) ) |-> (dma.tC.nextState == `S2) );
stateTransistionS2toS4_a : assert property( disable iff (busIf.RESET) ( !busIf.CS_N && (dma.tC.state == `S2) ) |-> (dma.tC.nextState == `S4) );
stateTransistionS4toSI_a : assert property( disable iff (busIf.RESET) ( !busIf.CS_N && (dma.tC.state == `S4) ) |-> (dma.tC.nextState == `SI) );

//|TCbusIf.DREQ && intSigIf.programCondition && configured

//resetHigh_assume : assume property (busIf.RESET == 1'b1);
stateTransistionOnReset_a : assert property (busIf.RESET |=> (dma.tC.state == `SI) );
commandRegZeroOnReset_a : assert property (busIf.RESET |=> (dma.intRegIf.commandReg == '0) );
statusRegZeroOnReset_a : assert property (busIf.RESET |=> (dma.intRegIf.statusReg == '0) );
modeRegZeroOnReset_a : assert property ( busIf.RESET |=> ( (dma.intRegIf.modeReg[0] == '0) && (dma.intRegIf.modeReg[1] == '0) && (dma.intRegIf.modeReg[2] == '0) && (dma.intRegIf.modeReg[3] == '0) ) );
writeBufferZeroOnReset_a : assert property (busIf.RESET |=> (dma.d.writeBuffer == '0));
readBufferZeroOnReset_a : assert property (busIf.RESET |=> (dma.d.readBuffer == '0));
baseAddressRegZeroOnReset_a : assert property ( busIf.RESET |=> ( (dma.d.baseAddressReg[0] == '0) && (dma.d.baseAddressReg[1] == '0) && (dma.d.baseAddressReg[2] == '0) && (dma.d.baseAddressReg[3] == '0) ) );
currentAddressRegZeroOnReset_a : assert property ( busIf.RESET |=> ( (dma.d.currentAddressReg[0] == '0) && (dma.d.currentAddressReg[1] == '0) && (dma.d.currentAddressReg[2] == '0) && (dma.d.currentAddressReg[3] == '0) ) );
baseWordCountRegZeroOnReset_a : assert property ( busIf.RESET |=> ( (dma.d.baseWordCountReg[0] == '0) && (dma.d.baseWordCountReg[1] == '0) && (dma.d.baseWordCountReg[2] == '0) && (dma.d.baseWordCountReg[3] == '0) ) );
currentWordCountRegZeroOnReset_a : assert property ( busIf.RESET |=> ( (dma.d.currentWordCountReg[0] == '0) && (dma.d.currentWordCountReg[1] == '0) && (dma.d.currentWordCountReg[2] == '0) && (dma.d.currentWordCountReg[3] == '0) ) );
tempAddressRegZeroOnReset_a : assert property (busIf.RESET |=> (dma.intRegIf.temporaryAddressReg == '0));
tempWordCountRegZeroOnReset_a : assert property (busIf.RESET |=> (dma.intRegIf.temporaryWordCountReg == '0));
internalFFzeroOnReset_a : assert property (busIf.RESET |=> (dma.d.internalFF == 1'b0));
outputAddressBufferZeroOnReset_a : assert property (busIf.RESET |=> (dma.d.outputAddressBuffer == '0));


endmodule
