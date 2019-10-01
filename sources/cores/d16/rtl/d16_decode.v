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

module d16_decode (
  input [31:0] instr,
  output [7:0] op_out,
  output [15:0] a_out,
  output [15:0] b_out,
  output [15:0] c_out
);

`include "d16.vh"

wire [7:0] op_in = instr[31:24];
wire [7:0] a_in = instr[23:16];
wire [7:0] b_in = instr[15:8];
wire [7:0] c_in = instr[7:0];

wire [15:0] a_e = (a_in[7]) ? {8'hff, a_in} : {8'h00, a_in};
wire [15:0] b_e = (b_in[7]) ? {8'hff, b_in} : {8'h00, b_in};

// Instruction decoding

// ADD r0, r1, r2
// SUB r0, r1, r2
// SHL r0, r1, r2
// SHR r0, r1, r2
// OR  r0, r1, r2
// AND r0, r1, r2
// EQU r0, r1, r2
// LTE r0, r1, r2
// GTE r0, r1, r2
// LT  r0, r1, r2
// GT  r0, r1, r2
//    Id mapping
// AFC r, $imm
//    a_out = a_in
//    b_out = b_in << 8 + c_in
//    c_out = 0
// COP r1, r2
//    Id mapping
//    c_out = 0
// LOP r1, r2 The trick here is to use the Arithmetic pipeline to load the
//              registers
// STP r1, r2
//    a_out = 0
//    b_out = a_in
//    c_out = b_in
// LPR r1, r2, r2
//    a_out = a_in
//    b_out = b_in
//    c_out = c_in
// LOD r, addr
//    a_out = a_in
//    b_out = b_in << 8 + c_in
//    c_out = 0
// STR addr, r
//    a_out = a_int << 8 + b_in
//    b_out = c_in
//    c_out = 0
// JMP addr
//    a_out = a_in << 8 + b_in
//    b_out = 0
//    c_out = 0
// JMZ addr
//    a_out = a_in << 8 + b_in
//    b_out = c_in
//    c_out = 0
// JMR r0
//    a_out = 0
//    b_out = a_in
//    c_out = 0

assign op_out = op_in;
assign a_out =
  (op_in == D16_OP_JMP || op_in == D16_OP_JMZ || op_in == D16_OP_STR) ?
    {a_in, b_in} :
  (op_in == D16_OP_STP) ? a_e :
  (op_in == D16_OP_JMR) ? 16'b0 : {8'h00, a_in};
assign b_out =
  (op_in == D16_OP_AFC || op_in == D16_OP_LOD) ? {b_in, c_in} :
  (op_in == D16_OP_STR || op_in == D16_OP_JMZ) ? {8'b00, c_in} :
  ( op_in == D16_OP_ADD || op_in == D16_OP_SUB || op_in == D16_OP_SHL ||
    op_in == D16_OP_SHR || op_in == D16_OP_COP || op_in == D16_OP_STP ||
    op_in == D16_OP_EQU || op_in == D16_OP_OR  || op_in == D16_OP_AND ||
    op_in == D16_OP_LTE || op_in == D16_OP_GTE ||
    op_in == D16_OP_LT  || op_in == D16_OP_LT) ? {8'h00, b_in} :
  (op_in == D16_OP_LOP) ? b_e :
  (op_in == D16_OP_JMR) ? {8'h00, a_in} : 16'h00 ;
assign c_out =
  ( op_in == D16_OP_ADD || op_in == D16_OP_SUB ||
    op_in == D16_OP_SHL || op_in == D16_OP_SHR ||
    op_in == D16_OP_OR  || op_in == D16_OP_AND || op_in == D16_OP_EQU ||
    op_in == D16_OP_LTE || op_in == D16_OP_GTE ||
    op_in == D16_OP_LT  || op_in == D16_OP_LT  ||
    op_in == D16_OP_LOP || op_in == D16_OP_STP) ? {8'b00, c_in} :
  16'h00 ;

endmodule
