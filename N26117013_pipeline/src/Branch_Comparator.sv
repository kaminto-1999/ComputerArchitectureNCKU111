module Branch_Comparator
(
  input        ex_BrUn   ,
  input  [2:0] ex_funct3 ,
  input  [2:0] ex_ImmSel ,
  input  [31:0]ex_DataRS1,
  input  [31:0]ex_DataRS2,
  output  reg  ex_BrEn   
);
reg  ex_BrEq;
reg  ex_BrLt;
reg  ex_BrGt;
always @(*) begin
  if (ex_BrUn) begin
      ex_BrEq = (ex_DataRS1 == ex_DataRS2) ? 1'b1 : 1'b0;
      ex_BrLt = (ex_DataRS1 < ex_DataRS2) ? 1'b1 : 1'b0;
      ex_BrGt = (ex_DataRS1 > ex_DataRS2) ? 1'b1 : 1'b0;
  end
  else begin
        ex_BrEq = (ex_DataRS1== ex_DataRS2) ? 1'b1 : 1'b0;
        ex_BrLt = ($signed(ex_DataRS1) <  $signed(ex_DataRS2)) ? 1'b1 : 1'b0;
        ex_BrGt = ($signed(ex_DataRS1) >  $signed(ex_DataRS2)) ? 1'b1 : 1'b0;
  end
end
always @(*) begin : proc_ex_BrEn
  if (ex_ImmSel == `ImmSelB) begin
    case (ex_funct3)
      `BEQ  : ex_BrEn = (ex_BrEq) ? 1'b1 : 1'b0;
      `BNE  : ex_BrEn = (!ex_BrEq) ? 1'b1 : 1'b0;
      `BLT  : ex_BrEn = (ex_BrLt) ? 1'b1 : 1'b0;
      `BGE  : ex_BrEn = (ex_BrLt || ex_BrEq) ? 1'b1 : 1'b0;
      `BLTU : ex_BrEn = (ex_BrLt) ? 1'b1 : 1'b0;
      `BLE  : ex_BrEn = (ex_BrGt || ex_BrEq) ? 1'b1 : 1'b0;
      `BLEU : ex_BrEn = (ex_BrGt || ex_BrEq) ? 1'b1 : 1'b0;
      default : ex_BrEn = 1'b0;
    endcase
  end
  else ex_BrEn = 1'b0;

end
endmodule
