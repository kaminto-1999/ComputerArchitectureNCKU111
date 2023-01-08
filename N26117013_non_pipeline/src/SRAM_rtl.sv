module SRAM_rtl (A,DO,DI,CK,WEB,OE,CS);
  output logic [31:0]    DO;
  input  [31:0]    DI;
  input  [13:0]    A;
  input  [3:0]    WEB;
  input      CK;                                      
  input      CS;                                      
  input      OE;                                      
  parameter  AddressSize          = 14;               
  parameter  Bits                 = 8;                
  parameter  Words                = 16384;            
  parameter  Bytes                = 4;                
  logic      [Bits-1:0]           Memory_byte0 [Words-1:0];     
  logic      [Bits-1:0]           Memory_byte1 [Words-1:0];     
  logic      [Bits-1:0]           Memory_byte2 [Words-1:0];     
  logic      [Bits-1:0]           Memory_byte3 [Words-1:0];     
  logic      [Bytes*Bits-1:0]     latched_DO;                

  always_ff @(posedge CK)
  begin
    if (CS)
    begin
      if (~WEB[0])
      begin
        Memory_byte0[A] <= DI[0*Bits+:Bits];
        //latched_DO[0*Bits+:Bits] <= DI[0*Bits+:Bits];
      end
      else
      begin
        //latched_DO[0*Bits+:Bits] <= Memory_byte0[A];
      end
      if (~WEB[1])
      begin
        Memory_byte1[A] <= DI[1*Bits+:Bits];
        //latched_DO[1*Bits+:Bits] <= DI[1*Bits+:Bits];
      end
      else
      begin
        //latched_DO[1*Bits+:Bits] <= Memory_byte1[A];
      end
      if (~WEB[2])
      begin
        Memory_byte2[A] <= DI[2*Bits+:Bits];
        //latched_DO[2*Bits+:Bits] <= DI[2*Bits+:Bits];
      end
      else
      begin
        //latched_DO[2*Bits+:Bits] <= Memory_byte2[A];
      end
      if (~WEB[3])
      begin
        Memory_byte3[A] <= DI[3*Bits+:Bits];
        //latched_DO[3*Bits+:Bits] <= DI[3*Bits+:Bits];
      end
      else
      begin
        //latched_DO[3*Bits+:Bits] <= Memory_byte3[A];
      end
    end
  end
  always_comb
  begin
    if (CS) begin
      if (~WEB[0])
      begin
        latched_DO[0*Bits+:Bits] = DI[0*Bits+:Bits];
      end
      else
      begin
        latched_DO[0*Bits+:Bits] = Memory_byte0[A];
      end
      if (~WEB[1])
      begin
        latched_DO[1*Bits+:Bits] = DI[1*Bits+:Bits];
      end
      else
      begin
        latched_DO[1*Bits+:Bits] = Memory_byte1[A];
      end
      if (~WEB[2])
      begin
        latched_DO[2*Bits+:Bits] = DI[2*Bits+:Bits];
      end
      else
      begin
        latched_DO[2*Bits+:Bits] = Memory_byte2[A];
      end
      if (~WEB[3])
      begin
        latched_DO[3*Bits+:Bits] = DI[3*Bits+:Bits];
      end
      else
      begin
        latched_DO[3*Bits+:Bits] = Memory_byte3[A];
      end
    end
  end
  always_comb
  begin
    DO = (OE)? latched_DO: {(Bytes*Bits){1'bz}};
  end

endmodule
