#! /bin/bash 
/pkgs/mentor/questa_cdc_formal/10.7b/linux_x86_64/bin/qverifypm --monitor --host mo.ece.pdx.edu --port 45472 --wd /u/pratik2/ECE560/DMA_Controller_Assertion_Based_Verification --type slave --binary /pkgs/mentor/questa_cdc_formal/10.7b/linux_x86_64/bin/qverifyfk --id 3 -netcache /u/pratik2/ECE560/DMA_Controller_Assertion_Based_Verification/Output_Results/qcache/FORMAL/NET -od Output_Results -tool prove -init qs_files/myinit.init -timeout 5m -import_db Output_Results/formal_compile.db -slave_mode -mpiport 'mo.ece.pdx.edu:38663' -slave_id 2 
