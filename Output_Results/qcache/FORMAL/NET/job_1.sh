#! /bin/bash 
/pkgs/mentor/questa_cdc_formal/10.7b/linux_x86_64/bin/qverifypm --monitor --host mo.ece.pdx.edu --port 42228 --wd /u/pratik2/ECE560/DMA_Controller_Assertion_Based_Verification --type master --binary /pkgs/mentor/questa_cdc_formal/10.7b/linux_x86_64/bin/qverifyfk --id 1 -netcache /u/pratik2/ECE560/DMA_Controller_Assertion_Based_Verification/Output_Results/qcache/FORMAL/NET -od Output_Results -tool prove -j 4 -init qs_files/myinit.init -timeout 5m -import_db Output_Results/formal_compile.db -zdb /u/pratik2/ECE560/DMA_Controller_Assertion_Based_Verification/Output_Results/qcache/DB/zdb_0 -pm_host mo.ece.pdx.edu -pm_port 42228   
