module Reg_IF_ID (
  input  wire        clk        ,
  input  wire        rst        ,
  input  wire [31:0] if_pc      ,
  input  wire [31:0] if_inst    ,
  input  wire        if_reg_clr ,
  output reg  [31:0] id_pc      ,
  output reg  [31:0] id_inst      
);
  always @ (posedge clk or posedge rst) begin
    if (rst) begin
      id_pc   <= 0;
      id_inst <= 0;
    end
    else begin
      if (if_reg_clr) begin
      id_pc   <= if_pc;
      id_inst <= 32'h00000013;
      end
      else begin
        id_pc   <= if_pc;
        id_inst <= if_inst;
      end
    end
  end
endmodule // reg_if_id