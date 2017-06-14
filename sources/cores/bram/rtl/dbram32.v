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

module dbram32 #(
	parameter init_file = "none",
	parameter adr_width = 11
) (
	input a_clk,
	input a_rst,
  input [31:0] a_do,
  output reg [31:0] a_di,
  input a_we,
  input [15:0] a_a,

	input b_clk,
	input b_rst,
  input [31:0] b_do,
  output reg [31:0] b_di,
  input b_we,
  input [15:0] b_a
);

//-----------------------------------------------------------------
// Storage depth in 16 bit words
//-----------------------------------------------------------------
parameter word_width = adr_width - 2;
parameter word_depth = (1 << word_width);

//-----------------------------------------------------------------
// Actual RAM
//-----------------------------------------------------------------
reg [31:0] ram [0:word_depth-1];
wire [word_width-1:0] a_adr;
wire [word_width-1:0] b_adr;

always @(posedge a_clk) begin
  if (a_rst == 1'b1) begin
    a_di <= 32'b0;
  end else begin
    if (a_we) begin
      ram[a_adr] <= a_do;
    end
    a_di <= ram[a_adr];
  end
end

always @(posedge b_clk) begin
  if (b_rst == 1'b1) begin
    b_di <= 32'b0;
  end else begin
    if (b_we) begin
      ram[b_adr] <= b_do;
    end
    b_di <= ram[b_adr];
  end
end

assign a_adr = a_a[adr_width-1:2];
assign b_adr = b_a[adr_width-1:2];

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
