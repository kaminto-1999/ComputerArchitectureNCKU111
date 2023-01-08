module Reg_MEM_WB (
  //Input from EX
  input  wire        clk          ,
  input  wire        rst          ,
  input  wire        mem_RegWEn   ,
  input  wire [4:0]  mem_rd       ,
  input  wire [31:0] mem_pc       ,
  input  wire [31:0] mem_ReadData ,
  input  wire [31:0] mem_ALU_out  ,
  input  wire  [1:0] mem_WBSel    ,
  input  wire        mem_NoP_en   ,
  //
  output reg         wb_NoP_en    ,
  output reg         wb_RegWEn    ,
  output reg  [1:0]  wb_WBSel     ,
  output reg  [4:0]  wb_rd        ,//To Forwarding Unit
  output reg  [31:0] wb_ALU_out   ,//To WB MUX
  output reg  [31:0] wb_ReadData  ,//To WB MUX
  output reg  [31:0] wb_pc         
);

  always_ff @ (posedge clk or posedge rst) begin
    if (rst) begin
      wb_RegWEn   <= 1'b0;
      wb_pc       <= 0;
      wb_ALU_out  <= 0;
      wb_ReadData <= 0;
      wb_WBSel    <= 2'b0;
      wb_rd       <= 5'b0;
      wb_NoP_en   <= 1'b1;
    end
    else begin
      wb_RegWEn   <= mem_RegWEn   ;
      wb_pc       <= mem_pc       ;
      wb_ALU_out  <= mem_ALU_out  ;
      wb_ReadData <= mem_ReadData ;
      wb_WBSel    <= mem_WBSel    ;
      wb_rd       <= mem_rd       ;
      wb_NoP_en   <= mem_NoP_en   ;
    end
  end

endmodule // reg_if_ex