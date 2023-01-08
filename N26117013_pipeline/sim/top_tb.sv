`timescale 1ns/10ps
`define CYCLE 12.5 // Cycle time
`define MAX 100000 // Max cycle number
`include "top.sv"
`timescale 1ns/10ps
`define mem_word(addr) \
 {TOP.DM1.Memory_byte3[addr], \
  TOP.DM1.Memory_byte2[addr], \
  TOP.DM1.Memory_byte1[addr], \
  TOP.DM1.Memory_byte0[addr]}
`define SIM_END 'h3fff
`define SIM_END_CODE -32'd1
`define TEST_START 'h2000
module top_tb;
  logic clk;
  logic rst;
  logic [31:0] RESULT[64];
  integer gf, i, num;
  integer err, inst_cnt,cycle_cnt;
  integer  cycle_err;
  logic [63:0]total_cycle ;
  string prog_path;
  string rdcycle;
  always #(`CYCLE/2) clk = ~clk;
  
  top TOP(
    .clk(clk),
    .rst(rst)
  );

  initial
  begin
    $value$plusargs("prog_path=%s", prog_path);
    clk = 0; rst = 1;
    #(`CYCLE) rst = 0;
    $readmemh({prog_path, "/main0.hex"}, TOP.IM1.Memory_byte0);
    $readmemh({prog_path, "/main0.hex"}, TOP.DM1.Memory_byte0); 
    $readmemh({prog_path, "/main1.hex"}, TOP.IM1.Memory_byte1);
    $readmemh({prog_path, "/main1.hex"}, TOP.DM1.Memory_byte1); 
    $readmemh({prog_path, "/main2.hex"}, TOP.IM1.Memory_byte2);
    $readmemh({prog_path, "/main2.hex"}, TOP.DM1.Memory_byte2); 
    $readmemh({prog_path, "/main3.hex"}, TOP.IM1.Memory_byte3);
    $readmemh({prog_path, "/main3.hex"}, TOP.DM1.Memory_byte3); 
    num = 0;
    gf = $fopen({prog_path, "/result.hex"}, "r");
    while (!$feof(gf))
    begin
      $fscanf(gf, "%h\n", RESULT[num]);
      num++;
    end
    $fclose(gf);

    wait(`mem_word(`SIM_END) == `SIM_END_CODE);
    $display("\nDone\n");
    err = 0;

    for (i = 0; i < num; i++)
    begin
      if (`mem_word(`TEST_START + i) !== RESULT[i])
      begin
        $display("DM[%4d] = %h, expect = %h", `TEST_START + i, `mem_word(`TEST_START + i), RESULT[i]);
        err = err + 1;
      end
      else
      begin
        $display("DM[%4d] = %h, pass", `TEST_START + i, `mem_word(`TEST_START + i));
      end
    end
    cycle_cnt = TOP.CPU.CSR_File_i.csr_cycle;
    inst_cnt = TOP.CPU.CSR_File_i.csr_instret;
    $display("Total cycle is %f ",cycle_cnt);
    $display("Total instruction is %f ",inst_cnt);
    result(err, num);
    $finish;
  end

always@(posedge clk, posedge rst)
begin
  if(rst) total_cycle <= 64'd0;
  else total_cycle <= total_cycle+64'd1;
end

  initial
  begin
    $fsdbDumpfile("top.fsdb");
    $fsdbDumpvars(0, TOP);
    #(`CYCLE*`MAX)
    for (i = 0; i < num; i++)
    begin
      if (`mem_word(`TEST_START + i) !== RESULT[i])
      begin
        $display("DM[%4d] = %h, expect = %h", `TEST_START + i, `mem_word(`TEST_START + i), RESULT[i]);
        err = err + 1;
      end
      else
      begin
        $display("DM[%4d] = %h, pass", `TEST_START + i, `mem_word(`TEST_START + i));
      end
    end
    $display("SIM_END(%5d) = %h, expect = %h", `SIM_END, `mem_word(`SIM_END), `SIM_END_CODE);
    result(num, num);
    $finish;
  end
  
  task result;
    input integer err;
    input integer num;
    integer rf;
    begin
      if (err === 0)
      begin
        $display("Simulation PASS!!");
        $display("\n");
      end
      else
      begin
        $display("Simulation Failed!!");
        $display("Totally has %d errors", err); 
        $display("\n");
      end
    end
  endtask

endmodule
