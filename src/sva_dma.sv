module dma_checker_sva(busInterface busIf);
//`define Reset
//`define Run
`define SI 6'b000001
`define SO 6'b000010
`define S1 6'b000100
`define S2 6'b001000
`define S3 6'b010000
`define S4 6'b100000

logic programCondition;

default clocking c0 @(posedge busIf.CLK); endclocking
`ifdef Run
assign programCondition = dma.intSigIf.programCondition;
referenceModel referenceModel(busIf.referenceModel, programCondition);
default disable iff (busIf.RESET);
`endif

`ifdef Run
CS_NisLow_assume : assume property (busIf.CS_N == 1'b0); //assume the DMA controller is always active
HLDAisActive_assume : assume property (busIf.HLDA == 1'b1); //assume the DMA Controller always gets hold acknowledgement signal from CPU

//cover for data acknowledgement. check if inidividual channels are working
DACK0isOne_c : cover property (busIf.DACK == 4'b0001);
DACK1isOne_c : cover property (busIf.DACK == 4'b0010);
DACK2isOne_c : cover property (busIf.DACK == 4'b0100);
DACK3isOne_c : cover property (busIf.DACK == 4'b1000);

//cover for input output read or write OR memory read or write signals
ioRead_c : cover property (##5 busIf.IOR_N == 1'b0);
ioWrite_c : cover property (##10 busIf.IOW_N == 1'b0);
memoryRead_c : cover property (##5 busIf.MEMR_N == 1'b0);
memoryWrite_c : cover property (##10 busIf.MEMW_N == 1'b0);

AENactive_c : cover property (busIf.AEN == 1'b1); //cover for address enable signal
ADSTBactive_c : cover property (busIf.ADSTB == 1'b1); ////cover for address strobe signal
HRQactive_c : cover property (busIf.HRQ == 1'b1);//cover for hold request signal

//state machine covers
stateSI_c : cover property (##5 dma.tC.state == `SI);
stateSO_c : cover property (dma.tC.state == `SO);
stateS1_c : cover property (dma.tC.state == `S1);
stateS2_c : cover property (dma.tC.state == `S2);
stateS4_c : cover property (dma.tC.state == `S4);
stateTransistions_a : cover property ((dma.tC.state == `SI) ##10 (dma.tC.state == `SO) ##1 (dma.tC.state == `S1) ##1 (dma.tC.state == `S2) ##1 (dma.tC.state == `S4) ##1 (dma.tC.state == `SI));

//state machine assertions
stateTransistionSItoSO_a : assert property ( ( !busIf.CS_N && (dma.tC.state == `SI) ) |-> ##[0:$] (dma.tC.nextState == `SO) );
stateTransistionSOtoS1_a : assert property ( ( !busIf.CS_N && (dma.tC.state == `SO) ) |-> (dma.tC.nextState == `S1) );
stateTransistionS1toS2_a : assert property ( ( !busIf.CS_N && (dma.tC.state == `S1) ) |-> (dma.tC.nextState == `S2) );
stateTransistionS2toS4_a : assert property ( ( !busIf.CS_N && (dma.tC.state == `S2) ) |-> (dma.tC.nextState == `S4) );
stateTransistionS4toSI_a : assert property ( ( !busIf.CS_N && (dma.tC.state == `S4) ) |-> (dma.tC.nextState == `SI) );
//|TCbusIf.DREQ && intSigIf.programCondition && configured
`endif


`ifdef Reset
//assertions are signals/registers on reset
stateTransistionOnReset_a : assert property (busIf.RESET |=> (dma.tC.state == `SI) );
commandRegZeroOnReset_a : assert property (busIf.RESET |=> (dma.intRegIf.commandReg == '0) );
statusRegZeroOnReset_a : assert property (busIf.RESET |=> (dma.intRegIf.statusReg == '0) );
modeRegZeroOnReset_a : assert property (busIf.RESET |=> ( (dma.intRegIf.modeReg[0] == '0) && (dma.intRegIf.modeReg[1] == '0) && (dma.intRegIf.modeReg[2] == '0) && (dma.intRegIf.modeReg[3] == '0) ) );
writeBufferZeroOnReset_a : assert property (busIf.RESET |=> (dma.d.writeBuffer == '0));
readBufferZeroOnReset_a : assert property (busIf.RESET |=> (dma.d.readBuffer == '0));
baseAddressRegZeroOnReset_a : assert property (busIf.RESET |=> ( (dma.d.baseAddressReg[0] == '0) && (dma.d.baseAddressReg[1] == '0) && (dma.d.baseAddressReg[2] == '0) && (dma.d.baseAddressReg[3] == '0) ) );
currentAddressRegZeroOnReset_a : assert property (busIf.RESET |=> ( (dma.d.currentAddressReg[0] == '0) && (dma.d.currentAddressReg[1] == '0) && (dma.d.currentAddressReg[2] == '0) && (dma.d.currentAddressReg[3] == '0) ) );
baseWordCountRegZeroOnReset_a : assert property (busIf.RESET |=> ( (dma.d.baseWordCountReg[0] == '0) && (dma.d.baseWordCountReg[1] == '0) && (dma.d.baseWordCountReg[2] == '0) && (dma.d.baseWordCountReg[3] == '0) ) );
currentWordCountRegZeroOnReset_a : assert property (busIf.RESET |=> ( (dma.d.currentWordCountReg[0] == '0) && (dma.d.currentWordCountReg[1] == '0) && (dma.d.currentWordCountReg[2] == '0) && (dma.d.currentWordCountReg[3] == '0) ) );
tempAddressRegZeroOnReset_a : assert property (busIf.RESET |=> (dma.intRegIf.temporaryAddressReg == '0));
tempWordCountRegZeroOnReset_a : assert property (busIf.RESET |=> (dma.intRegIf.temporaryWordCountReg == '0));
internalFFzeroOnReset_a : assert property (busIf.RESET |=> (dma.d.internalFF == 1'b0));
outputAddressBufferZeroOnReset_a : assert property (busIf.RESET |=> (dma.d.outputAddressBuffer == '0));
priorityOrderDefaultOnReset_a : assert property (busIf.RESET |=> dma.pL.priorityOrder == 8'b11_10_01_00);
DACKisZeroOnReset_a : assert property (busIf.RESET |=> busIf.DACK == 4'b0000);
`endif

/*baseAddressRegZeroOnReset_a1 : assert property (int i; (busIf.RESET) |=> ( for(i=0;i<4;i=i+1)
                                                                            dma.d.baseAddressReg[i] == '0
                                                                         ) );*/
//busIf.RESET == 1'b0;

`ifdef Run
//assertions for priority logic
DREQ0011ToDACK0001_a : assert property ( ( (busIf.DREQ == 4'b0011) &&  (!dma.intRegIf.commandReg.priorityType) ) |=> ##[0:$] (busIf.DACK == 4'b0001) );
DREQ0111ToDACK0001_a : assert property ( ( (busIf.DREQ == 4'b0111) &&  (!dma.intRegIf.commandReg.priorityType) ) |=> ##[0:$] (busIf.DACK == 4'b0001) );
DREQ1111ToDACK0001_a : assert property ( ( (busIf.DREQ == 4'b1111) &&  (!dma.intRegIf.commandReg.priorityType) ) |=> ##[0:$] (busIf.DACK == 4'b0001) );
DREQ1110ToDACK0010_a : assert property ( ( (busIf.DREQ == 4'b1110) &&  (!dma.intRegIf.commandReg.priorityType) ) |=> ##[0:$] (busIf.DACK == 4'b0010) );
//&&  (!dma.intRegIf.commandReg.priorityType) && (dma.intSigIf.assertDACK)

//this below code is for exhaustive testcases for DREQ in generate block. there are few errors which we are still trying to figure out.
/*
property DACKforDREQ (inputDREQ, expectedDACK);
  logic [3:0] inputDREQ, expectedDACK;
  disable iff (busIf.RESET)
  ( ( (busIf.DREQ == inputDREQ) &&  (!dma.intRegIf.commandReg.priorityType) ) |=> ##[0:$] (busIf.DACK == expectedDACK) );
endproperty

genvar i;
generate
  for(i=0; i<16; i=i+1)
   begin
     inputDREQ = i;
     if(inputDREQ[0]==1'b1) expectedDACK = 4'b0001;
     else if(inputDREQ[1]==1'b1) expectedDACK = 4'b0010;
     else if(inputDREQ[2]==1'b1) expectedDACK = 4'b0100;
     else if(inputDREQ[3]==1'b1) expectedDACK = 4'b1000;
     else expectedDACK = 4'b0000;
     DACKforDREQfixedPriority_a : assert DACKforDREQ (inputDREQ, expectedDACK);
   end
  end
endgenerate
*/

//working on these assertions
loadIoDataBufferFromDB_a : assert property ( ( !busIf.CS_N & !busIf.IOW_N & !dma.intSigIf.loadAddr & !(referenceModel.readStatusReg  | referenceModel.readCurrentAddressReg | referenceModel.readCurrentWordCountReg) )  |=> (dma.d.ioDataBuffer == $past(busIf.DB)));
//readIoDataBuffer_a : assert property (##4 (!busIf.CS_N & !busIf.IOR_N) |-> (dma.d.ioDataBuffer == busIf.DB));
loadCommandReg_a : assert property (##7 referenceModel.loadCommandReg |=> (dma.intRegIf.commandReg == $past(dma.d.ioDataBuffer) ) );
loadModeReg_a : assert property (##8 referenceModel.loadModeReg |=> (dma.intRegIf.modeReg[$past(dma.d.ioDataBuffer[1:0])] == $past(dma.d.ioDataBuffer[7:2])));
readStatusReg_a : assert property (##10 referenceModel.readStatusReg |=> (dma.d.ioDataBuffer == $past(dma.intRegIf.statusReg)));
`endif

endmodule
