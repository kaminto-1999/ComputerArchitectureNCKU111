`include "Riscv_defs.svh"
module ALU(
  input  [31:0] a             , //src1
  input  [31:0] b             , //src2
  input  [4:0]  ALUSel        , //function sel
  output [31:0] alu_result    , //alu_result 
  output        zero_flag      
  );
  reg [31:0] alu_result_r;
  wire [31:0] a_abs ;
  wire [31:0] b_abs ;
  assign a_abs = (~a);
  assign b_abs = (~b);
  assign zero_flag = alu_result_r == 32'd0;
  assign alu_result= alu_result_r;
  always @(*)
    begin 
    case(ALUSel)
      `ALUadd : alu_result_r = a + b; // add
      `ALUsub : alu_result_r = a - b; // sub
      `ALUsll : alu_result_r = a << b[4:0];
      `ALUslt : begin
        if (a[31] == 1'b1 && b[31] == 1'b0) begin
          alu_result_r = 1;
        end
        else if (a[31] == 1'b0 && b[31] == 1'b1) begin
          alu_result_r = 0;
        end
        else if (a[31] == 1'b0 && b[31] == 1'b0) begin
          alu_result_r = (a <b)?1:0;
        end
        else if (a[31] == 1'b1 && b[31] == 1'b1) begin
          alu_result_r = (a_abs > b_abs) ? 1 : 0;
        end
        else alu_result_r = 0;
      end
      `ALUsltu: alu_result_r = (a <b)?1:0;
      `ALUxor : alu_result_r = a ^ b;
      `ALUsrl : alu_result_r = a >> b[4:0];
      `ALUsra : alu_result_r = ({32{a[31]}} << (5'd31-b[4:0]))|(a >> b[4:0]);
      `ALUor  : alu_result_r = a | b;
      `ALUand : alu_result_r = a & b;
      `ALUslli: alu_result_r = a <<  b[5:0];
      `ALUsrli: alu_result_r = a >>  b[5:0];
      `ALUsrai : alu_result_r = ({32{a[31]}} << (6'd32 - b[5:0]))|(a >> b[5:0]);
      `ALUand_inv: alu_result_r = a & (~b);
      `ALUNoP : alu_result_r = 0;
      default:alu_result_r = 0;
    endcase
  end
endmodule
