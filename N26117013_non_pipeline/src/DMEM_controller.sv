module DMEM_controller (
  input             clk           ,  // Clock
  input             rst           ,  // Asynchronous reset active low
  input      [2:0]  mem_funct3    ,
  input      [15:0] mem_byte_addr ,
  input      [31:0] DO_dm         ,
  input      [31:0] mem_MuxDataB  ,
  input             mem_MemEn     ,
  input             mem_MemWrite  ,
  input             mem_MemRead   ,
  output reg        OE_dm         ,
  output reg [3:0]  WEB_dm        ,
  output reg [31:0] DI_dm         ,
  output reg [13:0] A_dm          ,
  output reg [31:0] mem_ReadData   
);
  reg  [3:0] WEB_dm_r     ;
  reg  [31:0]DI_dm_r      ;
  wire [1:0] mem_byte_offset= mem_byte_addr[1:0];
  wire       OE_dm_w      ;
  assign WEB_dm     = (mem_MemWrite) ? WEB_dm_r : 4'b1111;
  assign DI_dm      = DI_dm_r;
  assign OE_dm_w    = mem_MemRead;
  assign A_dm       = mem_byte_addr[15:2];
  assign OE_dm      = OE_dm_w;
  always @(*) begin
      //Write Data
        case (mem_funct3)
          `SB: begin
            case (mem_byte_offset)
              2'b00: begin
                WEB_dm_r= 4'b1110;
                DI_dm_r = mem_MuxDataB;
              end
              2'b01: begin
                WEB_dm_r= 4'b1101;
                DI_dm_r = {mem_MuxDataB[23:0],8'b0};
              end 
              2'b10: begin
                WEB_dm_r= 4'b1011;
                DI_dm_r = {mem_MuxDataB[15:0],16'b0};
              end  
              2'b11: begin
                WEB_dm_r= 4'b0111;
                DI_dm_r = {mem_MuxDataB[7:0],24'b0};
              end
            endcase
          end
          `SH: begin
            case (mem_byte_offset)
              2'b00: begin
                WEB_dm_r= 4'b1100;
                DI_dm_r = mem_MuxDataB;
              end 
              2'b10: begin
                WEB_dm_r= 4'b0011;
                DI_dm_r = {mem_MuxDataB[15:0],16'b0};
              end 
              default: begin
                WEB_dm_r= 4'b1111;
                DI_dm_r = 0;
              end
            endcase
          end
          `SW: begin
            WEB_dm_r = 4'b0000;
            DI_dm_r  = mem_MuxDataB;
          end
          default: begin
            WEB_dm_r = 4'b1111;
            DI_dm_r  = 0;
          end
        endcase
      //Read Data
        case (mem_funct3)
          `LB : begin 
            case (mem_byte_offset)
              2'b00: mem_ReadData= {{24{DO_dm[7]}},DO_dm[7:0]};
              2'b01: mem_ReadData= {{24{DO_dm[15]}},DO_dm[15:8]};
              2'b10: mem_ReadData= {{24{DO_dm[23]}},DO_dm[23:16]};
              2'b11: mem_ReadData= {{24{DO_dm[31]}},DO_dm[31:24]};
            endcase
          end
          `LH : begin 
            case (mem_byte_offset)
              2'b00: mem_ReadData= {{16{DO_dm[15]}},DO_dm[15:0]};
              2'b10: mem_ReadData= {{16{DO_dm[31]}},DO_dm[31:16]};
              default: mem_ReadData= DO_dm;
            endcase
          end            
          `LW : begin 
            mem_ReadData = DO_dm;
          end            
          `LHU : begin 
            case (mem_byte_offset)
              2'b00: mem_ReadData= {16'b0,DO_dm[15:0]};
              2'b10: mem_ReadData= {16'b0,DO_dm[31:16]};
              default: mem_ReadData= DO_dm;
            endcase
          end
          `LBU : begin 
            case (mem_byte_offset)
              2'b00: mem_ReadData= {24'b0,DO_dm[7:0]};
              2'b01: mem_ReadData= {24'b0,DO_dm[15:8]};
              2'b10: mem_ReadData= {24'b0,DO_dm[23:16]};
              2'b11: mem_ReadData= {24'b0,DO_dm[31:24]};
            endcase
          end
          default : begin
            mem_ReadData = DO_dm;
          end
        endcase
  end
endmodule : DMEM_controller