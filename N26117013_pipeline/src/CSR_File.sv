module CSR_File (
  input clk                     ,// Clock
  input rst                     ,// System reset
  // CSR read port
  input              csr_ren    ,
  input     [11:0]   csr_raddr  ,
  output reg[31:0]   csr_rdata  ,
  // CSR write port
  input              csr_wen    ,
  input     [11:0]   csr_waddr  ,
  input     [31:0]   csr_wdata  ,
  // CSR Instret Count Enable
  input              inst_done   
  // output          csr_branch,
  // output [31:0]   csr_target,
  // output reg[1:0]    priv   ,
  // output reg[31:0]   status ,
  // output reg[31:0]   satp    
);
reg [31:0]  csr_rdata_r    ;
assign csr_rdata = csr_rdata_r;
//-----------------------------------------------------------------
// Registers / Wires
//-----------------------------------------------------------------
// CSR
reg [31:0]  csr_cycle    ; //Cycle counter for RDCYCLE instruction
reg [31:0]  csr_cycle_h  ; //Upper 32 bits of cycle, RV32I only
reg [31:0]  csr_instret  ; //Instructions-retired counter for RDINSTRET instruction.
reg [31:0]  csr_instret_h; //Instructions-retired counter for RDINSTRET instruction.
reg [31:0]  csr_tmp_1    ; //RFU
//-------------------- ---------------------------------------------
// CSR Read Port
//-----------------------------------------------------------------
// reg  [31:0] rdata_r;
  always_comb begin
        case (csr_raddr)
          `CSR_CYCLE    : csr_rdata_r = csr_ren ? csr_cycle      & `CSR_CYCLE_MASK    : 0;
          `CSR_CYCLE_H  : csr_rdata_r = csr_ren ? csr_cycle_h    & `CSR_CYCLE_H_MASK  : 0;
          `CSR_INSTRET  : csr_rdata_r = csr_ren ? (csr_instret+3)& `CSR_INSTRET_MASK  : 0;
          `CSR_INSTRET_H: csr_rdata_r = csr_ren ? csr_instret_h  & `CSR_INSTRET_H_MASK: 0;
          default:csr_rdata_r = 32'b0;
        endcase
  end
 // assign csr_rdata = rdata_r;
//-----------------------------------------------------------------
// CSR Write Port
//-----------------------------------------------------------------
  always@(*) begin
        case (csr_waddr)
            // `CSR_CYCLE    : csr_cycle     = csr_wdata & `CSR_CYCLE_MASK     ;
            // `CSR_CYCLE_H  : csr_cycle_h   = csr_wdata & `CSR_CYCLE_H_MASK   ;
            // `CSR_INSTRET  : csr_instret   = csr_wdata & `CSR_INSTRET_H      ;
            // `CSR_INSTRET_H: csr_instret_h = csr_wdata & `CSR_INSTRET_H_MASK ;
            12'b0: csr_tmp_1 = (csr_wen) ? 1 :0;
            default : csr_tmp_1 = 0;
        endcase
  end
/*------------------------------------------------------------------------------
-- CSR Variable
------------------------------------------------------------------------------*/
  reg [63:0] csr_cycle_cnt  ;
  reg [63:0] csr_instret_cnt;
/*------------------------------------------------------------------------------
-- Cycle Count
------------------------------------------------------------------------------*/
  always @(posedge clk or posedge rst) begin
    if(rst) begin
      csr_cycle_cnt   <= 64'b0;
      csr_instret_cnt <=64'b0;
    end 
    else begin
      csr_cycle_cnt <= csr_cycle_cnt + 64'b1;
      if (inst_done && (csr_cycle > 3)) begin
        csr_instret_cnt <= csr_instret_cnt + 64'b1;
      end
    end
  end
  assign csr_cycle = csr_cycle_cnt[31:0];
  assign csr_cycle_h = csr_cycle_cnt[63:32];
  assign csr_instret = csr_instret_cnt[31:0];
  assign csr_instret_h = csr_instret_cnt[63:32];
endmodule : CSR_File
