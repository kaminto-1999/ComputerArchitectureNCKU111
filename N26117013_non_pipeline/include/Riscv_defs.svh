/*------------------------------------------------------------------------------
--Immediate Selection Declaration  
------------------------------------------------------------------------------*/
`define ImmSelI  3'b000
`define ImmSelS  3'b001
`define ImmSelB  3'b010
`define ImmSelJ  3'b011
`define ImmSelU  3'b100
`define ImmShamt 3'b101
`define ImmCSR   3'b111
/*------------------------------------------------------------------------------
--ALU Function Declaration  
------------------------------------------------------------------------------*/
`define ALUadd      5'b00000
`define ALUsub      5'b00001
`define ALUsll      5'b00010
`define ALUslt      5'b00011
`define ALUsltu     5'b00100
`define ALUxor      5'b00101
`define ALUsrl      5'b00110
`define ALUsra      5'b00111
`define ALUor       5'b01000
`define ALUand      5'b01001
`define ALUslli     5'b01010
`define ALUsrli     5'b01011
`define ALUsrai     5'b01100
`define ALUand_inv  5'b01101
`define ALUNoP      5'b01110
/*------------------------------------------------------------------------------
--Instrucion Declaration  
------------------------------------------------------------------------------*/
//Instruction Type
`define R_TYPE   7'b0110011
`define I_TYPE   7'b0010011
`define LOAD     7'b0000011
`define S_TYPE   7'b0100011
`define B_TYPE   7'b1100011
`define JALR     7'b1100111
`define JAL      7'b1101111
`define AUIPC    7'b0010111
`define LUI      7'b0110111
`define CSR_TYPE 7'b1110011
//Load instruction funct3
`define LB   3'b000
`define LH   3'b001
`define LW   3'b010
`define LBU  3'b100
`define LHU  3'b101
//S-Type instruction funct3
`define SB   3'b000
`define SH   3'b001
`define SW   3'b010
//I-Type instruction funct3
`define ADDI      3'b000
`define SLTI      3'b010
`define SLTIU     3'b011
`define XORI      3'b100
`define ORI       3'b110
`define ANDI      3'b111
`define SLLI      3'b001
`define SRLI_SRAI 3'b101//SRLI and SRAI has same funct3

//R-type instruction funct3
`define FUNCT3_ADD_SUB  3'b000// ADD and SUB has the same funct3
`define FUNCT3_SLL      3'b001
`define FUNCT3_SLT      3'b010
`define FUNCT3_SLTU     3'b011
`define FUNCT3_XOR      3'b100
`define FUNCT3_SRL_SRA  3'b101
`define FUNCT3_OR       3'b110 
`define FUNCT3_AND      3'b111

//B-type instruction funct3
`define BEQ      3'b000
`define BNE      3'b001
`define BLT      3'b100
`define BGE      3'b011
`define BLTU     3'b110
`define BLE      3'b101
`define BLEU     3'b111
//CSR-Type instruction funct3
// `define CSR  3'b000
`define CSRRW    3'b001
`define CSRRS    3'b010
`define CSRRC    3'b011
// `define CSR      3'b100
`define CSRRWI   3'b101
`define CSRRSI   3'b110 
`define CSRRCI   3'b111
//CSRRS instruction detail
`define RDINSTRETH  12'hc82
`define RDINSTRET   12'hc02
`define RDCYCLEH    12'hc00
`define RDCYCLE     12'hc80

/*------------------------------------------------------------------------------
--CSR Registers  
------------------------------------------------------------------------------*/
`define CSR_CYCLE        		12'hc00
`define CSR_CYCLE_MASK   		32'hFFFFFFFF

`define CSR_CYCLE_H      		12'hc80
`define CSR_CYCLE_H_MASK 		32'hFFFFFFFF

`define CSR_INSTRET      		12'hc02
`define CSR_INSTRET_MASK 		32'hFFFFFFFF

`define CSR_INSTRET_H      	12'hc82
`define CSR_INSTRET_H_MASK 	32'hFFFFFFFF
