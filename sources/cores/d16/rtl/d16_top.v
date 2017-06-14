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

module d16_top (
  input sys_clk,
  input sys_rst,
  // Instructions bus
  input [31:0] ins_di,
  output [15:0] ins_a,
  // Data bus
  input [15:0] data_di,
  output data_we,
  output [15:0] data_a,
  output [15:0] data_do
);

// TODO LOP is buggy

`include "d16.vh"

task init;
begin
end
endtask

initial begin
  init;
end

// Interconnection wires

wire [15:0] ip;

// Pipeline
wire [7:0] li_di_op_in;
wire [7:0] li_di_op_out;
wire [15:0] li_di_a_in;
wire [15:0] li_di_a_out;
wire [15:0] li_di_b_in;
wire [15:0] li_di_b_out;
wire [15:0] li_di_c_in;
wire [15:0] li_di_c_out;

wire [7:0] di_ex_op_in;
wire [7:0] di_ex_op_out;
wire [15:0] di_ex_a_in;
wire [15:0] di_ex_a_out;
wire [15:0] di_ex_b_in;
wire [15:0] di_ex_b_out;
wire [15:0] di_ex_c_in;
wire [15:0] di_ex_c_out;

wire [7:0] ex_mem_op_in;
wire [7:0] ex_mem_op_out;
wire [15:0] ex_mem_a_in;
wire [15:0] ex_mem_a_out;
wire [15:0] ex_mem_b_in;
wire [15:0] ex_mem_b_out;
wire [15:0] ex_mem_c_in;
wire [15:0] ex_mem_c_out;

wire [7:0] mem_re_op_in;
wire [7:0] mem_re_op_out;
wire [15:0] mem_re_a_in;
wire [15:0] mem_re_a_out;
wire [15:0] mem_re_b_in;
wire [15:0] mem_re_b_out;
wire [15:0] mem_re_b_out_sync;
wire [15:0] mem_re_c_in;
wire [15:0] mem_re_c_out;

// ALU
wire [15:0] alu_s;
wire alu_n;
wire alu_o;
wire alu_z;
wire alu_c;
wire [2:0] alu_ctrl_alu;
wire [15:0] alu_a;
wire [15:0] alu_b;

// Aleas unit
wire [7:0] ah_di_ex_op;
wire [15:0] ah_di_ex_a;
wire [7:0] ah_ex_mem_op;
wire [15:0] ah_ex_mem_a;
wire [7:0] ah_li_di_op;
wire [15:0] ah_li_di_a;
wire [15:0] ah_li_di_b;
wire [15:0] ah_li_di_c;
wire ah_en;
wire [7:0] ah_li_di_op_out;

// JMP unit
wire jh_sys_rst;
wire [15:0] jh_adr;
wire jh_load;

// Registers
wire [15:0] regs_qa;
wire [15:0] regs_qb;
wire [15:0] regs_data;
wire regs_w;

// IP
d16_cpt16 reg_ip (
  .sys_clk(sys_clk),
  .sys_rst(sys_rst),
  .dir(1'b1),
  .load(jh_load),
  .en(ah_en),
  .din(jh_adr + 16'h4),
  .dout(ip)
);

d16_alu alu (
  .sys_clk(sys_clk),
  .sys_rst(sys_rst),
  .s(alu_s),
  .n(alu_n),
  .o(alu_o),
  .z(alu_z),
  .c(alu_c),
  .ctrl_alu(alu_ctrl_alu),
  .a(alu_a),
  .b(alu_b)
);

d16_aleas aleas (
  .sys_clk(sys_clk),
  .sys_rst(sys_rst), // reset to jump
  .di_ex_op(ah_di_ex_op),
  .di_ex_a(ah_di_ex_a),
  .ex_mem_op(ah_ex_mem_op),
  .ex_mem_a(ah_ex_mem_a),
  .li_di_op(ah_li_di_op),
  .li_di_a(ah_li_di_a),
  .li_di_b(ah_li_di_b),
  .li_di_c(ah_li_di_c),
  .li_di_op_out(ah_li_di_op_out),
  .jmp(jh_load),
  .en(ah_en)
);

d16_pipeline p_li_di (
  .op(li_di_op_in),
  .a(li_di_a_in),
  .b(li_di_b_in),
  .c(li_di_c_in),
  .op_out(li_di_op_out),
  .a_out(li_di_a_out),
  .b_out(li_di_b_out),
  .c_out(li_di_c_out),
  .sys_clk(sys_clk),
  .en(ah_en),
  .sys_rst(rst_li_di)
);

d16_pipeline p_di_ex (
  .op(di_ex_op_in),
  .a(di_ex_a_in),
  .b(di_ex_b_in),
  .c(di_ex_c_in),
  .op_out(di_ex_op_out),
  .a_out(di_ex_a_out),
  .b_out(di_ex_b_out),
  .c_out(di_ex_c_out),
  .sys_clk(sys_clk),
  .en(1'b1),
  .sys_rst(sys_rst | jh_sys_rst)
);

d16_pipeline p_ex_mem (
  .op(ex_mem_op_in),
  .a(ex_mem_a_in),
  .b(ex_mem_b_in),
  .c(ex_mem_c_in),
  .op_out(ex_mem_op_out),
  .a_out(ex_mem_a_out),
  .b_out(ex_mem_b_out),
  .c_out(ex_mem_c_out),
  .sys_clk(sys_clk),
  .en(1'b1),
  .sys_rst(sys_rst)
);

d16_pipeline p_mem_re (
  .op(mem_re_op_in),
  .a(mem_re_a_in),
  .b(mem_re_b_in),
  .c(mem_re_c_in),
  .op_out(mem_re_op_out),
  .a_out(mem_re_a_out),
  .b_out(mem_re_b_out_sync),
  .c_out(mem_re_c_out),
  .sys_clk(sys_clk),
  .en(1'b1),
  .sys_rst(sys_rst)
);

d16_registers regs (
  .sys_clk(sys_clk),
  .sys_rst(sys_rst),
  .addr_a(li_di_b_out[3:0]),
  .addr_b(li_di_c_out[3:0]),
  .addr_w(mem_re_a_out[3:0]),
  .w(regs_w),
  .data(regs_data),
  .qa(regs_qa),
  .qb(regs_qb)
);

d16_decode decode (
  .instr(ins_di),
  .op_out(li_di_op_in),
  .a_out(li_di_a_in),
  .b_out(li_di_b_in),
  .c_out(li_di_c_in)
);

d16_jmp jmp (
  .sys_clk(sys_clk),
  .sys_rst(sys_rst),
  .op(di_ex_op_out),
  .a(di_ex_a_out),
  .z(alu_z),
  .li_di_rst(jh_sys_rst),
  .mem_addr(jh_adr),
  .load(jh_load)
);

// Mux and logic

// Write to register bench
assign regs_w =
  ( D16_OP_COP == mem_re_op_out || D16_OP_AFC == mem_re_op_out ||
    D16_OP_ADD == mem_re_op_out || D16_OP_SUB == mem_re_op_out ||
    D16_OP_SHL == mem_re_op_out || D16_OP_SHR == mem_re_op_out ||
    D16_OP_LOD == mem_re_op_out || D16_OP_LOP == mem_re_op_out ||
    D16_OP_EQU == mem_re_op_out) ? 1'b1 : 1'b0;

// Alu decode
assign alu_ctrl_alu =
  (di_ex_op_out[7:3] == 5'b0) ? di_ex_op_out[2:0] :
  // if LOP then add !
  (di_ex_op_out == D16_OP_LOP || di_ex_op_out == D16_OP_STP) ? 3'b001 :
  // if JMZ then sub for non synced ALU flags version
  (di_ex_op_out == D16_OP_JMZ) ? 3'b010 : 3'b0;

// Alu out
assign ex_mem_b_in =
  ( di_ex_op_out == D16_OP_ADD || di_ex_op_out == D16_OP_SUB ||
    di_ex_op_out == D16_OP_SHL || di_ex_op_out == D16_OP_SHR ||
    di_ex_op_out == D16_OP_LOP || di_ex_op_out == D16_OP_EQU) ? alu_s :
  (di_ex_op_out == D16_OP_STP) ? di_ex_c_out : di_ex_b_out;

// Data memory
assign data_we = (ex_mem_op_out == D16_OP_STR || ex_mem_op_out == D16_OP_STP) ?
  1'b1 : 1'b0;
// Synced memory !!! mux is in output
assign mem_re_b_out =
  (mem_re_op_out == D16_OP_LOD || mem_re_op_out == D16_OP_LOP) ?
  data_di : mem_re_b_out_sync;
assign mem_re_b_in = ex_mem_b_out;
assign data_a = (ex_mem_op_out == D16_OP_STR || ex_mem_op_out == D16_OP_STP) ?
  ex_mem_a_out : ex_mem_b_out;

assign di_ex_op_in = ah_li_di_op_out;
assign di_ex_a_in = li_di_a_out;

// Immediate or address
assign di_ex_b_in =
  ( li_di_op_out == D16_OP_AFC || li_di_op_out == D16_OP_LOD ||
    li_di_op_out == D16_OP_LOP) ? li_di_b_out : regs_qa;

// Registers
assign di_ex_c_in = (li_di_op_out == D16_OP_JMZ) ? 16'b0 : regs_qb;

// ALU
assign alu_a = (di_ex_op_out == D16_OP_STP) ? di_ex_a_out : di_ex_b_out;
assign alu_b = (di_ex_op_out == D16_OP_STP) ? di_ex_b_out : di_ex_c_out;

assign ex_mem_op_in = di_ex_op_out;
assign ex_mem_a_in = (di_ex_op_out == D16_OP_STP) ? alu_s : di_ex_a_out;

assign mem_re_op_in = ex_mem_op_out;
assign mem_re_a_in = ex_mem_a_out;

assign data_do = ex_mem_b_out;

assign ah_di_ex_op = di_ex_op_out;
assign ah_di_ex_a = di_ex_a_out;
assign ah_ex_mem_op = ex_mem_op_out;
assign ah_ex_mem_a = ex_mem_a_out;
assign ah_li_di_op = li_di_op_out;
assign ah_li_di_a = li_di_a_out;
assign ah_li_di_b = li_di_b_out;
assign ah_li_di_c = li_di_c_out;

assign ex_mem_c_in = di_ex_c_out;
assign mem_re_c_in = ex_mem_c_out;
assign regs_data = mem_re_b_out;

assign ins_a =
  (ah_en == 1'b0) ? ip - 16'h4 :
  (jh_load == 1'b1) ? jh_adr : ip ;

assign rst_li_di = sys_rst | jh_sys_rst;

endmodule
