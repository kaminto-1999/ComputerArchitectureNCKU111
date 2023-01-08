`include "Riscv_defs.svh"
`include "ALU.sv"
`include "Branch_Comparator.sv"
`include "CSR_File.sv"
`include "Control_Unit.sv"
`include "Forwarding_Unit.sv"
`include "Imm_Gen.sv"
`include "mux4_1.sv"
`include "Reg_EX_MEM.sv"
`include "Reg_ID_EX.sv"
`include "Reg_IF_ID.sv"
`include "Reg_MEM_WB.sv"
`include "Register_File.sv"
`include "Reg_PC.sv"
`include "DMEM_controller.sv"
`include "Hazard_Detection_Unit.sv"
module Riscv_32_bit
(
  input             clk     , // System Clock
  input             rst     , // System Reset Active High
  //Instruction Memory pin
  input   reg [31:0]DO_im   , // From IMEM
  output  reg [13:0]A_im    , // Read Address
  output  reg       OE_im   , // SRAM control signal-Output Enable
  
  //Data Memory pin
  input   reg [31:0]DO_dm   , // Read DMEM Data
  output  reg [13:0]A_dm    , // Read Address
  output  reg [31:0]DI_dm   , // Write Data
  output  reg       OE_dm   , // SRAM control signal-Output Enable
  output  reg [3:0] WEB_dm    // SRAM control signal-Write Enable per Bit
);
//=========================Signal Declaration =========================// 
  wire stall_id;
  wire stall_en;
  wire branch  ;
  //IF State
  reg  [31:0] if_inst   ;
  wire [31:0] if_pc     ;
  //ID State
  wire [31:0] id_pc    ;
  wire [6:0]  id_opcode;
  wire [31:0] id_inst  ;
  wire [4:0]  id_rd    ;
  wire [4:0]  id_rs1   ;
  wire [4:0]  id_rs2   ;
  wire [2:0]  id_funct3;
  wire [2:0]  id_ImmSel;
  wire [31:0] id_imm   ;
  wire        id_BrUn  ;
  wire [1:0]  id_ASel  ;
  wire [1:0]  id_BSel  ;
  wire        id_MemRW ;
  wire        id_RegWEn;
  wire [1:0]  id_WBSel ;
  wire [4:0]  id_ALUSel;
  wire [31:0] id_DataRS1;
  wire [31:0] id_DataRS2;
  wire        id_MemEn ;
  wire        id_csr_wen;
  wire        id_csr_ren;
  wire [11:0] id_csr_raddr;
  wire [31:0] id_csr_rdata;
  wire        id_reg_clr;

  //EX State
  wire [31:0] ex_imm         ;
  wire [6:0]  ex_opcode      ;
  wire [31:0] ex_DataRS1     ;
  wire [31:0] ex_DataRS2     ;
  wire [31:0] ex_pc          ;
  wire [4:0]  ex_rd          ;
  wire [4:0]  ex_rs1         ;
  wire [4:0]  ex_rs2         ;
  wire        ex_BrUn        ;
  wire  [1:0] ex_ASel        ;
  wire  [1:0] ex_BSel        ;
  wire        ex_MemRW       ;
  wire        ex_RegWEn      ;
  wire [2:0]  ex_ImmSel      ;
  wire [2:0]  ex_funct3      ;
  wire [1:0]  ex_WBSel       ;
  wire [4:0]  ex_ALUSel      ;
  wire [31:0] ex_ALU_out     ;
  wire [1:0]  ex_ForwardASel ;
  wire [1:0]  ex_ForwardBSel ;
  wire        ex_MemEn       ;
  wire        ex_csr_wen     ;
  wire [11:0] ex_csr_waddr   ;
  wire [31:0] ex_csr_wdata   ;
  wire [31:0] ex_csr_rdata   ;
  wire        ex_BrEn        ;
  //MEM State
  wire        mem_RegWEn      ;
  wire        mem_MemRW       ;
  wire [4:0]  mem_rd          ;
  wire [31:0] mem_ALU_out     ;
  wire [31:0] mem_pc          ;
  wire [2:0]  mem_funct3      ;
  reg  [3:0]  mem_REB_dm      ;
  reg         mem_Read_Un     ;
  wire        mem_MemEn       ;
  wire [1:0]  mem_WBSel       ;
  wire        mem_NoP_en      ;
  wire [31:0] mem_MuxDataB    ;
  wire [31:0] mem_ReadData    ;
  wire        mem_MemWrite  = mem_MemEn && mem_MemRW;
  wire        mem_MemRead   = mem_MemEn && (~mem_MemRW);
  //WB State
  wire        wb_RegWEn  ;
  wire [4:0]  wb_rd      ;
  wire [31:0] wb_ALU_out ;
  wire [31:0] wb_pc      ;
  wire [31:0] wb_WBData  ;
  reg  [31:0] wb_ReadData;
  wire        wb_NoP_en  ;
  wire [1:0]  wb_WBSel   ;
  wire        wb_Read_Un ;
  wire [3:0]  wb_REB_dm  ;
  assign A_im    = if_pc[15:2];
  assign if_inst = DO_im;
  assign OE_im   = 1'b1;
//=========================PC Reg=========================//  
  //PC_next MUX
  wire [31:0] pc_next = branch ? ex_ALU_out:if_pc+ 32'd4;
  Reg_PC Reg_PC_i
  (
    .clk        (clk    ),
    .rst        (rst    ),
    .pc_next    (pc_next),
    .pc_en      (1'b1   ),
    .if_pc      (if_pc  ) 
  );
//=========================IF/ID REG=========================//
wire [31:0] id_inst_w;
  Reg_IF_ID Reg_IF_ID_i
  (
  .clk       (clk       ),
  .rst       (rst       ),
  .if_pc     (if_pc     ),
  .if_inst   (if_inst   ),
  .if_reg_clr(1'b0  ),
  //.id_inst(id_inst),// No delay IMEM
  .id_inst   (id_inst_w ),// 1 clk delay IMEM
  .id_pc     (id_pc     ) 
  );
//=========================ID STATE=========================//
  assign id_inst      = stall_en? 32'h13:id_inst_w ;
  assign id_opcode    = id_inst[6:0];
  assign id_rd        = id_inst[11:7];
  assign id_rs1       = id_inst[19:15];
  assign id_rs2       = id_inst[24:20];
  assign id_funct3    = id_inst[14:12];
  assign id_csr_raddr = id_inst[31:20];
  //Control_Unit
  Control_Unit Control_Unit_i
  (
   .opcode  (id_opcode  ),
   .funct3  (id_funct3  ),
   .inst    (id_inst    ),
   .rd      (id_rd      ),
   .ImmSel  (id_ImmSel  ),
   .BrUn    (id_BrUn    ),
   .ASel    (id_ASel    ),
   .BSel    (id_BSel    ),
   .MemRW   (id_MemRW   ),
   .MemEn   (id_MemEn   ),
   .RegWEn  (id_RegWEn  ),
   .WBSel   (id_WBSel   ),
   .ALUSel  (id_ALUSel  ),
   .csr_ren (id_csr_ren ),
   .csr_wen (id_csr_wen ) 
  );
  //Imm_Gen
  Imm_Gen ImmGen_i
  (
  .inst       (id_inst    ),
  .ImmSel     (id_ImmSel  ),
  .imm        (id_imm     ) 
  );
  //Register_File
  Register_File Register_File_i
  (
  .clk          (clk       ),
  .rst          (rst       ),
  .RegWEn       (wb_RegWEn ),
  .AddrD        (wb_rd     ),
  .DataD        (wb_WBData ),
  .AddrA        (id_rs1    ),
  .AddrB        (id_rs2    ),
  .DataA        (id_DataRS1),
  .DataB        (id_DataRS2) 
  );
  //CSR_Reg_File
  assign ex_csr_wdata = ex_ALU_out  ;
  assign ex_csr_waddr = {7'b0,ex_rd};
  CSR_File CSR_File_i(
  .clk      (clk         ),
  .rst      (rst         ),
  .csr_wen  (ex_csr_wen  ),
  .csr_waddr(ex_csr_waddr),
  .csr_wdata(ex_csr_wdata),
  .csr_ren  (id_csr_ren  ),
  .csr_raddr(id_csr_raddr),
  .inst_done(~wb_NoP_en  ),
  .csr_rdata(id_csr_rdata) //To ID/EX Reg
  );
//=========================ID/EX REG=========================//
  Reg_ID_EX Reg_ID_EX
  (
  .clk       (clk           ),
  .rst       (rst           ),
  .id_reg_clr(1'b0          ),
  .id_pc     (id_pc         ),
  .id_DataRS1(id_DataRS1    ),
  .id_DataRS2(id_DataRS2    ),
  .id_opcode (id_opcode     ),
  .id_rd     (id_rd         ),
  .id_rs1    (id_rs1        ),
  .id_rs2    (id_rs2        ),
  .id_imm    (id_imm        ),
  .id_ImmSel (id_ImmSel     ),
  .id_BrUn   (id_BrUn       ),
  .id_ASel   (id_ASel       ),
  .id_BSel   (id_BSel       ),
  .id_MemRW  (id_MemRW      ),
  .id_RegWEn (id_RegWEn     ),
  .id_WBSel  (id_WBSel      ),
  .id_ALUSel (id_ALUSel     ),
  .id_MemEn  (id_MemEn      ),
  .id_funct3 (id_funct3     ),
  .id_csr_wen(id_csr_wen    ),
  .id_csr_rdata(id_csr_rdata),
  //
  .ex_funct3  (ex_funct3    ),
  .ex_DataRS1 (ex_DataRS1   ),
  .ex_DataRS2 (ex_DataRS2   ),
  .ex_pc      (ex_pc        ),
  .ex_opcode  (ex_opcode    ),
  .ex_rd      (ex_rd        ),
  .ex_rs1     (ex_rs1       ),
  .ex_rs2     (ex_rs2       ),
  .ex_imm     (ex_imm       ),
  .ex_ImmSel  (ex_ImmSel    ),
  .ex_BrUn    (ex_BrUn      ),
  .ex_ASel    (ex_ASel      ),
  .ex_BSel    (ex_BSel      ),
  .ex_MemRW   (ex_MemRW     ),
  .ex_RegWEn  (ex_RegWEn    ),
  .ex_WBSel   (ex_WBSel     ),
  .ex_ALUSel  (ex_ALUSel    ),
  .ex_MemEn   (ex_MemEn     ),
  .ex_csr_wen (ex_csr_wen   ),
  .ex_csr_rdata(ex_csr_rdata) 
  );
//=========================EXECUTE STATE=========================//
  wire [31:0]ex_MuxDataA;
  wire [31:0]ex_MuxDataB;
  wire [31:0]ALU_DataA;
  wire [31:0]ALU_DataB;
  //DataA_mux
  mux4_1 ForwardDataA_mux
  (
  .sel   (ex_ForwardASel ),
  .in0   (ex_DataRS1     ),//RS1
  .in1   (wb_WBData      ),//Forward From WB stage
  .in2   (mem_ALU_out    ),//Forward From MEM stage
  .in3   (mem_ReadData   ),//Both true
  .data_o(ex_MuxDataA    ) // To ALU Data A
  );
  //DataB MUX
  mux4_1 ForwardDataB_mux
  (
  .sel   (ex_ForwardBSel ),
  .in0   (ex_DataRS2     ),//RS2
  .in1   (wb_WBData      ),//Forward From WB stage
  .in2   (mem_ALU_out    ),//Forward From MEM Stage
  .in3   (mem_ReadData   ),//Both true
  .data_o(ex_MuxDataB    ) //To ALU Data B
  );
//=========================ALU UNIT=========================//
  //ALU Data Mux
  mux4_1 ALU_DataA_i(
  .sel   (ex_ASel    ),
  .in0   (ex_MuxDataA),
  .in1   (ex_pc      ),
  .in2   (ex_imm     ),
  .in3   (32'b0      ),
  .data_o(ALU_DataA  ) 
    );
  mux4_1 ALU_DataB_i(
  .sel   (ex_BSel     ),
  .in0   (ex_MuxDataB ),
  .in1   (ex_imm      ),
  .in2   (ex_csr_rdata),
  .in3   (32'b0       ),
  .data_o(ALU_DataB   ) 
  );
  //ALU Unit
  ALU ALU_Unit
  (
  .a          (ALU_DataA ),
  .b          (ALU_DataB ),
  .ALUSel     (ex_ALUSel ),
  .alu_result (ex_ALU_out) 
  );
//Forwarding_Unit
  Forwarding_Unit Forwarding_Unit_i
  (
  .ex_rs1        (ex_rs1        ),
  .ex_rs2        (ex_rs2        ),
  .mem_rd        (mem_rd        ),
  .wb_rd         (wb_rd         ),
  .mem_RegWEn    (mem_RegWEn    ),
  .mem_MemRead   (mem_MemRead   ),
  .wb_RegWEn     (wb_RegWEn     ),
  .ForwardASel   (ex_ForwardASel), //
  .ForwardBSel   (ex_ForwardBSel)  //
  );
//Branch Comparator
  Branch_Comparator Branch_Comparator_i
  (
  .ex_funct3  (ex_funct3  ),
  .ex_ImmSel  (ex_ImmSel  ),
  .ex_BrUn    (ex_BrUn    ),
  .ex_DataRS1 (ex_MuxDataA),
  .ex_DataRS2 (ex_MuxDataB),
  .ex_BrEn    (ex_BrEn    ) 
  );
//=========================Reg EX/MEM=========================//
  Reg_EX_MEM Reg_EX_MEM
  (
  .clk             (clk        ),
  .rst             (rst        ),
  .ex_RegWEn       (ex_RegWEn  ),
  .ex_MemRW        (ex_MemRW   ),
  .ex_rd           (ex_rd      ),
  .ex_funct3       (ex_funct3  ),
  .ex_pc           (ex_pc      ),
  .ex_MuxDataB     (ex_MuxDataB),
  .ex_ALU_out      (ex_ALU_out ),
  .ex_WBSel        (ex_WBSel   ),
  .ex_MemEn        (ex_MemEn   ),
  .ex_NoP_en       (stall_en   ),
  //
  .mem_RegWEn      (mem_RegWEn ),
  .mem_MemRW       (mem_MemRW  ),
  .mem_rd          (mem_rd     ),
  .mem_funct3      (mem_funct3 ),
  .mem_ALU_out     (mem_ALU_out),
  .mem_MuxDataB    (mem_MuxDataB),
  .mem_pc          (mem_pc     ),
  .mem_MemEn       (mem_MemEn  ),
  .mem_NoP_en      (mem_NoP_en ),
  .mem_WBSel       (mem_WBSel  )
  );
//=========================MEMORY ACCESS STATE=========================//
  //DMEM Control Signal
  wire [31:0]wb_ReadData_w;
  DMEM_controller DMEM_controller_i(
  .clk          (clk              ),
  .rst          (rst              ),
  .mem_funct3   (mem_funct3       ),
  .mem_byte_addr(mem_ALU_out[15:0]),
  .DO_dm        (DO_dm            ),
  .mem_MuxDataB (mem_MuxDataB     ),
  .mem_MemEn    (mem_MemEn        ),
  .mem_MemWrite (mem_MemWrite     ),
  .mem_MemRead  (mem_MemRead      ),
  .wb_REB_dm    (wb_REB_dm        ),
  .wb_Read_Un   (wb_Read_Un       ),
  .OE_dm        (OE_dm            ),
  .mem_REB_dm   (mem_REB_dm       ),
  .mem_Read_Un  (mem_Read_Un      ),
  .WEB_dm       (WEB_dm           ),
  .DI_dm        (DI_dm            ),
  .A_dm         (A_dm             ),
  .mem_ReadData (mem_ReadData     ) 
);

//=========================Reg MEM/WB=========================//
  Reg_MEM_WB Reg_MEM_WB_i
  (
  .clk         (clk          ),
  .rst         (rst          ),
  .mem_RegWEn  (mem_RegWEn   ),
  .mem_rd      (mem_rd       ),
  .mem_pc      (mem_pc       ),
  .mem_ALU_out (mem_ALU_out  ), //To WBMux
  .mem_WBSel   (mem_WBSel    ), //To WBMux
  .mem_NoP_en  (mem_NoP_en   ), //From EX state
  .mem_REB_dm  (mem_REB_dm   ),
  .mem_Read_Un (mem_Read_Un  ),
  .mem_ReadData(mem_ReadData ),
  //
  .wb_RegWEn   (wb_RegWEn    ),
  .wb_rd       (wb_rd        ),
  .wb_ALU_out  (wb_ALU_out   ),
  .wb_WBSel    (wb_WBSel     ),
  .wb_NoP_en   (wb_NoP_en    ), //To CSR instret
  .wb_Read_Un  (wb_Read_Un   ),
  .wb_REB_dm   (wb_REB_dm    ),
  .wb_ReadData (wb_ReadData  ),
  .wb_pc       (wb_pc        ) 
  );
//=========================WB STATE=========================//
  mux4_1 WBMux_i
  (
  .sel(wb_WBSel    ),
  .in0(wb_ReadData ), //Read form DMEM
  .in1(wb_ALU_out  ), //Calculated Data form ALU
  .in2(wb_pc +4    ), //JAL instruction
  .in3(32'b0       ),
  .data_o(wb_WBData   ) 
  );
//=============INSTANCE HAZARD DETECTION============//
  Hazard_Detection_Unit Hazard_Detection_Unit_i
  (
  .clk       (clk       ),
  .rst       (rst       ),
  .ex_opcode (ex_opcode ),
  .ex_BrEn   (ex_BrEn   ),
  .PCSel     (PCSel     ),
  .branch    (branch    ),
  .stall_en  (stall_en  ) 
  );
endmodule
