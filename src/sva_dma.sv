module dma_checker_sva(busInterface busIf);


default clocking c0 @(posedge busIf.CLK); endclocking

DACK0isOne_c : cover property (busIf.DACK[0] == 1'b1);
DACK1isOne_c : cover property (busIf.DACK[1] == 1'b1);
DACK2isOne_c : cover property (busIf.DACK[2] == 1'b1);
DACK3isOne_c : cover property (busIf.DACK[3] == 1'b1);

endmodule
