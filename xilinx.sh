#!/bin/zsh
XILINX_BASE="/home/bmorgan/Xilinx"
XILINX_VERSION="14.7"
DISPLAY=:0
export XIL_IMPACT_USE_LIBUSB=1
# export LD_PRELOAD="/usr/lib64/libstdc++.so.6 ~/Xilinx/14.7/ISE_DS/common/lib/lin64/libusb-driver.so"
export LD_PRELOAD=~/Xilinx/14.7/ISE_DS/common/lib/lin64/libusb-driver.so
emulate sh
source ${XILINX_BASE}/${XILINX_VERSION}/ISE_DS/settings64.sh
emulate zsh
# Bug in frequency
export LC_NUMERIC=en_US.UTF-8
