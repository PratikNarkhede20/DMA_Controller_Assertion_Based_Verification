module dma_checker_sva(busInterface busIf);

`define SI 6'b000001;
`define SO 6'b000010;
`define S1 6'b000100;
`define S2 6'b001000;
`define S3 6'b010000;
`define S4 6'b100000;


default clocking c0 @(posedge busIf.CLK); endclocking

//cover for Data request
//DREQ0isOne_c : cover property (busIf.DREQ == 4'b0001);
//DREQ1isOne_c : cover property (busIf.DREQ == 4'b0010);
//DREQ2isOne_c : cover property (busIf.DREQ == 4'b0100);
//DREQ3isOne_c : cover property (busIf.DREQ == 4'b1000);

//cover for data acknowledgement
DACK0isOne_c : cover property (busIf.DACK == 4'b0001);
//DACK1isOne_c : cover property (busIf.DACK == 4'b0010);
//DACK2isOne_c : cover property (busIf.DACK == 4'b0100);
//DACK3isOne_c : cover property (busIf.DACK == 4'b1000);

//cover for input output read or write signal from timing and control
iorIsActive_c : cover property (busIf.IOR_N == 1'b0);
iowIsActive_c : cover property (busIf.IOW_N == 1'b0);

stateSO_c : cover property (dma.tC.state == `SO);



stateTransistion_a: assert property((busIf.CS_N && dma.tC.state == `SO) |=> (dma.tC.nextState == `S1) );

endmodule
