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

module dbram16 #(
	parameter init_file = "none",
	parameter adr_width = 11,
	parameter data_width = 16
) (
	input a_clk,
	input a_rst,
  input [data_width-1:0] a_do,
  output reg [data_width-1:0] a_di,
  input a_we,
  input [adr_width-1:0] a_a,

	input b_clk,
	input b_rst,
  input [data_width-1:0] b_do,
  output reg [data_width-1:0] b_di,
  input b_we,
  input [adr_width-1:0] b_a
);

//-----------------------------------------------------------------
// Actual RAM
//-----------------------------------------------------------------
reg [data_width-1:0] ram [2 ** adr_width - 1:0];

always @(posedge a_clk) begin
  if (a_we) begin
    ram[a_a] <= a_do;
  end
	a_di <= ram[a_a];
end

always @(posedge b_clk) begin
  if (b_we) begin
    ram[b_a] <= b_do;
  end
	b_di <= ram[b_a];
end

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
