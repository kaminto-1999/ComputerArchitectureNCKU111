module Reg_EX_MEM (
  //Input from EX
  input  wire        clk            ,
  input  wire        rst            ,
  input  wire        ex_MemRW       ,
  input  wire        ex_RegWEn      ,
  input  wire [4:0]  ex_rd          ,
  input  wire [31:0] ex_pc          ,
  input  wire [31:0] ex_ALU_out     ,
  input  wire [1:0]  ex_WBSel       ,
  input  wire [2:0]  ex_funct3      ,
  input  wire        ex_MemEn       ,
  input  wire [31:0] ex_MuxDataB    ,
  input  wire        ex_NoP_en      ,
  //Output to MEM                
  output reg         mem_RegWEn      ,
  output reg         mem_MemRW       ,
  output reg  [1:0]  mem_WBSel       ,
  output reg  [4:0]  mem_rd          ,
  output reg  [2:0]  mem_funct3      ,
  output reg  [31:0] mem_ALU_out     ,
  output reg  [31:0] mem_pc          ,
  output reg         mem_MemEn       ,
  output reg         mem_NoP_en      ,
  output reg  [31:0] mem_MuxDataB     
);

  always @ (posedge clk or posedge rst) begin
    if (rst) begin
      mem_RegWEn      <= 1'b0;
      mem_pc          <= 0;
      mem_ALU_out     <= 0;
      mem_MemRW       <= 1'b0;
      mem_rd          <= 5'b0;
      mem_WBSel       <= 2'b0;
      mem_funct3      <= 3'b0;
      mem_MemEn       <= 1'b0;
      mem_MuxDataB    <= 0;
      mem_NoP_en      <= 1'b1;
    end 
    else begin
      mem_RegWEn      <= ex_RegWEn ;
      mem_pc          <= ex_pc     ;
      mem_ALU_out     <= ex_ALU_out;
      mem_MemRW       <= ex_MemRW  ;
      mem_rd          <= ex_rd     ;
      mem_WBSel       <= ex_WBSel  ;
      mem_funct3      <= ex_funct3 ;
      mem_MemEn       <= ex_MemEn  ;
      mem_MuxDataB    <= ex_MuxDataB;
      mem_NoP_en      <= ex_NoP_en ;
    end
  end

endmodule // reg_if_ex