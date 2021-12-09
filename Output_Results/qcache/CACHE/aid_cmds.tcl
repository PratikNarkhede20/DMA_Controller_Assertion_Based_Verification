# 
# Questa Static Verification System
# Version 10.7b linux_x86_64 12 Jun 2018

clear settings -all
clear directives
netlist clock busIf.CLK -period 10 
formal netlist constraint busIf.RESET 1'b0 
formal compile -d dma -cuname my_bind_sva -tcs
formal verify  -init  $env(SRC_ROOT)//u/pratik2/ECE560/DMA_Controller_Assertion_Based_Verification/qs_files/myinit.init -timeout 5m
