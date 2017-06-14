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
reg dir;
reg load;
reg en;
reg [15:0] din;

// Outputs
wire [15:0] dout;

initial begin
  dir <= 1'b1;
  load <= 1'b0;
  en <= 1'b1;
  din <= 16'b0;
end

// Instantiate the Unit Under Test
d16_cpt16 cpt16 (
  .sys_clk(sys_clk),
  .sys_rst(sys_rst),
  .dir(dir),
  .load(load),
  .en(en),
  .din(din),
  .dout(dout)
);

initial begin

  sys_rst <= 1'b1;

  waitnclock(10);

  sys_rst <= 1'b0;

  waitnclock(40);

  load <= 1'b1;
  din <= 16'hcaca;

  waitnclock(40);

  load <= 1'b0;
  din <= 16'h0000;

  waitnclock(40);


  $finish();
end

endmodule
