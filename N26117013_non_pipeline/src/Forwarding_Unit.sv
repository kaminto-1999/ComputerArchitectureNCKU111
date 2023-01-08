module Forwarding_Unit(
      input  [4:0]  ex_rs1       ,
      input  [4:0]  ex_rs2       ,
      input  [4:0]  mem_rd       ,
      input         mem_RegWEn   ,
      input         mem_MemRead  ,
      output logic[1:0]  ForwardASel  ,
      output logic[1:0]  ForwardBSel   
  );
/*------------------------------------------------------------------------------
--  Data A
------------------------------------------------------------------------------*/
  always @(*) begin
    if (mem_RegWEn&&(mem_rd!=5'b0)&&(mem_rd == ex_rs1)) begin
      ForwardASel = {1'b1,mem_MemRead};
    end
    else begin
      ForwardASel = {1'b0,1'b0};
    end
  end
/*------------------------------------------------------------------------------
--  Data B
------------------------------------------------------------------------------*/
  always @(*) begin
    if (mem_RegWEn&&(mem_rd!=5'b0)&&(mem_rd == ex_rs2)) begin
      ForwardBSel = {1'b1,mem_MemRead};
    end
    else begin
      ForwardBSel = {1'b0,1'b0};
    end
  end
endmodule