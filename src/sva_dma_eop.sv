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


default clocking c0 @(posedge busIf.CLK); endclocking

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

endmodule
