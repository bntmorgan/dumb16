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

module bram16 #(
	parameter init_file = "none",
	parameter adr_width = 11
) (
	input sys_clk,
	input sys_rst,
	
  input [15:0] do,
  output reg [15:0] di,
  input we,
  input [15:0] a
);

//-----------------------------------------------------------------
// Storage depth in 16 bit words
//-----------------------------------------------------------------
parameter word_width = adr_width - 1;
parameter word_depth = (1 << word_width);

//-----------------------------------------------------------------
// Actual RAM
//-----------------------------------------------------------------
reg [15:0] ram [0:word_depth-1];
wire [word_width-1:0] adr;

always @(posedge sys_clk) begin
  if (we) begin
    ram[adr] <= do;
  end
	di <= ram[adr];
end

assign adr = a[adr_width-1:1];

//-----------------------------------------------------------------
// RAM initialization
//-----------------------------------------------------------------
initial
begin
	if (init_file != "none")
	begin
		$readmemh(init_file, ram);
	end
end

endmodule
