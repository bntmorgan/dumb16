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

module d16_aleas (
  input sys_clk,
  input sys_rst,
  input [7:0] di_ex_op,
  input [15:0] di_ex_a,
  input [7:0] ex_mem_op,
  input [15:0] ex_mem_a,
  input [7:0] li_di_op,
  input [15:0] li_di_a,
  input [15:0] li_di_b,
  input [15:0] li_di_c,
  input jmp,
  output [7:0] li_di_op_out,
  output en
);

`include "d16.vh"

wire len;

assign len =
    (
      ~jmp & ( // if we jump, there is no aleas anymore
      (
        (
          (
            (
              (ex_mem_a == li_di_b) |
              (ex_mem_a == li_di_c)
            ) &
            (
              li_di_op == D16_OP_ADD |
              li_di_op == D16_OP_SUB |
              li_di_op == D16_OP_SHL |
              li_di_op == D16_OP_SHR |
              li_di_op == D16_OP_OR  |
              li_di_op == D16_OP_AND |
              li_di_op == D16_OP_EQU |
              li_di_op == D16_OP_LTE |
              li_di_op == D16_OP_GTE |
              li_di_op == D16_OP_LT  |
              li_di_op == D16_OP_GT  |
              li_di_op == D16_OP_STP // we read two registers here !
            )
          ) |
          (
            ex_mem_a == li_di_b &
            (
              li_di_op == D16_OP_JMZ |
              li_di_op == D16_OP_JMR |
              li_di_op == D16_OP_COP |
              li_di_op == D16_OP_STR
            )
          )
        ) &
        (
          ex_mem_op == D16_OP_ADD |
          ex_mem_op == D16_OP_SUB |
          ex_mem_op == D16_OP_SHL |
          ex_mem_op == D16_OP_SHR |
          ex_mem_op == D16_OP_OR  |
          ex_mem_op == D16_OP_AND |
          ex_mem_op == D16_OP_EQU |
          ex_mem_op == D16_OP_LTE |
          ex_mem_op == D16_OP_GTE |
          ex_mem_op == D16_OP_LT  |
          ex_mem_op == D16_OP_GT  |
          ex_mem_op == D16_OP_COP |
          ex_mem_op == D16_OP_AFC |
          ex_mem_op == D16_OP_LOD |
          ex_mem_op == D16_OP_LOP
        )
      ) |
      (
        (
          (
            (
              (di_ex_a == li_di_b) |
              (di_ex_a == li_di_c)
            ) &
            (
              li_di_op == D16_OP_ADD |
              li_di_op == D16_OP_SUB |
              li_di_op == D16_OP_SHL |
              li_di_op == D16_OP_SHR |
              li_di_op == D16_OP_OR  |
              li_di_op == D16_OP_AND |
              li_di_op == D16_OP_EQU |
              li_di_op == D16_OP_LTE |
              li_di_op == D16_OP_GTE |
              li_di_op == D16_OP_LT  |
              li_di_op == D16_OP_GT  |
              li_di_op == D16_OP_STP // we read two registers here !
            )
          ) |
          (
            di_ex_a == li_di_b &
            (
              li_di_op == D16_OP_JMZ |
              li_di_op == D16_OP_JMR |
              li_di_op == D16_OP_COP |
              li_di_op == D16_OP_STR
            )
          )
        ) &
        (
          di_ex_op == D16_OP_ADD |
          di_ex_op == D16_OP_SUB |
          di_ex_op == D16_OP_SHL |
          di_ex_op == D16_OP_SHR |
          di_ex_op == D16_OP_OR  |
          di_ex_op == D16_OP_AND |
          di_ex_op == D16_OP_EQU |
          di_ex_op == D16_OP_LTE |
          di_ex_op == D16_OP_GTE |
          di_ex_op == D16_OP_LT  |
          di_ex_op == D16_OP_GT  |
          di_ex_op == D16_OP_COP |
          di_ex_op == D16_OP_AFC |
          di_ex_op == D16_OP_LOD |
          di_ex_op == D16_OP_LOP
        )
      )
    )) ? 1'b0 : 1'b1;

assign en = len;
assign li_di_op_out = (len == 1'b0) ? 8'b0 : li_di_op;

endmodule
