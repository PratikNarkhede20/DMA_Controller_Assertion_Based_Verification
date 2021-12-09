
run: clean compile formal debug

reset: clean compileReset formalReset debug

eop: clean compileEOP formal debug

runb: clean compile formalBlackbox debug

compile:
	vlib work
	vmap work work
	vlog ./src/dmaRegConfigPkg.sv ./src/busInterface.sv ./src/dmaInternalRegistersIf.sv ./src/dmaInternalSignalsIf.sv ./src/timingAndControl.sv ./src/datapath.sv ./src/priorityLogic.sv ./src/dma.sv
	vlog -sv -mfcu -cuname my_bind_sva ./src/referenceModel.sv \
		./src/sva_bind.sv +define+Run ./src/sva_dma.sv

formal:
	qverify -c -od Output_Results -do "\
		do qs_files/directives.tcl; \
		formal compile -d dma -cuname my_bind_sva \
			-target_cover_statements; \
		formal verify -init qs_files/myinit.init \
		-timeout 5m; \
		exit"

debug:
	qverify Output_Results/formal_verify.db &

clean:
	qverify_clean
	\rm -rf work modelsim.ini *.wlf *.log replay* transcript *.db
	\rm -rf Output_Results *.tcl

compileEOP:
	vlib work
	vmap work work
	vlog ./src/dmaRegConfigPkg.sv ./src/busInterface.sv ./src/dmaInternalRegistersIf.sv ./src/dmaInternalSignalsIf.sv ./src/timingAndControl.sv ./src/datapath.sv ./src/priorityLogic.sv ./src/dma.sv
	vlog -sv -mfcu -cuname my_bind_sva ./src/referenceModel.sv \
		./src/sva_bind.sv +define+EOP ./src/sva_dma.sv

compileReset:
	vlib work
	vmap work work
	vlog ./src/dmaRegConfigPkg.sv ./src/busInterface.sv ./src/dmaInternalRegistersIf.sv ./src/dmaInternalSignalsIf.sv ./src/timingAndControl.sv ./src/datapath.sv ./src/priorityLogic.sv ./src/dma.sv
	vlog -sv -mfcu -cuname my_bind_sva \
		./src/sva_bind_reset.sv ./src/sva_dma_reset.sv

formalReset:
	qverify -c -od Output_Results -do "\
	  do qs_files/directivesReset.tcl; \
		formal compile -d dma -cuname my_bind_sva \
			-target_cover_statements; \
		formal verify -init qs_files/myinit.init \
		-timeout 5m; \
		exit"

formalBlackbox:
	qverify -c -od Output_Results -do "\
		do qs_files/directivesBlackbox.tcl; \
		formal compile -d dma -cuname my_bind_sva \
	  	-target_cover_statements; \
		formal verify -init qs_files/myinit.init \
		-timeout 5m; \
		exit"
