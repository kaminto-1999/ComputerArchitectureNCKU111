module Control_Unit(
    input      [6:0] opcode ,
    input      [2:0] funct3 ,
    input      [31:0]inst   ,
    input      [4:0] rd     ,
    output reg [2:0] ImmSel ,
    output reg       BrUn   ,
    output reg [1:0] ASel   ,
    output reg [1:0] BSel   ,
    output reg       MemRW  ,
    output reg       MemEn  ,
    output reg       RegWEn ,
    output reg [1:0] WBSel  ,
    output reg [4:0] ALUSel ,
    output logic     csr_ren,
    output logic     csr_wen 
);
assign csr_ren = opcode[6:0] == `CSR_TYPE;
assign MemEn   = (opcode[6:0] == `S_TYPE) || (opcode[6:0] == `LOAD) ;
assign MemRW   = opcode[6:0] == `S_TYPE;
/*------------------------------------------------------------------------------
--Decode Procedure 
------------------------------------------------------------------------------*/
always_comb begin
    case(opcode)
      `R_TYPE: begin
        BrUn   = 1'b0;
        ASel   = 2'b0; //Reg
        BSel   = 2'b0; //Reg
        WBSel  = 2'b1; //ALU
        RegWEn = 1'b1; //Write Register
        csr_wen= 1'b0;
        ImmSel= `ImmSelI; //Immediate type I
        case(funct3)
            `FUNCT3_ADD_SUB:begin
                if (inst[30]) begin
                  ALUSel= `ALUsub;
                end
                else begin
                  ALUSel= `ALUadd;
                end
            end
            `FUNCT3_SLL: ALUSel= `ALUsll;
            `FUNCT3_SLT:begin
                ALUSel= `ALUslt;
            end
            `FUNCT3_SLTU: ALUSel= `ALUsltu;
            `FUNCT3_XOR:  ALUSel= `ALUxor;
            `FUNCT3_SRL_SRA: begin
              if (inst[30]) begin
                ALUSel= `ALUsrl;
              end
              else begin
                ALUSel= `ALUsra;
              end
            end
            `FUNCT3_OR:  ALUSel= `ALUor;
            `FUNCT3_AND: ALUSel= `ALUand;
            //default: ALUSel = `ALUNoP;
        endcase
      end //R-Type Branch
      `LOAD: begin
        ImmSel= `ImmSelI; //Immediate type I
        BrUn  = 1'b0;
        ASel  = 2'b00; //Reg
        BSel  = 2'b01; //Imm
        ALUSel= `ALUadd;
        RegWEn= 1'b1;
        WBSel = 2'b00; //Mem
        csr_wen=1'b0;
      end//LOAD branch
      `I_TYPE:begin
        BrUn  = 1'b0;
        ASel  = 2'b00; //Reg
        BSel  = 2'b01; //Imm
        RegWEn= 1'b1;
        WBSel = 2'b01; //Mem
        csr_wen= 1'b0;
        case (funct3)
            `ADDI:begin
                // ALUSel = (inst[31]) ? `ALUsub : `ALUadd;
                ALUSel = `ALUadd;
                ImmSel = `ImmSelI; //Immediate type I
            end
            `SLTI:begin
                ALUSel = `ALUslt;
                ImmSel = `ImmSelI; //Immediate type I
            end
            `SLTIU:begin
                ALUSel = `ALUsltu;
                ImmSel = `ImmSelI; //Immediate type I
            end
            `XORI:begin
                ALUSel = `ALUxor;
                ImmSel = `ImmSelI; //Immediate type I
            end
            `ORI:begin
                ALUSel = `ALUor;
                ImmSel = `ImmSelI; //Immediate type I
            end
            `ANDI:begin
                ALUSel = `ALUand;
                ImmSel = `ImmSelI; //Immediate type I
            end
            `SLLI:begin
                ImmSel = `ImmShamt; //Immediate type Shamt
                ALUSel = `ALUsll;
            end
            `SRLI_SRAI:begin
                // $display("jump here");
                if (inst[30]) begin
                  ImmSel = `ImmShamt; //Immediate type I
                  ALUSel = `ALUsrai;
                end else begin
                  ImmSel = `ImmShamt; //Immediate type I
                  ALUSel = `ALUsrli;
                end
            end
        endcase
      end// I_TYPE branch
      `S_TYPE:begin
        ImmSel= `ImmSelS; //Immediate type S
        ALUSel= `ALUadd;
        BrUn  = 1'b0;
        ASel  = 2'b00; //Reg
        BSel  = 2'b01; //Imm
        RegWEn= 1'b0;
        WBSel = 2'b00; //Mem
        csr_wen= 1'b0;
      end// S_TYPE branch
      `B_TYPE:begin
        ImmSel= `ImmSelB; //Immediate type B
        case (funct3)
          `BEQ  : BrUn  = 1'b0;
          `BNE  : BrUn  = 1'b0;
          `BLT  : BrUn  = 1'b0;
          `BGE  : BrUn  = 1'b0;
          `BLTU : BrUn  = 1'b1;
          `BLE  : BrUn  = 1'b0;
          `BLEU : BrUn  = 1'b1;
          default : BrUn  = 1'b1;
        endcase
        ASel  = 2'b01; //PC
        BSel  = 2'b01; //Imm
        ALUSel= `ALUadd;
        RegWEn= 1'b0;
        WBSel = 2'b00; //Mem
        csr_wen= 1'b0;
      end//B_TYPE branch
      `JALR: begin
        ImmSel= `ImmSelI; //Immediate type I
        BrUn  = 1'b0;
        ASel  = 2'b00; //Reg
        BSel  = 2'b01; //Imm
        ALUSel= `ALUadd;
        RegWEn= 1'b1;
        WBSel = 2'b10; // PC+4
        csr_wen= 1'b0;
      end //JALR
      `JAL: begin
        ImmSel= `ImmSelJ; //Immediate type J
        BrUn  = 1'b0;
        ASel  = 2'b01; //PC
        BSel  = 2'b01; //Imm
        ALUSel= `ALUadd;
        RegWEn= 1'b1;
        WBSel = 2'b10; // PC+4
        csr_wen= 1'b0;
      end // JAL
      `AUIPC: begin
        ImmSel= `ImmSelU; //Immediate type U
        BrUn  = 1'b0;
        ASel  = 2'b01; //PC
        BSel  = 2'b01; //Imm
        ALUSel= `ALUadd;
        RegWEn= 1'b1;
        WBSel = 2'b01; // ALU
        csr_wen= 1'b0;
      end // AUIPC
      `LUI: begin
        ImmSel= `ImmSelU; //Immediate type U
        BrUn  = 1'b0;
        ASel  = 2'b11; //0
        BSel  = 2'b01; //Imm
        ALUSel= `ALUadd;
        RegWEn= 1'b1;
        WBSel = 2'b01; // ALU
        csr_wen= 1'b0;
      end // AUIPC
      `CSR_TYPE: begin
        BrUn  = 1'b0;
        RegWEn= 1'b1;
        WBSel = 2'b01; // ALU
        csr_wen= 1'b1;
        case (funct3)
          `CSRRW: begin
            ASel  = 2'b00; //RS1
            BSel  = 2'b10; //CSR
            ALUSel= `ALUNoP; // 
            ImmSel= `ImmSelI; //SCRI TYPE
          end
          `CSRRS: begin
            ASel  = 2'b00; //RS1
            BSel  = 2'b10; //CSR
            ImmSel= `ImmSelI; //SCRI TYPE
            case (inst[31:20])
              12'b0      : ALUSel = `ALUNoP;
              `RDINSTRETH: ALUSel = `ALUadd;
              `RDINSTRET : ALUSel = `ALUadd;
              `RDCYCLEH  : ALUSel = `ALUadd;
              `RDCYCLE   : ALUSel = `ALUadd;
              default : ALUSel= `ALUor;
            endcase
          end
          `CSRRC: begin
            ASel  = 2'b00; //RS1
            BSel  = 2'b10; //CSR
            ALUSel= `ALUand_inv;
            ImmSel= `ImmSelI; //SCRI TYPE
          end
          `CSRRWI: begin
            ASel  = 2'b10; //imm
            BSel  = 2'b10; //CSR
            ALUSel= `ALUNoP;
            ImmSel= `ImmCSR; //SCRI TYPE
          end
          `CSRRSI: begin
            ASel  = 2'b10; //imm
            BSel  = 2'b10; //CSR
            ALUSel= `ALUand_inv;
            ImmSel= `ImmCSR; //SCRI TYPE
          end
          `CSRRCI: begin
            ASel  = 2'b10; //imm
            BSel  = 2'b10; //CSR
            ALUSel= `ALUor;
            ImmSel= `ImmCSR; //SCRI TYPE
          end
          default : begin
            ASel  = 2'b00; //RS1
            BSel  = 2'b00; //RS2
            ALUSel= `ALUadd;
            ImmSel= `ImmSelI; //I-TYPE
          end
        endcase
      end // CSR
      default:begin
        ImmSel= `ImmSelI;
        BrUn  = 1'b0;
        ASel  = 2'b00; //Reg
        BSel  = 2'b00; //Reg
        ALUSel= `ALUNoP;
        RegWEn= 1'b0;
        WBSel = 2'b00; //ALU
        csr_wen= 1'b0;
      end
    endcase
end
endmodule