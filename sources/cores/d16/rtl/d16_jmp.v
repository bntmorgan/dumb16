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

module d16_jmp (
  input sys_clk,
  input sys_rst,
  input [7:0] op,
  input [15:0] a,
  input [15:0] b,
  // input z,
  output li_di_rst,
  output [15:0] mem_addr,
  output load
);

`include "d16.vh"

wire jmp =
  ((op == D16_OP_JMZ && b == 16'b0) || op == D16_OP_JMP) ? 1'b1 : // with b op
  // ((op == D16_OP_JMZ && z == 1'b1) || op == D16_OP_JMP) ? 1'b1 : with z flag
  1'b0;

assign li_di_rst = (sys_rst == 1'b1) ? 1'b1 : jmp;
assign mem_addr = (sys_rst == 1'b1) ? 8'b0 : (jmp == 1'b1) ? a : 8'b0;
assign load = (sys_rst == 1'b1) ? 8'b0 : jmp;

endmodule
