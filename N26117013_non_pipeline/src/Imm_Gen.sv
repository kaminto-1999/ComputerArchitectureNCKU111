module Imm_Gen (
  input     [31:0] inst       ,
  input     [2:0]  ImmSel     ,
  output reg[31:0] imm         
);
  always @(*) begin : proc_imm
    case (ImmSel)
      //I-Type
      `ImmSelI: imm = {{21{inst[31]}},inst[30:25],inst[24:21],inst[20]};
      
      //S-Type
      `ImmSelS: imm = {{21{inst[31]}},inst[30:25], inst[11:8],inst[7]};
      
      //B-Type
      `ImmSelB: imm = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8],1'b0};
      
      //U-Type
      `ImmSelU: imm = {inst[31],inst[30:20],inst[19:12],12'b0};

      //J-Type
      `ImmSelJ: imm = {{12{inst[31]}},inst[19:12], inst[20], inst[30:25],inst[24:21],1'b0};
      // `ImmSelJ: imm = {12'b0, inst[19:12], inst[20], inst[30:21], 1'b0};

      //shamt
      `ImmShamt: imm = {27'b0,inst[24:20]};
      default : imm = 32'b0;
    endcase
  end
endmodule
