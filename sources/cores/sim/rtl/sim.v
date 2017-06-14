/*
Copyright (C) 2015  Benoît Morgan

This file is part of vga-text-mode.

vga-text-mode is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

vga-text-mode is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with vga-text-mode.  If not, see <http://www.gnu.org/licenses/>.
*/

reg sys_clk;
reg sys_rst;

always #5 sys_clk = !sys_clk; // @100 MHz

initial begin
  sys_clk = 1'b1;
  sys_rst = 1'b0;
end

/* Wishbone Helpers */
task waitclock;
begin
	@(posedge sys_clk);
end
endtask

task waitnclock;
input [15:0] n;
integer i;
begin
	for(i=0;i<n;i=i+1)
		waitclock;
	end
endtask

initial begin
  $dumpfile(`__DUMP_FILE__);
  $dumpvars(0,main);
end
