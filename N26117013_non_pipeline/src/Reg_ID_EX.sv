module Reg_ID_EX (
  //Input from ID
  input  wire        clk          ,
  input  wire        rst          ,
  input  wire [31:0] id_pc        ,
  input  wire [31:0] id_DataRS1   ,
  input  wire [31:0] id_DataRS2   ,
  input  wire [6:0]  id_opcode    ,
  input  wire [4:0]  id_rd        ,
  input  wire [4:0]  id_rs1       ,
  input  wire [4:0]  id_rs2       ,
  input       [2:0]  id_ImmSel    ,
  input              id_BrUn      ,
  input       [1:0]  id_ASel      ,
  input       [1:0]  id_BSel      ,
  input              id_MemRW     ,
  input              id_RegWEn    ,
  input       [1:0]  id_WBSel     ,
  input       [4:0]  id_ALUSel    ,
  input       [31:0] id_imm       ,
  input       [2:0]  id_funct3    ,
  input              id_MemEn     ,
  input              id_reg_clr   ,
  input              id_csr_wen   ,
  input       [31:0] id_csr_rdata ,
  //output                       
  output reg  [31:0] ex_DataRS1   ,
  output reg  [31:0] ex_DataRS2   ,
  output reg  [31:0] ex_pc        ,
  output reg  [6:0]  ex_opcode    ,
  output reg  [4:0]  ex_rd        ,
  output reg  [4:0]  ex_rs1       ,
  output reg  [4:0]  ex_rs2       ,
  output reg  [2:0]  ex_ImmSel    ,
  output reg  [31:0] ex_imm       ,
  output reg         ex_BrUn      ,
  output reg  [1:0]  ex_ASel      ,
  output reg  [1:0]  ex_BSel      ,
  output reg         ex_MemRW     ,
  output reg         ex_RegWEn    ,
  output reg  [1:0]  ex_WBSel     ,
  output reg  [4:0]  ex_ALUSel    ,
  output reg  [2:0]  ex_funct3    ,
  output reg         ex_MemEn     ,
  output reg         ex_csr_wen   ,
  output reg  [31:0] ex_csr_rdata  
);

  always @ (posedge clk or posedge rst) begin
    if (rst) begin
      ex_imm    <= 0;
      ex_pc     <= 0;
      ex_DataRS1<= 0;
      ex_DataRS2<= 0;
      ex_BrUn   <= 1'b0;
      ex_ASel   <= 2'b0;
      ex_BSel   <= 2'b0;
      ex_MemRW  <= 1'b0;
      ex_RegWEn <= 1'b0;
      ex_rd     <= 5'b0;
      ex_rs1    <= 5'b0;
      ex_rs2    <= 5'b0;
      ex_ALUSel <= 5'b0;
      ex_ImmSel <= 3'b0;
      ex_WBSel  <= 2'b0;
      ex_funct3 <= 3'b0;
      ex_MemEn  <= 1'b0;
      ex_csr_wen<= 1'b0;
      ex_csr_rdata<=0;
      ex_opcode<= `I_TYPE;
    end 
    else begin
      if (id_reg_clr) begin
        ex_imm      <= 0;
        ex_DataRS1  <= 0;
        ex_DataRS2  <= 0;
        ex_BrUn     <= 1'b0;
        ex_ASel     <= 2'b0;
        ex_BSel     <= 2'b0;
        ex_MemRW    <= 1'b0;
        ex_RegWEn   <= 1'b0;
        ex_rd       <= 5'b0;
        ex_rs1      <= 5'b0;
        ex_rs2      <= 5'b0;
        ex_ALUSel   <= `ALUadd;
        ex_ImmSel   <= `ImmSelI;
        ex_WBSel    <= 2'b0;
        ex_funct3   <= 3'b0;
        ex_MemEn    <= 1'b0;
        ex_csr_wen  <= 1'b0;
        ex_csr_rdata<= 0;
        ex_opcode   <= `I_TYPE;
      end
      else begin
        ex_imm      <= id_imm      ;
        ex_pc       <= id_pc       ;
        ex_DataRS1  <= id_DataRS1  ;
        ex_DataRS2  <= id_DataRS2  ;
        ex_BrUn     <= id_BrUn     ;
        ex_ASel     <= id_ASel     ;
        ex_BSel     <= id_BSel     ;
        ex_MemRW    <= id_MemRW    ;
        ex_RegWEn   <= id_RegWEn   ;
        ex_rd       <= id_rd       ;
        ex_rs1      <= id_rs1      ;
        ex_rs2      <= id_rs2      ;
        ex_ALUSel   <= id_ALUSel   ;
        ex_ImmSel   <= id_ImmSel   ;
        ex_WBSel    <= id_WBSel    ;
        ex_funct3   <= id_funct3   ;
        ex_MemEn    <= id_MemEn    ;
        ex_csr_rdata<= id_csr_rdata;
        ex_csr_wen  <= id_csr_wen  ;
        ex_opcode   <= id_opcode   ;
      end
    end
  end

endmodule // reg_if_id
