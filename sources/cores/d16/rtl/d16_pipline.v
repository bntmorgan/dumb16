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

module d16_pipeline (
  input [7:0] op,
  input [15:0] a,
  input [15:0] b,
  input [15:0] c,
  output reg[7:0] op_out,
  output reg [15:0] a_out,
  output reg [15:0] b_out,
  output reg [15:0] c_out,
  input sys_clk,
  input en,
  input sys_rst
);

task init;
begin
  op_out <= 8'b0;
  a_out <= 16'b0;
  b_out <= 16'b0;
  c_out <= 16'b0;
end
endtask

initial begin
  init;
end

always @(posedge sys_clk) begin
  if (sys_rst == 1'b1) begin
    init;
  end else begin
    if (en == 1'b1) begin
      op_out <= op;
      a_out <= a;
      b_out <= b;
      c_out <= c;
    end
  end
end

endmodule
