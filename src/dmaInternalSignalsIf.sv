interface dmaInternalSignalsIf(input logic CLK, RESET);

  logic programCondition;
  logic loadAddr;

  logic assertDACK;
  logic deassertDACK;

  logic intEOP;
  logic updateCurrentWordCountReg;
  logic updateCurrentAddressReg;
  logic decrTemporaryWordCountReg;
  logic incrTemporaryAddressReg;

  modport timingAndControl(
    output assertDACK,
    output deassertDACK,
    output intEOP,
    output loadAddr,
    output programCondition,
    output updateCurrentWordCountReg,
    output updateCurrentAddressReg,
    output decrTemporaryWordCountReg,
    output incrTemporaryAddressReg
  );

  modport priorityLogic(
    input assertDACK,
    input deassertDACK
  );

  modport dataPath(
    input intEOP,
    input loadAddr,
    input programCondition,
    input updateCurrentWordCountReg,
    input updateCurrentAddressReg,
    input decrTemporaryWordCountReg,
    input incrTemporaryAddressReg
  );

endinterface
