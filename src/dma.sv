module dma(busInterface busIf);

  import dmaRegConfigPkg :: *; //wildcard parameter package import;

  dmaInternalRegistersIf intRegIf (busIf.CLK, busIf.RESET);

  dmaInternalSignalsIf intSigIf (busIf.CLK, busIf.RESET);

  priorityLogic pL ( busIf.priorityLogic, intRegIf.priorityLogic, intSigIf.priorityLogic );

  timingAndControl tC ( busIf.timingAndControl, intRegIf.timingAndControl, intSigIf.timingAndControl );

  datapath d ( busIf, intRegIf, intSigIf );


endmodule
