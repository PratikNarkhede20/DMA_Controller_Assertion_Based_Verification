module dma_checker_sva(busInterface busIf);


default clocking c0 @(posedge busIf.CLK); endclocking

DREQ0isOne_c : cover property (busIf.DREQ[0] == 1'b1);
DREQ1isOne_c : cover property (busIf.DREQ[1] == 1'b1);
DREQ2isOne_c : cover property (busIf.DREQ[2] == 1'b1);
DREQ3isOne_c : cover property (busIf.DREQ[3] == 1'b1);

DACK0isOne_c : cover property (busIf.DACK[0] == 1'b1);
DACK1isOne_c : cover property (busIf.DACK[1] == 1'b1);
DACK2isOne_c : cover property (busIf.DACK[2] == 1'b1);
DACK3isOne_c : cover property (busIf.DACK[3] == 1'b1);


endmodule
