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
reg [31:0] instr;

// Outputs
wire [7:0] op_out;
wire [15:0] a_out;
wire [15:0] b_out;
wire [15:0] c_out;

initial begin
  instr <= 32'b0;
end

// Instantiate the Unit Under Test
d16_decode decode (
  .instr(instr),
  .op_out(op_out),
  .a_out(a_out),
  .b_out(b_out),
  .c_out(c_out)
);

initial begin

  sys_rst <= 1'b1;

  waitnclock(2);

  sys_rst <= 1'b0;

  // ADD, SUB, SHL, SHR
  instr <= {D16_OP_ADD, 8'haa, 8'hbb, 8'hcc};
  waitclock;
  instr <= {D16_OP_SUB, 8'haa, 8'hbb, 8'hcc};
  waitclock;
  instr <= {D16_OP_SHL, 8'haa, 8'hbb, 8'hcc};
  waitclock;
  instr <= {D16_OP_SHR, 8'haa, 8'hbb, 8'hcc};
  waitclock;

  // COP
  instr <= {D16_OP_COP, 8'haa, 8'hbb, 8'h00};
  waitclock;

  // AFC, JMP, JMZ
  instr <= {D16_OP_AFC, 8'haa, 8'hbb, 8'hcc};
  waitclock;
  instr <= {D16_OP_JMP, 8'haa, 8'hbb, 8'h00};
  waitclock;
  instr <= {D16_OP_JMZ, 8'haa, 8'hbb, 8'h00};
  waitclock;

  waitnclock(4);

  $finish();
end

endmodule
