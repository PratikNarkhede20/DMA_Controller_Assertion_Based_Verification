# do qs_files/directives.tcl
netlist clock busIf.CLK -period 10
formal netlist constraint busIf.RESET 1'b0
# end do qs_files/directives.tcl
formal compile -d dma -cuname my_bind_sva -target_cover_statements
formal verify -init qs_files/myinit.init -timeout 5m
