module dma_checker_sva(busInterface busIf);
//`define Reset
//`define Run
`define SI 6'b000001
`define SO 6'b000010
`define S1 6'b000100
`define S2 6'b001000
`define S3 6'b010000
`define S4 6'b100000

parameter ADDRESSWIDTH = 16;
parameter DATAWIDTH = 8;
parameter CHANNELS = 4;

logic programCondition;
logic address;

default clocking c0 @(posedge busIf.CLK); endclocking
`ifdef Run
//assign address = busIf.A7,busIf.A6,busIf.A5,busIf.A4,busIf.A3,busIf.A2,busIf.A1,busIf.A0
assign programCondition = dma.intSigIf.programCondition;
referenceModel referenceModel(busIf.referenceModel, programCondition);
default disable iff (busIf.RESET);
`endif

`ifdef Run
CS_NisLow_assume : assume property (busIf.CS_N == 1'b0); //assume the DMA controller is always active
//HLDAisActive_assume : assume property (busIf.HLDA == 1'b1); //assume the DMA Controller always gets hold acknowledgement signal from CPU

EOP_NisHigh_assume : assume property (busIf.EOP_N == 1'b1);

/*
ReadOrWriteTransferType_assume : assume property ( ( (dma.intRegIf.modeReg[0].transferType == 2'b01) || (dma.intRegIf.modeReg[0].transferType == 2'b10) ) ||
											       											 ( (dma.intRegIf.modeReg[1].transferType == 2'b01) || (dma.intRegIf.modeReg[1].transferType == 2'b10) ) ||
											       							 				 ( (dma.intRegIf.modeReg[2].transferType == 2'b01) || (dma.intRegIf.modeReg[2].transferType == 2'b10) ) ||
											       											 ( (dma.intRegIf.modeReg[3].transferType == 2'b01) || (dma.intRegIf.modeReg[3].transferType == 2'b10) ) );
*/

/*singleTransferMode_assume : assume property (dma.intRegIf.modeReg[0].modeSelect == 2'b01 ||
											 dma.intRegIf.modeReg[1].modeSelect == 2'b01 ||
											 dma.intRegIf.modeReg[2].modeSelect == 2'b01 ||
											 dma.intRegIf.modeReg[3].modeSelect == 2'b01);*/

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

AENactive_c : cover property (##5 busIf.AEN == 1'b1); //cover for address enable signal
ADSTBactive_c : cover property (##5 busIf.ADSTB == 1'b1); ////cover for address strobe signal
HRQactive_c : cover property (##5 busIf.HRQ == 1'b1);//cover for hold request signal

//state machine covers
stateSI_c : cover property (##5 dma.tC.state == `SI);
stateSO_c : cover property (dma.tC.state == `SO);
stateS1_c : cover property (dma.tC.state == `S1);
stateS2_c : cover property (dma.tC.state == `S2);
stateS4_c : cover property (dma.tC.state == `S4);

stateTransistions_a : cover property ((dma.tC.state == `SI) ##10
																			(dma.tC.state == `SO) ##[1:10]
																			(dma.tC.state == `S1) ##1
																			(dma.tC.state == `S2) ##1
																			(dma.tC.state == `S4) ##1
																			(dma.tC.state == `SI));

//state machine assertions on chip select set to low
stateTransistionSItoSO_a : assert property ( ( !busIf.CS_N && (dma.tC.state == `SI) )
																							 |-> ##[0:$] (dma.tC.nextState == `SO)
																							 |=> (dma.tC.state == `SO) );

stateTransistionSOtoS1_a : assert property ( ( !busIf.CS_N && (dma.tC.state == `SO) && busIf.HLDA )
																							 |-> (dma.tC.nextState == `S1)
																							 |=> (dma.tC.state == `S1) );

stateTransistionS1toS2_a : assert property ( ( !busIf.CS_N && (dma.tC.state == `S1) )
																							 |-> (dma.tC.nextState == `S2)
																							 |=> (dma.tC.state == `S2) );

stateTransistionS2toS4_a : assert property ( ( !busIf.CS_N && (dma.tC.state == `S2) )
																							 |-> (dma.tC.nextState == `S4)
																							 |=> (dma.tC.state == `S4) );

stateTransistionS4toSI_a : assert property ( ( !busIf.CS_N && (dma.tC.state == `S4) )
																							 |-> (dma.tC.nextState == `SI)
																							 |=> (dma.tC.state == `SI) );
//|TCbusIf.DREQ && intSigIf.programCondition && configured
`endif

`ifdef EOP
stateTransistionSItoSIonEOP_a : assert property ( ##5 ( !busIf.EOP_N && (dma.tC.state == `SI) )
																												|-> (dma.tC.nextState == `SI)
																												|=> (dma.tC.state == `SI) );

stateTransistionSOtoSIonEOP_a : assert property ( ##5 ( !busIf.EOP_N && (dma.tC.state == `SO) )
																												|-> (dma.tC.nextState == `SI)
																												|=> (dma.tC.state == `SI) );

stateTransistionS1toSIonEOP_a : assert property ( ##5 ( !busIf.EOP_N && (dma.tC.state == `S1) )
																												|-> (dma.tC.nextState == `SI)
																												|=> (dma.tC.state == `SI) );

stateTransistionS2toSIonEOP_a : assert property ( ##5 ( !busIf.EOP_N && (dma.tC.state == `S2) )
																												|-> (dma.tC.nextState == `SI)
																												|=> (dma.tC.state == `SI) );

stateTransistionS4toSIonEOP_a : assert property ( ##5 ( !busIf.EOP_N && (dma.tC.state == `S2) )
																												|-> (dma.tC.nextState == `SI)
																												|=> (dma.tC.state == `SI) );
`endif

`ifdef Reset
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

ioAddressBufferZeroOnReset_a : assert property (busIf.RESET |=> (dma.d.ioAddressBuffer == '0'));

outputAddressBufferZeroOnReset_a : assert property (busIf.RESET |=> (dma.d.outputAddressBuffer == '0));

priorityOrderDefaultOnReset_a : assert property (busIf.RESET |=> dma.pL.priorityOrder == 8'b11_10_01_00); //default priority order

DACKisZeroOnReset_a : assert property (busIf.RESET |=> busIf.DACK == 4'b0000);
`endif

`ifdef Run
//assertions for priority logic

//doesn't compile. expected '=', expecting ++ or --. 2nd version of this is written furthur in the code
/*
property DACKforDREQfixedPriority1 (logic [3:0] inputDREQ);
	if (inputDREQ[0]) expectedDACK = 4'b0001;
	else if (inputDREQ[1]) expectedDACK = 4'b0010;
	else if (inputDREQ[2]) expectedDACK = 4'b0100;
	else if (inputDREQ[3]) expectedDACK = 4'b1000;
	else expectedDACK = 4'b0000;
  ( ( (busIf.DREQ == inputDREQ) &&  (!dma.intRegIf.commandReg.priorityType) ) |=> ##[0:$] (busIf.DACK == expectedDACK) );
endproperty
*/

/*
DREQ0000ToDACK0000_a : assert property ( DACKforDREQ(4'b0000, 4'b0000) );
DREQ0001ToDACK0001_a : assert property ( DACKforDREQ(4'b0001, 4'b0001) );
DREQ0010ToDACK0010_a : assert property ( DACKforDREQ(4'b0010, 4'b0010) );
DREQ0011ToDACK0001_a : assert property ( DACKforDREQ(4'b0011, 4'b0001) );
DREQ0100ToDACK0100_a : assert property ( DACKforDREQ(4'b0100, 4'b0100) );
DREQ0101ToDACK0001_a : assert property ( DACKforDREQ(4'b0101, 4'b0001) );
DREQ0110ToDACK0010_a : assert property ( DACKforDREQ(4'b0110, 4'b0010) );
DREQ0111ToDACK0001_a : assert property ( DACKforDREQ(4'b0111, 4'b0001) );
DREQ1000ToDACK1000_a : assert property ( DACKforDREQ(4'b1000, 4'b0100) );
DREQ1001ToDACK0001_a : assert property ( DACKforDREQ(4'b1001, 4'b0001) );
DREQ1010ToDACK0010_a : assert property ( DACKforDREQ(4'b1010, 4'b0010) );
DREQ1011ToDACK0001_a : assert property ( DACKforDREQ(4'b1011, 4'b0001) );
DREQ1100ToDACK0100_a : assert property ( DACKforDREQ(4'b1100, 4'b0100) );
DREQ1101ToDACK0001_a : assert property ( DACKforDREQ(4'b1101, 4'b0001) );
DREQ1110ToDACK0010_a : assert property ( DACKforDREQ(4'b1110, 4'b0010) );
DREQ1111ToDACK0001_a : assert property ( DACKforDREQ(4'b1111, 4'b0001) );
*/

//priorityType=1'b0 is fixed priority, priorityType=1'b1 is rotating priority
property DACKforDREQfixedPriority (logic [3:0] inputDREQ, expectedDACK);
  ( ( (busIf.DREQ == inputDREQ) &&  (!dma.intRegIf.commandReg.priorityType) ) |=> ##[0:$] (busIf.DACK == expectedDACK) );
endproperty

//exhaustive testing fixed priority logic. DREQ 0000 to 1111 as input
genvar i;
generate
  for(i=0; i<(2^CHANNELS); i=i+1)
   begin : g1
     if(i[0]==1'b1)
		 begin : DACK0001
			 DACK0001forDREQfixedPriority_a : assert property ( DACKforDREQfixedPriority (i, 4'b0001) );
			 DACK0001forDREQ_c : cover property (##3 (busIf.DREQ == i && !dma.intRegIf.commandReg.priorityType && busIf.DACK == 4'b0001) );
	   end

     else if(i[1]==1'b1)
		 begin : DACK0010
			 DACK0010forDREQfixedPriority_a : assert property ( DACKforDREQfixedPriority (i, 4'b0010) );
			 DACK0010forDREQ_c : cover property (##3 (busIf.DREQ == i && !dma.intRegIf.commandReg.priorityType && busIf.DACK == 4'b0010) );
		 end

     else if(i[2]==1'b1)
		 begin : DACK0100
			 DACK0100forDREQfixedPriority_a : assert property ( DACKforDREQfixedPriority (i, 4'b0100) );
			 DACK0100forDREQ_c : cover property (##3 (busIf.DREQ == i && !dma.intRegIf.commandReg.priorityType && busIf.DACK == 4'b0100) );
	   end

     else if(i[3]==1'b1)
		 begin : DACK1000
			 DACK1000forDREQfixedPriority_a : assert property ( DACKforDREQfixedPriority (i, 4'b1000) );
			 DACK1000forDREQ_c : cover property (##3 (busIf.DREQ == i && !dma.intRegIf.commandReg.priorityType && busIf.DACK == 4'b1000) );
		 end

     else
		 begin : DACK0000
			 DACK0000forDREQfixedPriority_a : assert property ( DACKforDREQfixedPriority (i, 4'b0000) );
			 DACK0000forDREQ_c : cover property (##3 (busIf.DREQ == i && !dma.intRegIf.commandReg.priorityType && busIf.DACK == 4'b0000) );
		 end
   end
endgenerate

//priorityType=1'b0 is fixed priority, priorityType=1'b1 is rotating priority
rotatingPriority_c : cover property ((busIf.DREQ == 4'b1111 && dma.intRegIf.commandReg.priorityType && busIf.DACK == 4'b0001) ##[1:$]
																		 (busIf.DREQ == 4'b1111 && dma.intRegIf.commandReg.priorityType && busIf.DACK == 4'b0010) ##[1:$]
																		 (busIf.DREQ == 4'b1111 && dma.intRegIf.commandReg.priorityType && busIf.DACK == 4'b0100) ##[1:$]
																		 (busIf.DREQ == 4'b1111 && dma.intRegIf.commandReg.priorityType && busIf.DACK == 4'b1000));
//this below code is for exhaustive testcases for DREQ in generate block. there are few errors which we are still trying to figure out.
//the compile errors are due to tool not able to process local variables in assertions.
/*
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
//loadIoDataBufferFromDB_a : assert property ( ##2 referenceModel.loadIoDataBufferFromDB |=> (dma.d.ioDataBuffer == $past(busIf.DB)));
property loadIoDataBufferFromDB;
	int expectedIoDataBuffer;
	##3 (referenceModel.loadIoDataBufferFromDB, expectedIoDataBuffer = busIf.DB)
	|=> (dma.d.ioDataBuffer == expectedIoDataBuffer)
endproperty
loadIoDataBufferFromDB_a : assert property ( loadIoDataBufferFromDB );

//readIoDataBuffer_a : assert property (##4 (!busIf.CS_N & !busIf.IOR_N) |-> (dma.d.ioDataBuffer == busIf.DB));

//loadCommandReg_a : assert property (##7 referenceModel.loadCommandReg |=> (dma.intRegIf.commandReg == $past(dma.d.ioDataBuffer) ) );
property loadCommandReg;
	int expectedIoDataBuffer;
	##7 (referenceModel.loadCommandReg, expectedIoDataBuffer = dma.d.ioDataBuffer)
	|=> (dma.intRegIf.commandReg == expectedIoDataBuffer)
endproperty
loadCommandReg_a : assert property ( loadCommandReg );

//loadModeReg_a : assert property (##8 referenceModel.loadModeReg |=> (dma.intRegIf.modeReg[$past(dma.d.ioDataBuffer[1:0])] == $past(dma.d.ioDataBuffer[7:2])));
readStatusReg_a : assert property (##10 referenceModel.readStatusReg |=> (dma.d.ioDataBuffer == $past(dma.intRegIf.statusReg)));
internalFFzero_a : assert property (##5 (referenceModel.clearInternalFF & !dma.d.enUpperAddress) |=> (dma.d.internalFF == 1'b0));
internalFFone_a : assert property (##6 (!referenceModel.clearInternalFF & dma.d.enUpperAddress) |=> (dma.d.internalFF == 1'b1));

//loadWriteBuffer_a : assert property (##5 (referenceModel.loadCommandReg & referenceModel.loadBaseAddressReg & referenceModel.loadBaseWordCountReg)|=> (dma.d.writeBuffer == $past(dma.d.ioDataBuffer)));
property loadWriteBuffer;
	int expectedIoDataBuffer;
	##5 ( (referenceModel.loadCommandReg & referenceModel.loadBaseAddressReg & referenceModel.loadBaseWordCountReg), expectedIoDataBuffer = dma.d.writeBuffer)
	|=> (dma.d.writeBuffer == expectedIoDataBuffer);
endproperty
loadWriteBuffer_a : assert property ( loadWriteBuffer );

baseAddressShouldNotChange_a : assert property ( !$changed(dma.d.baseAddressReg[0]) || !$changed(dma.d.baseAddressReg[1]) || !$changed(dma.d.baseAddressReg[2]) || !$changed(dma.d.baseAddressReg[3]) );
baseWordCountShouldNotChange_a : assert property ( !$changed(dma.d.baseWordCountReg[0]) || !$changed(dma.d.baseWordCountReg[1]) || !$changed(dma.d.baseWordCountReg[2]) || !$changed(dma.d.baseWordCountReg[3]) );

singleRegConfigInProgramMode_a : assert property (referenceModel.regConfigInProgress |-> referenceModel.regConfigOneHot);

addressEnable_a : assert property ( ##2 ( |busIf.DREQ && $rose(busIf.HLDA) && (dma.tC.state == `SO) ) |=> $rose(busIf.AEN) );
addressStrobeActiveForTwoCycles_a : assert property ($rose(busIf.AEN) |=> ##1 $fell(busIf.AEN));

addressStrobeActive_a : assert property ( ##2 ( |busIf.DREQ && $rose(busIf.HLDA) && (dma.tC.state == `SO)) |=> $rose(busIf.ADSTB) );
addressStrobeActiveforOneCycle_a : assert property ( $rose(busIf.ADSTB) |=> $fell(busIf.ADSTB) );

addressBusValid_a : assert property (busIf.ADSTB |-> !$isunknown({busIf.A7,busIf.A6,busIf.A5,busIf.A4,busIf.A3,busIf.A2,busIf.A1,busIf.A0}));
dataBusValid_a : assert property ((busIf.ADSTB & busIf.AEN) |-> !$isunknown(busIf.DB));

noReadWriteAtSameTime_a : assert property (not(!busIf.IOW_N && !busIf.IOR_N));
addressValidOnReadWrite_a : assert property( ((busIf.IOW_N && !busIf.IOR_N) || (!busIf.IOW_N && busIf.IOR_N)) |-> !$isunknown(referenceModel.address) );
dataValidOnReadWrite_a : assert property ( (!busIf.IOW_N || !busIf.IOR_N) |-> !$isunknown(busIf.DB) );

//validReadWriteSignalsOnHLDA_a : assert property ( ( !$isunknown(busIf.IOR_N) && !$isunknown(busIf.IOW_N) ) throughout busIf.HLDA[*]);
//validAddressBusOnHLDA_a : assert property ( !$isunknown({busIf.A7,busIf.A6,busIf.A5,busIf.A4,busIf.A3,busIf.A2,busIf.A1,busIf.A0}) throughout busIf.HLDA[*] );

validReadWriteSignalsOnHLDA_a : assert property ( ##5 busIf.HLDA |-> ( !$isunknown(busIf.IOR_N) && !$isunknown(busIf.IOW_N) ) );
validAddressBusOnHLDA_a : assert property ( ##5 busIf.HLDA |-> !$isunknown(referenceModel.address) );

//loadBaseUpperAddress_a : assert property ( (referenceModel.loadBaseAddressReg && dma.d.internalFF)
//																						|=> ( dma.d.baseAddressReg[{$past(busIf.A2), $past(busIf.A1)}] [15:8] == $past(dma.d.writeBuffer) ) );
//loadBaseLowerAddress_a : assert property ( (referenceModel.loadBaseAddressReg && !dma.d.internalFF)
//																						|=> ( dma.d.baseAddressReg[{$past(busIf.A2), $past(busIf.A1)}] [7:0] == $past(dma.d.writeBuffer) ) );

property loadBaseUpperAddress;
	int channel, expectedWriteBuffer;
	( (referenceModel.loadBaseAddressReg && dma.d.internalFF), channel = {busIf.A2, busIf.A1}, expectedWriteBuffer = dma.d.writeBuffer )
	|=> ( dma.d.baseAddressReg[channel] [(ADDRESSWIDTH-1) : (ADDRESSWIDTH/2)] == expectedWriteBuffer )
endproperty
loadBaseUpperAddress_a : assert property ( loadBaseUpperAddress );

property loadBaseLowerAddress;
	int channel, expectedWriteBuffer;
	( (referenceModel.loadBaseAddressReg && !dma.d.internalFF), channel = {busIf.A2, busIf.A1}, expectedWriteBuffer = dma.d.writeBuffer )
	|=> ( dma.d.baseAddressReg[channel] [7:0] == expectedWriteBuffer )
endproperty
loadBaseLowerAddress_a : assert property ( loadBaseLowerAddress );

//loadCurrentUpperAddress_a : assert property ( (referenceModel.loadBaseAddressReg && dma.d.internalFF)
//																							|=> ( dma.d.currentAddressReg[{$past(busIf.A2), $past(busIf.A1)}] [15:8] == $past(dma.d.writeBuffer) ) );
//loadCurrentLowerAddress_a : assert property ( (referenceModel.loadBaseAddressReg && !dma.d.internalFF)
//																							|=> ( dma.d.currentAddressReg[{$past(busIf.A2), $past(busIf.A1)}] [7:0] == $past(dma.d.writeBuffer) ) );

property loadCurrentUpperAddress;
	int channel, expectedWriteBuffer;
	( (referenceModel.loadBaseAddressReg && dma.d.internalFF), channel = {busIf.A2, busIf.A1}, expectedWriteBuffer = dma.d.writeBuffer )
	|=> ( dma.d.currentAddressReg[channel] [(ADDRESSWIDTH-1) : (ADDRESSWIDTH/2)] == expectedWriteBuffer )
endproperty
loadCurrentUpperAddress_a : assert property ( loadCurrentUpperAddress );

property loadCurrentLowerAddress;
	int channel, expectedWriteBuffer;
	( (referenceModel.loadBaseAddressReg && !dma.d.internalFF), channel = {busIf.A2, busIf.A1}, expectedWriteBuffer = dma.d.writeBuffer )
	|=> ( dma.d.currentAddressReg[channel] [((ADDRESSWIDTH/2)-1) : 0] == expectedWriteBuffer )
endproperty
loadCurrentLowerAddress_a : assert property ( loadCurrentLowerAddress );

//loadBaseUpperWordCount_a : assert property ( (referenceModel.loadBaseWordCountReg && dma.d.internalFF)
//																						 |=> ( dma.d.baseWordCountReg[{$past(busIf.A2), $past(busIf.A1)}] [15:8] == $past(dma.d.writeBuffer) ) );
//loadBaseLowerWordCount_a : assert property ( (referenceModel.loadBaseWordCountReg && !dma.d.internalFF)
//																						 |=> ( dma.d.baseWordCountReg[{$past(busIf.A2), $past(busIf.A1)}] [7:0] == $past(dma.d.writeBuffer) ) );

property loadBaseUpperWordCount;
	int channel, expectedWriteBuffer;
	( (referenceModel.loadBaseWordCountReg && dma.d.internalFF), channel = {busIf.A2, busIf.A1}, expectedWriteBuffer = dma.d.writeBuffer )
	|=> ( dma.d.baseWordCountReg[channel] [(ADDRESSWIDTH-1) : (ADDRESSWIDTH/2)] == expectedWriteBuffer )
endproperty
loadBaseUpperWordCount_a : assert property ( loadBaseUpperWordCount );

property loadBaseLowerWordCount;
	int channel, expectedWriteBuffer;
	( (referenceModel.loadBaseWordCountReg && !dma.d.internalFF), channel = {busIf.A2, busIf.A1}, expectedWriteBuffer = dma.d.writeBuffer )
	|=> ( dma.d.baseWordCountReg[channel] [((ADDRESSWIDTH/2)-1) : 0] == expectedWriteBuffer )
endproperty
loadBaseLowerWordCount_a : assert property ( loadBaseLowerWordCount );

//loadCurrentUpperWordCount_a : assert property ( (referenceModel.loadBaseWordCountReg && dma.d.internalFF)
//																						 		|=> ( dma.d.currentWordCountReg[{$past(busIf.A2), $past(busIf.A1)}] [15:8] == $past(dma.d.writeBuffer) ) );
//loadCurrentLowerWordCount_a : assert property ( (referenceModel.loadBaseWordCountReg && !dma.d.internalFF)
//																						 		|=> ( dma.d.currentWordCountReg[{$past(busIf.A2), $past(busIf.A1)}] [7:0] == $past(dma.d.writeBuffer) ) );

property loadCurrentUpperWordCount;
	int channel, expectedWriteBuffer;
	( (referenceModel.loadBaseWordCountReg && dma.d.internalFF), channel = {busIf.A2, busIf.A1}, expectedWriteBuffer = dma.d.writeBuffer )
	|=> ( dma.d.currentWordCountReg[channel] [(ADDRESSWIDTH-1) : (ADDRESSWIDTH/2)] == expectedWriteBuffer )
endproperty
loadCurrentUpperWordCount_a : assert property ( loadCurrentUpperWordCount );

property loadCurrentLowerWordCount;
	int channel, expectedWriteBuffer;
	( (referenceModel.loadBaseWordCountReg && !dma.d.internalFF), channel = {busIf.A2, busIf.A1}, expectedWriteBuffer = dma.d.writeBuffer )
	|=> ( dma.d.currentWordCountReg[channel] [((ADDRESSWIDTH/2)-1) : 0] == expectedWriteBuffer )
endproperty
loadCurrentLowerWordCount_a : assert property ( loadCurrentLowerWordCount );

//readCurrentUpperAddress_a : assert property ( (referenceModel.readCurrentAddressReg && dma.d.internalFF)
//																						 	|=> ( dma.d.currentAddressReg[{$past(busIf.A2), $past(busIf.A1)}] [15:8] == dma.d.readBuffer) );
//readCurrentLowerAddress_a : assert property ( (referenceModel.readCurrentAddressReg && !dma.d.internalFF)
//																						 	|=> ( dma.d.currentAddressReg[{$past(busIf.A2), $past(busIf.A1)}] [7:0] == dma.d.readBuffer) );

property readCurrentUpperAddress;
	int channel;
	( (referenceModel.readCurrentAddressReg && dma.d.internalFF), channel = {busIf.A2, busIf.A1} )
	|=> ( dma.d.currentAddressReg[channel] [(ADDRESSWIDTH-1) : (ADDRESSWIDTH/2)] == dma.d.readBuffer )
endproperty
readCurrentUpperAddress_a : assert property ( readCurrentUpperAddress );

property readCurrentLowerAddress;
	int channel;
	( (referenceModel.readCurrentAddressReg && !dma.d.internalFF), channel = {busIf.A2, busIf.A1} )
	|=> ( dma.d.currentAddressReg[channel] [((ADDRESSWIDTH/2)-1) : 0] == dma.d.readBuffer )
endproperty
readCurrentLowerAddress_a : assert property ( readCurrentLowerAddress );

//readCurrentUpperWordCount_a : assert property ( (referenceModel.readCurrentWordCountReg && dma.d.internalFF)
//																						 		|=> ( dma.d.currentWordCountReg[{$past(busIf.A2), $past(busIf.A1)}] [15:8] == dma.d.readBuffer) );
//readCurrentLowerWordCount_a : assert property ( (referenceModel.readCurrentWordCountReg && !dma.d.internalFF)
//																								|=> ( dma.d.currentWordCountReg[{$past(busIf.A2), $past(busIf.A1)}] [7:0] == dma.d.readBuffer) );

property readCurrentUpperWordCount;
	int channel;
	( (referenceModel.readCurrentWordCountReg && dma.d.internalFF), channel = {busIf.A2, busIf.A1} )
	|=> ( dma.d.currentAddressReg[channel] [(ADDRESSWIDTH-1) : (ADDRESSWIDTH/2)] == dma.d.readBuffer )
endproperty
readCurrentUpperWordCount_a : assert property ( readCurrentUpperWordCount );

property readCurrentLowerWordCount;
	int channel;
	( (referenceModel.readCurrentWordCountReg && !dma.d.internalFF), channel = {busIf.A2, busIf.A1} )
	|=> ( dma.d.currentAddressReg[channel] [((ADDRESSWIDTH/2)-1) : 0] == dma.d.readBuffer )
endproperty
readCurrentLowerWordCount_a : assert property ( readCurrentLowerWordCount );

`endif

endmodule
