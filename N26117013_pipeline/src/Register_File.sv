module Register_File (
    input  wire               clk    ,
    input  wire               rst    ,
    input  wire               RegWEn ,
    input  wire [4:0]         AddrD  ,
    input  wire [31:0]        DataD  ,
    input  wire [4:0]         AddrA  ,
    input  wire [4:0]         AddrB  ,
    output reg  [31:0]        DataA  ,
    output reg  [31:0]        DataB   
);
    reg[31:0]  regs    [0:31];
    // write
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            regs [0] <=0;
            regs [1] <=0;
            regs [2] <=0;
            regs [3] <=0;
            regs [4] <=0;
            regs [5] <=0;
            regs [6] <=0;
            regs [7] <=0;
            regs [8] <=0;
            regs [9] <=0;
            regs [10]<=0;
            regs [11]<=0;
            regs [12]<=0;
            regs [13]<=0;
            regs [14]<=0;
            regs [15]<=0;
            regs [16]<=0;
            regs [17]<=0;
            regs [18]<=0;
            regs [19]<=0;
            regs [20]<=0;
            regs [21]<=0;
            regs [22]<=0;
            regs [23]<=0;
            regs [24]<=0;
            regs [25]<=0;
            regs [26]<=0;
            regs [27]<=0;
            regs [28]<=0;
            regs [29]<=0;
            regs [30]<=0;
            regs [31]<=0;
        end
        else begin
          if (RegWEn) begin
             regs[AddrD] <=DataD;
          end
        end
    end
    // read reg A
    always @ (*) begin
        if (rst || AddrA == 5'b0) begin
            DataA = 0;
        end 
        else begin
            if ((AddrA == AddrD)&&RegWEn) begin
                DataA = DataD;
            end
            else begin
                DataA  = regs[AddrA];
            end
        end
    end
    // read reg B
    always @ (*) begin
        if (rst || AddrB == 5'b0) begin
            DataB = 0;
        end 
        else begin
          if ((AddrB == AddrD)&& (RegWEn)) begin
            DataB = DataD;
          end
          else begin
            DataB  = regs[AddrB];
          end
        end
    end

endmodule