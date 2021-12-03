module priorityLogic(busInterface.priorityLogic busIf, dmaInternalRegistersIf.priorityLogic intRegIf, dmaInternalSignalsIf.priorityLogic intSigIf);

  logic [3:0][1:0] priorityOrderTemp, priorityOrder = 8'b11_10_01_00;

  always_comb
    begin

      //commandReg.priorityType=0 is Fixed Priority. commandReg.priorityType=1 is Rotating Priority
      busIf.DACK = 4'b0000;

      //Fixed Priority
      priorityOrderTemp = priorityOrder;

      if(!intRegIf.commandReg.priorityType && intSigIf.assertDACK)
        begin
          priority case(1'b1)
            busIf.DREQ[0] : busIf.DACK = 4'b0001 << 0;
            busIf.DREQ[1] : busIf.DACK = 4'b0001 << 1;
            busIf.DREQ[2] : busIf.DACK = 4'b0001 << 2;
            busIf.DREQ[3] : busIf.DACK = 4'b0001 << 3;
          endcase
        end

      //Rotating Priority
      else if(intRegIf.commandReg.priorityType && intSigIf.assertDACK)
        begin
          priority case(1'b1)

            busIf.DREQ[priorityOrder[0]]:
              begin
                busIf.DACK = 4'b0001 << priorityOrder[0];
                priorityOrderTemp = {priorityOrder[0], priorityOrder[3:1]};
              end

            busIf.DREQ[priorityOrder[1]]:
              begin
                busIf.DACK = 4'b0001 << priorityOrder[1];
                priorityOrderTemp = {priorityOrder[1:0], priorityOrder[3:2]};
              end

            busIf.DREQ[priorityOrder[2]]:
              begin
                busIf.DACK = 4'b0001 << priorityOrder[2];
                priorityOrderTemp =  {priorityOrder[2:0], priorityOrder[3]};
              end

            busIf.DREQ[priorityOrder[3]]:
              begin
                busIf.DACK = 4'b0001 << priorityOrder[3];
                priorityOrderTemp = priorityOrder;
              end

          endcase
        end

      else
        begin
          busIf.DACK = 4'b0000;
          priorityOrderTemp = priorityOrder;
        end
    end

  always_ff@(posedge busIf.CLK)
    begin
      if(busIf.RESET)
        begin
          priorityOrder <= 8'b11_10_01_00;
          busIf.DACK <= 4'b0000;
        end
      else
        begin
          priorityOrder <= priorityOrderTemp;
        end
    end
endmodule
