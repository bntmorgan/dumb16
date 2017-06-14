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
reg [3:0] addr_a;
reg [3:0] addr_b;
reg [3:0] addr_w;
reg w;
reg [15:0] data;

// Outputs
wire [15:0] qa;
wire [15:0] qb;

task init;
begin
  addr_a <= 4'b0;
  addr_b <= 4'b0;
  addr_w <= 4'b0;
  w <= 1'b0;
  data <= 16'b0;
end
endtask

initial begin
  init;
end

// Instantiate the Unit Under Test
d16_registers registers (
  .sys_clk(sys_clk),
  .sys_rst(sys_rst),
  .addr_a(addr_a),
  .addr_b(addr_b),
  .addr_w(addr_w),
  .w(w),
  .data(data),
  .qa(qa),
  .qb(qb)
);

task write_all;
integer i;
begin
  init;
  waitnclock(2);
  w <= 1'b1;
  for (i = 0; i < 16; i = i + 1) begin
    addr_w <= i;
    data <= i;
    waitnclock(2);
  end
end
endtask

task read_all;
integer i;
begin
  init;
  waitnclock(2);
  for (i = 0; i < 16; i = i + 1) begin
    addr_a <= i;
    addr_b <= 15 - i;
    waitnclock(2);
  end
end
endtask

initial begin

  sys_rst <= 1'b1;

  write_all;

  read_all;

  sys_rst <= 1'b0;

  $finish();

end

endmodule
