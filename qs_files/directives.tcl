# Define clocks
netlist clock busIf.CLK -period 10

# Constrain rst
formal netlist constraint busIf.RESET 1'b0
