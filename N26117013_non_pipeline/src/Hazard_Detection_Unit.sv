module Hazard_Detection_Unit (
  input       clk       ,  // Clock
  input       rst       ,  // Asynchronous reset active low
  input [6:0] ex_opcode ,
  input       ex_BrEn   ,
  output      branch    ,
  output      stall_en   
);
  wire    stall_en1_r;
  wire    stall_en2_r;
  reg     stall_en1_d;
  reg     stall_en2_d;
  assign branch   = stall_en1_r;
  assign stall_en = stall_en1_r;
  assign stall_en1_r =  ex_BrEn|| (ex_opcode ==`JALR )
                               || (ex_opcode ==`JAL  );
  always @(posedge clk or posedge  rst) begin : proc_stall_en
    if(rst) begin
      stall_en1_d <= 1'b1;
      stall_en2_d <= 1'b1;
    end else begin
      stall_en1_d <= stall_en1_r;
      stall_en2_d <= stall_en2_r;
    end
  end
endmodule : Hazard_Detection_Unit