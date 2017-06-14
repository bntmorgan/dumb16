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

module d16_cpt16 (
  input sys_clk,
  input sys_rst,
  input dir,
  input load,
  input en,
  input [15:0] din,
  output [15:0] dout
);

reg [15:0] cpt;

task init;
begin
  cpt <= 16'b0;
end
endtask

initial begin
  init;
end

assign dout = cpt;

reg len;

always @(posedge sys_clk) begin
//  len <= en;
  if (sys_rst == 1'b1) begin
    init;
  end else begin
    if (en == 1'b1) begin
      if (load == 1'b1) begin
        if (dir == 1'b1) begin
          cpt <= din;
        end else begin
          cpt <= din;
        end
      end else begin
        if (dir == 1'b1) begin
          cpt <= cpt + 16'h04;
        end else begin
          cpt <= cpt - 16'h04;
        end
      end
//      // Negedge, this is an alea, readjust ip
//    end else if (len == 1'b1) begin
//      if (dir == 1'b1) begin
//        cpt <= cpt - 16'h04;
//      end else begin
//        cpt <= cpt + 16'h04;
//      end
    end
  end
end

endmodule
