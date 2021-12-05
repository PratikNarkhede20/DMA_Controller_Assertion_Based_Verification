module referenceModel(busInterface.referenceModel busIf, programCondition);

  input programCondition;
  logic loadCommandReg;
  logic loadModeReg;
  logic loadBaseAddressReg;
  logic readCurrentAddressReg;
  logic ldBaseWordCountReg;
  logic readCurrentWordCountReg;
  logic readStatusReg;
  logic clearInternalFF;

  always_comb
    begin
      //Register Code for writing Command Register is CS_N=0, IOR_N=1, IOW_N=0, A3=1, A2=0 , A1=0 , A0=0.
      loadCommandReg = (programCondition & !busIf.CS_N & busIf.IOR_N & !busIf.IOW_N & busIf.A3 & !busIf.A2 & !busIf.A1 & !busIf.A0) ? 1'b1 : 1'b0;

      //Register Code for writing Mode Register is CS_N=0, IOR_N=1, IOW_N=0, A3=1, A2=0 , A1=1 , A0=1.
      loadModeReg = (programCondition & !busIf.CS_N & busIf.IOR_N & !busIf.IOW_N & busIf.A3 & !busIf.A2 & busIf.A1 & busIf.A0) ? 1'b1 : 1'b0;

      //Register Code for writing Base Address Register is CS_N=0, IOR_N=1, IOW_N=0, A3=0, A0=0. A2, A1 decides the channel. For channel0 A2=0, A1=0. For channel1 A2=0, A1=1. For channel2 A2=1, A1=0. For channel3 A2=1, A1=1
      loadBaseAddressReg = (programCondition & !busIf.CS_N & busIf.IOR_N & !busIf.IOW_N & !busIf.A3 & !busIf.A0 & {busIf.A2, busIf.A1} inside {2'b00, 2'b01, 2'b10, 2'b11}) ? 1'b1 : 1'b0;

      //Register Code for reading Current Address Register is CS_N=0, IOR_N=0, IOW_N=1, A3=0, A0=0. A2, A1 decides the channel. For channel0 A2=0, A1=0. For channel1 A2=0, A1=1. For channel2 A2=1, A1=0. For channel3 A2=1, A1=1
      readCurrentAddressReg = (programCondition & !busIf.CS_N & !busIf.IOR_N & busIf.IOW_N & !busIf.A3 & !busIf.A0 & {busIf.A2, busIf.A1} inside {2'b00, 2'b01, 2'b10, 2'b11}) ? 1'b1 : 1'b0;

      //Register Code for writing Base Word Count Register is CS_N=0, IOR_N=1, IOW_N=0, A3=0, A0=1. A2, A1 decides the channel. For channel0 A2=0, A1=0. For channel1 A2=0, A1=1. For channel2 A2=1, A1=0. For channel3 A2=1, A1=1
      ldBaseWordCountReg = (programCondition & !busIf.CS_N & busIf.IOR_N & !busIf.IOW_N & !busIf.A3 & busIf.A0 & {busIf.A2, busIf.A1} inside {2'b00, 2'b01, 2'b10, 2'b11}) ? 1'b1 : 1'b0;

      //Register Code for reading Current Word Count Register is CS_N=0, IOR_N=0, IOW_N=1, A3=0, A0=1. A2, A1 decides the channel. For channel0 A2=0, A1=0. For channel1 A2=0, A1=1. For channel2 A2=1, A1=0. For channel3 A2=1, A1=1
      readCurrentWordCountReg = (programCondition & !busIf.CS_N & !busIf.IOR_N & busIf.IOW_N & !busIf.A3 & busIf.A0 & {busIf.A2, busIf.A1} inside {2'b00, 2'b01, 2'b10, 2'b11}) ? 1'b1 : 1'b0;

      //Register Code for reading Status Register is CS_N=0, IOR_N=0, IOW_N=1, A3=1, A2=0 , A1=0 , A0=0.
      readStatusReg = (programCondition & !busIf.CS_N & !busIf.IOR_N & busIf.IOW_N & busIf.A3 & !busIf.A2 & !busIf.A1 & !busIf.A0) ? 1'b1 : 1'b0;

      //Register Code for clearing Internal Flip Flop is CS_N=0, IOR_N=1, IOW_N=0, A3=1, A2=1 , A1=0 , A0=0
      clearInternalFF = (programCondition & !busIf.CS_N & busIf.IOR_N & !busIf.IOW_N & busIf.A3 & busIf.A2 & !busIf.A1 & !busIf.A0) ? 1'b1 : 1'b0;
    end

endmodule