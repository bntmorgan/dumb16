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

module system (
  // System
  input clkin100,
  input hard_reset,
  // VGA
  output [2:0] vga_red,
  output [2:0] vga_grn,
  output [1:0] vga_blu,
  output vga_hsync,
  output vga_vsync,
  // LEDs
  output [7:0] led,
  // Switches
  input [7:0] sw,
  // User buttons
  input [3:0] btn
);

// Clock

wire clkin100_b;

IBUFG clkin66_ibuf(
	.I(clkin100),
	.O(clkin100_b)
);

wire sys_clk = clkin100_b;

// Reset

reg trigger_reset;
always @(posedge sys_clk) trigger_reset <= hard_reset;

/* Debounce it
 * and generate power-on reset.
 */
reg [19:0] rst_debounce;
reg sys_rst;
initial rst_debounce <= 20'h0000F;
initial sys_rst <= 1'b1;
always @(posedge sys_clk) begin
	if(trigger_reset)
		rst_debounce <= 20'h0000F;
	else if(rst_debounce != 20'd0)
		rst_debounce <= rst_debounce - 20'd1;
	sys_rst <= rst_debounce != 20'd0;
end

reg vga_clk0;
reg vga_clk;

task init_sys;
begin
  vga_clk <= 1'b1;
  vga_clk0 <= 1'b1;
end
endtask

// Divide sys_clk @ 100 MHz to 25 MHz

always @(posedge sys_clk) begin
  vga_clk0 <= vga_clk0 + 1'b1;
end

always @(posedge vga_clk0) begin
  vga_clk <= vga_clk + 1'b1;
end

initial begin
  init_sys;
end

// Wires

wire [31:0] ins_di;
wire [15:0] ins_a;

wire [15:0] data_di;
wire data_we;
wire [15:0] data_a;
wire [15:0] data_do;

wire [15:0] b16_di;
wire b16_we;
wire [15:0] b16_a;
wire [15:0] b16_do;

wire [15:0] vga_di;
wire vga_we;
wire [15:0] vga_a;
wire [15:0] vga_do;

wire [15:0] sys_ctl_di;
wire sys_ctl_we;
wire [15:0] sys_ctl_a;
wire [15:0] sys_ctl_do;

// System

// VGA text mode video core
vga_top vga (
  .sys_clk(sys_clk),
  .sys_rst(sys_rst),
  .vga_clk(vga_clk),
  .vga_rst(sys_rst),
  .vga_red(vga_red),
  .vga_grn(vga_grn),
  .vga_blu(vga_blu),
  .vga_hsync(vga_hsync),
  .vga_vsync(vga_vsync),
  .mem_dr(vga_di),
  .mem_we(vga_we),
  .mem_a(vga_a[11:1]),
  .mem_dw(vga_do)
);

// CPU
d16_top d16 (
  .sys_clk(sys_clk),
  .sys_rst(sys_rst),
  .ins_di(ins_di),
  .ins_a(ins_a),
  .data_di(data_di),
  .data_we(data_we),
  .data_a(data_a),
  .data_do(data_do)
);

// Data RAM
bram16 #(
  .adr_width(14)
) b16 (
  .sys_clk(sys_clk),
  .sys_rst(sys_rst),
  .di(b16_di),
  .we(b16_we),
  .a(b16_a),
  .do(b16_do)
);

// Instruction ROM
// bram32 #(
//   .adr_width(14),
//   .init_file("/home/bmorgan/documents/dumb8/dumb16/sources/dumb/rtl/rom.hex")
// )  b32 (
//   .sys_clk(sys_clk),
//   .sys_rst(sys_rst),
//   .di(ins_di),
//   .a(ins_a)
// );

// Instruction ROM
dbram32 #(
  .adr_width(14),
  .init_file("/home/bmorgan/documents/dumb16/dumb16/sources/dumb/rtl/rom.hex")
)  b32 (
  .a_clk(sys_clk),
  .a_rst(sys_rst),
  .a_di(ins_di),
  .a_a(ins_a)
);

// System controller
system_ctl sys_ctl (
  .sys_clk(sys_clk),
  .sys_rst(sys_rst),
  .di(sys_ctl_di),
  .we(sys_ctl_we),
  .a(sys_ctl_a),
  .do(sys_ctl_do),
  .led(led),
  .sw(sw),
  .btn(btn)
);

// s0 : [0x0000 - 0x3fff] RAM
// s1 : [0x4000 - 0x7fff] VGA text mode
// s2 : [0x8000 - 0xbfff] System controller
// s3 : [0xc000 - 0xffff] none
conbus1x4 data_bus (
  .sys_clk(sys_clk),
  .sys_rst(sys_rst),
  .m_di(data_di),
  .m_do(data_do),
  .m_we(data_we),
  .m_a(data_a),
  .s0_di(b16_di),
  .s0_do(b16_do),
  .s0_we(b16_we),
  .s0_a(b16_a),
  .s1_di(vga_di),
  .s1_do(vga_do),
  .s1_we(vga_we),
  .s1_a(vga_a),
  .s2_di(sys_ctl_di),
  .s2_do(sys_ctl_do),
  .s2_we(sys_ctl_we),
  .s2_a(sys_ctl_a),
  .s3_di(16'b0),
  .s3_do(),
  .s3_we(),
  .s3_a()
);

endmodule
