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

module d16_alu (
  input sys_clk,
  input sys_rst,
  output [15:0] s,
  output n,
  output o,
  output z,
  output c,
  input [2:0] ctrl_alu,
  input [15:0] a,
  input [15:0] b
);

wire [31:0] out =
    (ctrl_alu == 3'b001) ? a + b :
    (ctrl_alu == 3'b010) ? a - b :
    (ctrl_alu == 3'b011) ? a << 1 :
    (ctrl_alu == 3'b100) ? a >> 1 :
    (ctrl_alu == 3'b101) ? a | b :
    (ctrl_alu == 3'b110) ? a & b :
    (ctrl_alu == 3'b111) ? a == b :
    32'b0;

assign c = out[8];
assign n = out[7];
assign z = (out[15:0] == 16'b0) ? 1'b1 : 1'b0;
assign o =
  (ctrl_alu == 3'b001) ? a[7] & b[7] & ~out[7] | ~a[7] & ~b[7] & out[7] :
  (ctrl_alu == 3'b010) ? ~a[7] & b[7] & out[7] | a[7] & ~b[7] & ~out[7] :
  (ctrl_alu == 3'b011) ? out[31] | out[30] | out[29] | out[28] | out[27]
  | out[26] | out[25] | out[24] | out[23] | out[22] | out[21] | out[20]
  | out[19] | out[18] | out[17] | out[16]:
    (ctrl_alu == 3'b100) ? 1'b0 :
    1'b0;

// Synced flags version

//reg c;
//reg n;
//reg z;
//reg o;

//task init;
//begin
//  c <= 1'b0;
//  n <= 1'b0;
//  z <= 1'b0;
//  o <= 1'b0;
//end
//endtask
//
//initial begin
//  init;
//end

//always @(posedge sys_clk) begin
//  if (sys_rst == 1'b1) begin
//    init;
//  end else begin
//    if ( ctrl_alu == 3'b001 || ctrl_alu == 3'b010 || ctrl_alu == 3'b011 ||
//      ctrl_alu == 3'b100) begin
//      c <= out[8];
//      n <= out[7];
//      z <= (out[15:0] == 16'b0) ? 1'b1 : 1'b0;
//      o <=
//        (ctrl_alu == 3'b001) ? a[7] & b[7] & ~out[7] | ~a[7] & ~b[7] & out[7] :
//        (ctrl_alu == 3'b010) ? ~a[7] & b[7] & out[7] | a[7] & ~b[7] & ~out[7] :
//        (ctrl_alu == 3'b011) ? out[31] | out[30] | out[29] | out[28] | out[27]
//        | out[26] | out[25] | out[24] | out[23] | out[22] | out[21] | out[20]
//        | out[19] | out[18] | out[17] | out[16]:
//          (ctrl_alu == 3'b100) ? 1'b0 :
//          1'b0;
//      end
//    end
//end

assign s = out[15:0];

endmodule
