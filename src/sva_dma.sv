module dma_checker_sva(busInterface busIf);


default clocking c0 @(posedge busIf.CLK); endclocking

DREQ0isOne_c : cover property (busIf.DREQ == 4'b0001);
DREQ1isOne_c : cover property (busIf.DREQ == 4'b0010);
DREQ2isOne_c : cover property (busIf.DREQ == 4'b0100);
DREQ3isOne_c : cover property (busIf.DREQ == 4'b1000);

DACK0isOne_c : cover property (busIf.DACK == 4'b0001);
DACK1isOne_c : cover property (busIf.DACK == 4'b0010);
DACK2isOne_c : cover property (busIf.DACK == 4'b0100);
DACK3isOne_c : cover property (busIf.DACK == 4'b1000);

iorIsActive_c : cover property (busIf.IOR_N == 1'b0);
iowIsActive_c : cover property (busIf.IOW_N == 1'b0);


endmodule
