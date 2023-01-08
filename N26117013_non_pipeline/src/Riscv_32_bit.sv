//`include "Riscv_defs.svh"
//`include "ALU.sv"
//`include "Branch_Comparator.sv"
//`include "CSR_File.sv"
//`include "Control_Unit.sv"
//`include "Imm_Gen.sv"
//`include "mux4_1.sv"
//`include "Register_File.sv"
//`include "Reg_PC.sv"
//`include "DMEM_controller.sv"
//`include "Hazard_Detection_Unit.sv"
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
  wire        branch ;
  wire [31:0] pc     ;
  //ID State
  wire [6:0]  opcode;
  wire [31:0] inst  ;
  wire [4:0]  rd    ;
  wire [4:0]  rs1   ;
  wire [4:0]  rs2   ;
  wire [2:0]  funct3;
  wire [2:0]  ImmSel;
  wire [31:0] imm   ;
  wire        BrUn  ;
  wire [1:0]  ASel  ;
  wire [1:0]  BSel  ;
  wire        MemRW ;
  wire        RegWEn;
  wire [1:0]  WBSel ;
  wire [4:0]  ALUSel;
  wire [31:0] DataRS1;
  wire [31:0] DataRS2;
  wire        MemEn ;
  wire        csr_wen;
  wire        csr_ren;
  wire [11:0] csr_raddr;
  wire [31:0] csr_rdata;
  wire        BrEn;
  wire [31:0] ALU_out;
  wire [31:0] WBData ;
  wire [31:0] ReadData;
  wire [11:0] csr_waddr   ;
  wire [31:0] csr_wdata   ;
  wire        MemWrite  = MemEn && MemRW;
  wire        MemRead   = MemEn && (~MemRW);
  assign A_im    = pc[15:2];
  assign OE_im   = 1'b1;
//=========================PC Reg=========================//  
  //PC_next MUX
  wire [31:0] pc_next = branch ? ALU_out:pc+ 32'd4;
  Reg_PC Reg_PC_i
  (
    .clk        (clk    ),
    .rst        (rst    ),
    .pc_next    (pc_next),
    .pc_en      (1'b1   ),
    .if_pc      (pc     ) 
  );
//=========================ID STATE=========================//
  assign inst      = DO_im ;
  assign opcode    = inst[6:0];
  assign rd        = inst[11:7];
  assign rs1       = inst[19:15];
  assign rs2       = inst[24:20];
  assign funct3    = inst[14:12];
  assign csr_raddr = inst[31:20];
  //Control_Unit
  Control_Unit Control_Unit_i
  (
   .opcode  (opcode  ),
   .funct3  (funct3  ),
   .inst    (inst    ),
   .rd      (rd      ),
   .ImmSel  (ImmSel  ),
   .BrUn    (BrUn    ),
   .ASel    (ASel    ),
   .BSel    (BSel    ),
   .MemRW   (MemRW   ),
   .MemEn   (MemEn   ),
   .RegWEn  (RegWEn  ),
   .WBSel   (WBSel   ),
   .ALUSel  (ALUSel  ),
   .csr_ren (csr_ren ),
   .csr_wen (csr_wen ) 
  );
  //Imm_Gen
  Imm_Gen ImmGen_i
  (
  .inst       (inst    ),
  .ImmSel     (ImmSel  ),
  .imm        (imm     ) 
  );
  //Register_File
  Register_File Register_File_i
  (
  .clk          (clk       ),
  .rst          (rst       ),
  .RegWEn       (RegWEn ),
  .AddrD        (rd     ),
  .DataD        (WBData ),
  .AddrA        (rs1    ),
  .AddrB        (rs2    ),
  .DataA        (DataRS1),
  .DataB        (DataRS2) 
  );
  //CSR_Reg_File
  assign csr_wdata = ALU_out  ;
  assign csr_waddr = {7'b0,rd};
  CSR_File CSR_File_i(
  .clk      (clk         ),
  .rst      (rst         ),
  .csr_wen  (csr_wen     ),
  .csr_waddr(csr_waddr   ),
  .csr_wdata(csr_wdata   ),
  .csr_ren  (csr_ren     ),
  .csr_raddr(csr_raddr   ),
  .inst_done(1'b1 ),
  .csr_rdata(csr_rdata) //To ID/EX Reg
  );
//=========================EXECUTE STATE=========================//
  wire [31:0]ALU_DataA;
  wire [31:0]ALU_DataB;
  //ALU Data Mux
  mux4_1 ALU_DataA_i(
  .sel   (ASel     ),
  .in0   (DataRS1  ),
  .in1   (pc       ),
  .in2   (imm      ),
  .in3   (32'b0    ),
  .data_o(ALU_DataA) 
    );
  mux4_1 ALU_DataB_i(
  .sel   (BSel     ),
  .in0   (DataRS2  ),
  .in1   (imm      ),
  .in2   (csr_rdata),
  .in3   (32'b0    ),
  .data_o(ALU_DataB) 
  );
  //ALU Unit
  ALU ALU_Unit
  (
  .a          (ALU_DataA ),
  .b          (ALU_DataB ),
  .ALUSel     (ALUSel ),
  .alu_result (ALU_out) 
  );
//Branch Comparator
  Branch_Comparator Branch_Comparator_i
  (
  .ex_funct3  (funct3  ),
  .ex_ImmSel  (ImmSel  ),
  .ex_BrUn    (BrUn    ),
  .ex_DataRS1 (DataRS1 ),
  .ex_DataRS2 (DataRS2 ),
  .ex_BrEn    (BrEn    ) 
  );
//=========================MEMORY ACCESS STATE=========================//
  //DMEM Control Signal
  wire [31:0]wb_ReadData_w;
  DMEM_controller DMEM_controller_i(
  .clk          (clk          ),
  .rst          (rst          ),
  .mem_funct3   (funct3       ),
  .mem_byte_addr(ALU_out[15:0]),
  .DO_dm        (DO_dm        ),
  .mem_MuxDataB (DataRS2      ),
  .mem_MemEn    (MemEn        ),
  .mem_MemWrite (MemWrite     ),
  .mem_MemRead  (MemRead      ),
  .OE_dm        (OE_dm        ),
  .WEB_dm       (WEB_dm       ),
  .DI_dm        (DI_dm        ),
  .A_dm         (A_dm         ),
  .mem_ReadData (ReadData     ) 
);
//=========================WB STATE=========================//
  mux4_1 WBMux_i
  (
  .sel(WBSel    ),
  .in0(ReadData ), //Read form DMEM
  .in1(ALU_out  ), //Calculated Data form ALU
  .in2(pc +4    ), //JAL instruction
  .in3(32'b0    ),
  .data_o(WBData) 
  );
//=============INSTANCE HAZARD DETECTION============//
  Hazard_Detection_Unit Hazard_Detection_Unit_i
  (
  .clk       (clk       ),
  .rst       (rst       ),
  .ex_opcode (opcode    ),
  .ex_BrEn   (BrEn      ),
  .branch    (branch    ) 
  );
endmodule