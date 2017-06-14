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
// `include "sim_vga.v"

// Inputs
reg [2:0] ctrl_alu;
reg [15:0] a;
reg [15:0] b;

// Outputs
wire [15:0] s;
wire n;
wire o;
wire z;
wire c;

// Instantiate the Unit Under Test (UUT)
d16_alu uut (
  .s(s),
  .n(n),
  .o(o),
  .z(z),
  .c(c),
  .ctrl_alu(ctrl_alu),
  .a(a),
  .b(b)
);

initial begin
  // Initialize Inputs
  ctrl_alu = 0;
  a = 0;
  b = 0;

  // Wait 100 ns for global reset to finish
  #100;

  // Add stimulus here

  // ADD

  ctrl_alu <= 3'b001;
  a <= 16'h01;
  b <= 16'h01;

  #100;

  // SUB

  ctrl_alu <= 3'b010;
  a <= 16'h01;
  b <= 16'h01;

  #100;

  // LSH

  ctrl_alu <= 3'b011;
  a <= 16'h01;
  b <= 16'h01;

  #100;

  // RSH

  ctrl_alu <= 3'b100;
  a <= 16'h01;
  b <= 16'h01;

  #100;

  waitnclock(100);

  $finish();
end

endmodule
