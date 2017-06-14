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
reg [15:0] m_do;
reg m_we;
reg [15:0] m_a;
reg [15:0] s0_di;
reg [15:0] s1_di;
reg [15:0] s2_di;
reg [15:0] s3_di;

// Outputs
wire [15:0] m_di;
wire [15:0] s0_do;
wire s0_we;
wire [13:0] s0_a;
wire [15:0] s1_do;
wire s1_we;
wire [13:0] s1_a;
wire [15:0] s2_do;
wire s2_we;
wire [13:0] s2_a;
wire [15:0] s3_do;
wire s3_we;
wire [13:0] s3_a;

task init;
begin
  m_do <= 16'b0;
  m_we <= 1'b0;
  m_a <= 16'b0;
  s0_di <= 16'h0000;
  s1_di <= 16'h1111;
  s2_di <= 16'h2222;
  s3_di <= 16'h3333;
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

// Instantiate the Unit Under Test

conbus1x4 data_bus (
  .sys_clk(sys_clk),
  .sys_rst(sys_rst),
  .m_do(m_do),
  .m_we(m_we),
  .m_a(m_a),
  .s0_di(s0_di),
  .s1_di(s1_di),
  .s2_di(s2_di),
  .s3_di(s3_di),
  .m_di(m_di),
  .s0_do(s0_do),
  .s0_we(s0_we),
  .s0_a(s0_a),
  .s1_do(s1_do),
  .s1_we(s1_we),
  .s1_a(s1_a),
  .s2_do(s2_do),
  .s2_we(s2_we),
  .s2_a(s2_a),
  .s3_do(s3_do),
  .s3_we(s3_we),
  .s3_a(s3_a)
);

initial begin

  sys_rst <= 1'b1;

  waitnclock(2);

  sys_rst <= 1'b0;

  m_a <= 16'h0000;
  waitclock;
  m_a <= 16'h4000;
  waitclock;
  m_a <= 16'h8000;
  waitclock;
  m_a <= 16'hc000;
  waitclock;
  m_we <= 1'b1;
  m_a <= 16'h0000;
  waitclock;
  m_a <= 16'h4000;
  waitclock;
  m_a <= 16'h8000;
  waitclock;
  m_a <= 16'hc000;
  waitclock;
  m_we <= 1'b0;

  waitnclock(1);

  $finish();

end

endmodule
