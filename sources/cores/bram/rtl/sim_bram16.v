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

// Inputs
reg [15:0] do;
reg we;
reg [15:0] a;

// Outputs
wire [15:0] di;

task init;
begin
  do <= 16'b0;
  we <= 1'b0;
  a <= 16'b0;
end
endtask

initial begin
  init;
end

always @(posedge sys_clk) begin
  if (sys_rst == 1'b1) begin
    init;
  end else begin
  end
end

task read;
input [15:0] address;
begin
  a <= address;
  waitclock;
end
endtask

task write;
input [15:0] address;
input [15:0] data;
begin
  we <= 1'b1;
  a <= address;
  do <= data;
  waitclock;
  we <= 1'b0;
end
endtask

// Instantiate the Unit Under Test
bram16 data (
  .sys_clk(sys_clk),
  .sys_rst(sys_rst),
  .we(we),
  .do(do),
  .di(di),
  .a(a)
);

initial begin

  sys_rst <= 1'b1;

  waitnclock(2);

  sys_rst <= 1'b0;

  write(16'h0100, 16'h0100);
  write(16'h0200, 16'h0200);
  write(16'h0300, 16'h0300);
  write(16'h0400, 16'h0400);

  read(16'h0100);
  read(16'h0200);
  read(16'h0300);
  read(16'h0400);

  waitnclock(1);

  $finish();

end

endmodule
