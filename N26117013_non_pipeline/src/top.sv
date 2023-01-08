`include"Riscv_32_bit.sv"
`include"SRAM_rtl.sv"
module top (
input clk,    // Clock
input rst     // reset
);
/*------------------------------------------------------------------------------
--Internal Signal  
------------------------------------------------------------------------------*/
//Instruction Memory
wire [13:0]A_im;
wire    OE_im;
wire [31:0]DO_im;
//Data Memory
wire [13:0]A_dm;
wire [31:0]DI_dm;
wire     OE_dm;
wire [3:0] WEB_dm;
wire [31:0]DO_dm;
/*------------------------------------------------------------------------------
--Module Instance 
------------------------------------------------------------------------------*/
SRAM_rtl IM1(
.CK (clk    ),
.CS (1'b1  ),
.WEB(4'hf ),
.OE (OE_im  ),
.DO (DO_im  ),
.A  (A_im   ), 
.DI (  ) 
);

SRAM_rtl DM1(
.CK(clk),
.CS(1'b1), 
.WEB(WEB_dm),
.OE(OE_dm),
.DO(DO_dm),
.A(A_dm),
.DI(DI_dm) 
);
Riscv_32_bit  CPU(
.clk  (clk),
.rst (rst    ),
.DO_im (DO_im),
.A_im  (A_im),
.OE_im (OE_im),
.DO_dm (DO_dm),
.A_dm  (A_dm),
.DI_dm (DI_dm),
.OE_dm (OE_dm),
.WEB_dm(WEB_dm )
);
endmodule : top
