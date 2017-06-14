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
  input z,
  output li_di_rst,
  output [15:0] mem_addr,
  output load
);

`include "d16.vh"

//reg jmp_rst;
//
//task init;
//begin
//  jmp_rst <= 1'b1;
//end
//endtask

// Delay the reset beacause of synchroniszed intruction bus
//always @(posedge sys_clk) begin
//  if (sys_rst == 1'b1) begin
//    init;
//  end else begin
//    jmp_rst <= 1'b0;
//    if (li_di_rst_pre == 1'b1) begin
//      jmp_rst <= 1'b1;
//    end
//  end
//end

//wire li_di_rst_pre;

assign li_di_rst =
  (sys_rst == 1'b1) ? 1'b1 :
  ((op == D16_OP_JMZ && z == 1'b1) || op == D16_OP_JMP) ? 1'b1 :
  1'b0;

//assign li_di_rst = li_di_rst_pre;// | jmp_rst;

assign mem_addr =
  (sys_rst == 1'b1) ? 8'b0 :
  ((op == D16_OP_JMZ && z == 1'b1) || op == D16_OP_JMP) ? a :
  8'b0;
assign load =
  (sys_rst == 1'b1) ? 8'b0 :
  ((op == D16_OP_JMZ && z == 1'b1) || op == D16_OP_JMP) ? 1'b1 :
  1'b0;

endmodule
