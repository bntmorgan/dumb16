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

module conbus1x4 (
  // System
  input sys_clk,
  input sys_rst,
  // Master
  output [15:0] m_di,
  input [15:0] m_do,
  input m_we,
  input [15:0] m_a,
  // Slave 0
  input [15:0] s0_di,
  output [15:0] s0_do,
  output s0_we,
  output [15:0] s0_a,
  // Slave 1
  input [15:0] s1_di,
  output [15:0] s1_do,
  output s1_we,
  output [15:0] s1_a,
  // Slave 2
  input [15:0] s2_di,
  output [15:0] s2_do,
  output s2_we,
  output [15:0] s2_a,
  // Slave 3
  input [15:0] s3_di,
  output [15:0] s3_do,
  output s3_we,
  output [15:0] s3_a
);

reg [1:0] state;

// Input routing

assign s0_a = (m_a[15:14] == 2'b00) ? m_a[15:0] : 16'b0;
assign s0_do = (m_a[15:14] == 2'b00) ? m_do : 16'b0;
assign s0_we = (m_a[15:14] == 2'b00) ? m_we : 1'b0;

assign s1_a = (m_a[15:14] == 2'b01) ? m_a[15:0] : 16'b0;
assign s1_do = (m_a[15:14] == 2'b01) ? m_do : 16'b0;
assign s1_we = (m_a[15:14] == 2'b01) ? m_we : 1'b0;

assign s2_a = (m_a[15:14] == 2'b10) ? m_a[15:0] : 16'b0;
assign s2_do = (m_a[15:14] == 2'b10) ? m_do : 16'b0;
assign s2_we = (m_a[15:14] == 2'b10) ? m_we : 1'b0;

assign s3_a = (m_a[15:14] == 2'b11) ? m_a[15:0] : 16'b0;
assign s3_do = (m_a[15:14] == 2'b11) ? m_do : 16'b0;
assign s3_we = (m_a[15:14] == 2'b11) ? m_we : 1'b0;

// Output routing

assign m_di =
  (state == 2'b00) ? s0_di :
  (state == 2'b01) ? s1_di :
  (state == 2'b10) ? s2_di : s3_di;

task init;
begin
  state <= 2'b0;
end
endtask

// State
always @(posedge sys_clk) begin
  if (sys_rst == 1'b1) begin
    init;
  end else begin
    state <= m_a[15:14];
  end
end

initial begin
  init;
end

endmodule
