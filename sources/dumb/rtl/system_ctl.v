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

module system_ctl (
  // System
  input sys_clk,
  input sys_rst,
  // Data bus
  output reg [15:0] di,
  input we,
  input [15:0] a,
  input [15:0] do,
  // LEDs
  output reg [7:0] led,
  // Switches
  input [7:0] sw,
  // User buttons
  input [3:0] btn
);

parameter SYSTEM_CTL_ADDR_LEDS = 14'h0000;
parameter SYSTEM_CTL_ADDR_SWS = 14'h0002;
parameter SYSTEM_CTL_ADDR_BTNS = 14'h0004;

task init;
begin
  led <= 8'b0;
  di <= 16'b0;
end
endtask

initial begin
  init;
end

always @(posedge sys_clk) begin
  if (sys_rst == 1'b1) begin
    init;
  end else begin
  di <= 16'b0;
    // Read
    case (a[13:0])
      SYSTEM_CTL_ADDR_LEDS: di <= {8'b0, led};
      SYSTEM_CTL_ADDR_SWS: di <= {8'b0, sw};
      SYSTEM_CTL_ADDR_BTNS: di <= {11'b0, btn};
    endcase
    // Write
    if (we == 1'b1) begin
      case (a[13:0])
        SYSTEM_CTL_ADDR_LEDS: begin
          led <= do[7:0];
        end
      endcase
    end
  end
end

endmodule
