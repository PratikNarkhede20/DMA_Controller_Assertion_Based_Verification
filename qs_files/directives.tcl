# Define clocks
netlist clock busIf.CLK -period 10

# Constrain rst
#formal netlist constraint busIf.RESET 1'b0

#netlist cutpoint dma.d.ioDataBuffer
#formal netlist constraint dma.intRegIf.modeReg[0] 2'b01
#formal netlist constraint dma.intRegIf.modeReg[1] 2'b01
#formal netlist constraint dma.intRegIf.modeReg[2] 2'b01
#formal netlist constraint dma.intRegIf.modeReg[3] 2'b01

netlist blackbox priorityLogic
