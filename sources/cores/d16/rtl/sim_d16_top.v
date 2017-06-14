/*
Copyright (C) 2015  Benoît Morgan

This file is part of dumb16.

dumb16 is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

dumb16 is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with dumb16.  If not, see <http://www.gnu.org/licenses/>.
*/

`timescale 1ns / 1ps

module main();

`include "sim.v"
`include "d16.vh"

// Inputs
reg [31:0] ins_di;
reg [15:0] data_di;

// Outputs
wire [15:0] ins_a;
wire data_we;
wire [15:0] data_a;
wire [15:0] data_do;


task init;
  integer i;
begin
  ins_di <= 31'b0;
  data_di <= 16'b0;
  // Mem init
  for (i = 0; i < 16384; i++) begin
    mem[i] <= 32'b0;
  end
  // Program
  mem[0] <= {D16_OP_AFC, 8'h00, 8'haa, 8'hbb};
  mem[1] <= {D16_OP_AFC, 8'h01, 8'hbb, 8'hcc};
  mem[2] <= {D16_OP_AFC, 8'h02, 8'hdd, 8'hee};
  mem[3] <= {D16_OP_COP, 8'h03, 8'h02, 8'h00};
  mem[4] <= {D16_OP_NOP, 8'h00, 8'h00, 8'h00};
  mem[5] <= {D16_OP_NOP, 8'h00, 8'h00, 8'h00};
  mem[6] <= {D16_OP_NOP, 8'h00, 8'h00, 8'h00};
  mem[7] <= {D16_OP_NOP, 8'h00, 8'h00, 8'h00};
  mem[8] <= {D16_OP_STR, 8'h00, 8'h10, 8'h03};
  mem[9] <= {D16_OP_STR, 8'h02, 8'h10, 8'h03};
  mem[10] <= {D16_OP_STR, 8'h04, 8'h10, 8'h03};
  mem[11] <= {D16_OP_STR, 8'h06, 8'h10, 8'h03};
  mem[12] <= {D16_OP_LOD, 8'h04, 8'h01, 8'h10};
  mem[13] <= {D16_OP_JMP, 8'h00, 8'h00, 8'h00};
end
endtask

initial begin
  init;
end

// Memory
reg [31:0] mem [16383:0];

always @(posedge sys_clk) begin
  if (sys_rst == 1'b1) begin
    init;
  end else begin
    // instructions read
    ins_di <= mem[ins_a[15:2]];
    // Data read
    data_di <= (data_a[1] == 1'b1) ?
      mem[data_a[15:2]][31:16] :
      mem[data_a[15:2]][15:0];
    // Data write
    if (data_we == 1'b1) begin
      mem[data_a[15:2]] <= (data_a[1] == 1'b1) ?
        {data_do, mem[data_a[15:2]][15:0]} :
        {mem[data_a[15:2]][31:16], data_do};
    end
  end
end

// Instantiate the Unit Under Test
d16_top d16 (
  .sys_clk(sys_clk),
  .sys_rst(sys_rst),
  .ins_di(ins_di),
  .ins_a(ins_a),
  .data_di(data_di),
  .data_we(data_we),
  .data_a(data_a),
  .data_do(data_do)
);

integer i;
initial begin

  // Dump 32 registers
  for (i = 0; i < 16; i++) begin
    $dumpvars(0, main.d16.regs.regs[i]);
  end

  // Dump data from 0x000 to 0x100
  for (i = 12'h000; i < 12'h100; i++) begin
    $dumpvars(0, main.mem[i]);
  end

  // Dump data from 0x400 to 0x500
  for (i = 12'h400; i < 12'h500; i++) begin
    $dumpvars(0, main.mem[i]);
  end

  sys_rst <= 1'b1;

  waitnclock(2);

  sys_rst <= 1'b0;

  waitnclock(30);

  $finish();

end

endmodule
