# Copyright (C) 2017  Benoît Morgan
#
# This file is part of dumb16.
#
# dumb16 is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# dumb16 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with dumb16.  If not, see <http://www.gnu.org/licenses/>.

sp              	:= $(sp).x
dirstack_$(sp)  	:= $(d)
d               	:= $(dir)

# Synthesis sources definition
SRC_VHDL_$(d)		 	:=
SRC_VERILOG_$(d) 	:=

# Board specific definitions
PKG_$(d) 				 	:= xc6slx16-3-csg324

# Top module
TOP_$(d)				 	:= system

include $(d)/sources.mk

# Constraints
CONSTRAINTS_$(d) 	:= $(d)/synthesis/common.ucf

# Target path
TARGET           	:= $(call SRC_2_BIN, $(d)/$(TOP_$(d)))

# Synthesis rules
TARGETS 				 	+= $(call GEN_TARGETS, $(TARGET))

XILINX_SRC_$(d)	= $(XILINX_SRC)/unisims/RAMB16BWER.v \
	$(XILINX_SRC)/unisims/IBUFG.v $(XILINX_SRC)/glbl.v

$(TARGET).prj						: $(d)/sources.mk $(SRC_VHDL_$(d)) $(SRC_VERILOG_$(d)) \
	sources/dumb/rtl/rom.hex
$(TARGET).prj						: VHDL 		:= $(SRC_VHDL_$(d))
$(TARGET).prj						: VERILOG := $(SRC_VERILOG_$(d))
$(TARGET).ucf						: $(CONSTRAINTS_$(d))

$(TARGET).xst						: PKG := $(PKG_$(d))
$(TARGET).xst						: TOP := $(TOP_$(d))

SIM 			      := $(call SRC_2_BIN, $(d)/system.sim)
SRC_SIM_$(d)		:= $(SRC_VERILOG_$(d)) $(d)/rtl/sim_system.v $(XILINX_SRC_$(d))
$(SIM)					: $(SRC_SIM_$(d))
$(SIM)					: SIM_CFLAGS := -I$(d)/rtl -I$(CORES_DIR)/sim/rtl/ \
 -I$(CORES_DIR)/vga/rtl -I$(CORES_DIR)/d16/rtl # -DSIMULATION
SIMS						+= $(SIM)

d                	:= $(dirstack_$(sp))
sp               	:= $(basename $(sp))
