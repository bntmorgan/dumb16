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

module dbram8 #(
	parameter init_file = "none",
	parameter adr_width = 11
) (
	input a_clk,
	input a_rst,
  input [7:0] a_do,
  output reg [7:0] a_di,
  input a_we,
  input [7:0] a_a,

	input b_clk,
	input b_rst,
  input [7:0] b_do,
  output reg [7:0] b_di,
  input b_we,
  input [7:0] b_a
);

//-----------------------------------------------------------------
// Storage depth in 8 bit words
//-----------------------------------------------------------------
parameter word_width = adr_width - 1;
parameter word_depth = (1 << word_width);

//-----------------------------------------------------------------
// Actual RAM
//-----------------------------------------------------------------
reg [7:0] ram [0:word_depth-1];
wire [word_width-1:0] adr_a;
wire [word_width-1:0] adr_b;

always @(posedge a_clk) begin
  if (a_we) begin
    ram[adr_a] <= a_do;
  end
	a_di <= ram[adr_a];
end

always @(posedge b_clk) begin
  if (b_we) begin
    ram[adr_b] <= b_do;
  end
	b_di <= ram[adr_b];
end

assign adr_a = a_a[adr_width-1:0];
assign adr_b = a_a[adr_width-1:0];

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
