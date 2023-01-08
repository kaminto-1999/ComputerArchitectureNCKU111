module Forwarding_Unit(
      input  [4:0]  ex_rs1       ,
      input  [4:0]  ex_rs2       ,
      input  [4:0]  mem_rd       ,
      input  [4:0]  wb_rd        ,
      input         mem_RegWEn   ,
      input         mem_MemRead  ,
      input         wb_RegWEn    ,
      output [1:0]  ForwardASel  ,
      output [1:0]  ForwardBSel   
  );
  reg [1:0] ForwardASel_r;
  reg [1:0] ForwardBSel_r;
  assign ForwardASel= ForwardASel_r;
  assign ForwardBSel= ForwardBSel_r;
/*------------------------------------------------------------------------------
--  Data A
------------------------------------------------------------------------------*/
  always @(*) begin
    if (mem_RegWEn&&(mem_rd!=5'b0)&&(mem_rd == ex_rs1)) begin
      ForwardASel_r = {1'b1,mem_MemRead};
    end
    else begin
      ForwardASel_r = {1'b0,wb_RegWEn&&(wb_rd!= 5'b0)&&(wb_rd == ex_rs1)};
    end
  end
/*------------------------------------------------------------------------------
--  Data B
------------------------------------------------------------------------------*/
  always @(*) begin
    if (mem_RegWEn&&(mem_rd!=5'b0)&&(mem_rd == ex_rs2)) begin
      ForwardBSel_r = {1'b1,mem_MemRead};
    end
    else begin
      ForwardBSel_r = {1'b0,wb_RegWEn&&(wb_rd!= 5'b0)&&(wb_rd == ex_rs2)};
    end
  end
endmodule