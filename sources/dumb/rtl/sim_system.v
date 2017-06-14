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
reg [7:0] sw;
reg [3:0] btn;

// Outputs
wire [2:0] vga_red;
wire [2:0] vga_grn;
wire [1:0] vga_blu;
wire vga_hsync;
wire vga_vsync;
wire [7:0] led;

task init;
begin
  sw <= 8'b0;
  btn <= 4'b0;
end
endtask

initial begin
  init;
end

// Instantiate the Unit Under Test
system system (
  .clkin100(sys_clk),
  .hard_reset(sys_rst),
  .vga_red(vga_red),
  .vga_grn(vga_grn),
  .vga_blu(vga_blu),
  .vga_hsync(vga_hsync),
  .vga_vsync(vga_vsync),
  .led(led),
  .sw(sw),
  .btn(btn)
);

integer i;
initial begin

  // Dump 16 registers
  for (i = 0; i < 16; i++) begin
    $dumpvars(0, main.system.d16.regs.regs[i]);
  end

//   // Dump data from 0x000 to 0x100
//   for (i = 12'h000; i < 12'h100; i++) begin
//     $dumpvars(0, main.system.b16.ram[i]);
//   end
// 
//   // Dump data from 0x400 to 0x500
//   for (i = 12'h400; i < 12'h500; i++) begin
//     $dumpvars(0, main.system.b16.ram[i]);
//   end

  sys_rst <= 1'b1;

  waitnclock(2);

  sys_rst <= 1'b0;

  waitnclock(3300);

  $finish();

end

endmodule
