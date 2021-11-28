module dma_checker_sva(busInterface busIf);

`define SI 6'b000001
`define SO 6'b000010
`define S1 6'b000100
`define S2 6'b001000
`define S3 6'b010000
`define S4 6'b100000


default clocking c0 @(posedge busIf.CLK); endclocking

//assume the DMA controller is always active
CS_NisLow_a : assume property (busIf.CS_N == 1'b0);

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

stateTransistionSItoSO_a: assert property( ( !busIf.CS_N && (dma.tC.state == `SI) ) |-> (dma.tC.nextState == `SO) );
stateTransistionSOtoS1_a: assert property( ( !busIf.CS_N && (dma.tC.state == `SO) ) |-> (dma.tC.nextState == `S1) );
stateTransistionS1toS2_a: assert property( ( !busIf.CS_N && (dma.tC.state == `S1) ) |-> (dma.tC.nextState == `S2) );
stateTransistionS2toS4_a: assert property( ( !busIf.CS_N && (dma.tC.state == `S2) ) |-> (dma.tC.nextState == `S4) );
stateTransistionS4toSI_a: assert property( ( !busIf.CS_N && (dma.tC.state == `S4) ) |-> (dma.tC.nextState == `SI) );

endmodule
