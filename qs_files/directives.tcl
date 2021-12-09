# Define clocks
netlist clock busIf.CLK -period 10

# Constrain rst
formal netlist constraint busIf.RESET 1'b1


#cutpoint for ioDataBuffer
#netlist cutpoint dma.d.ioDataBuffer


#cutpoint for read
#netlist cutpoint busIf.IOR_N

#cutpoint for write
#netlist cutpoint busIf.IOW_N
