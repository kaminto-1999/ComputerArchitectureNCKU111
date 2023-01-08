module Reg_PC(
  input             clk    ,
  input             rst    ,
  input      [31:0] pc_next,
  input             pc_en  ,
  output reg [31:0] if_pc   // To Instruction Mem
  );
  always @(posedge clk or posedge rst) begin : proc_pc
    if(rst) begin
      if_pc <= 0;
    end 
    else
      if(pc_en)
        if_pc <= pc_next;
  end
endmodule
