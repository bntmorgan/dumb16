parameter D16_OP_NOP = 8'h00;

// Arithmetic instructions
parameter D16_OP_ADD = 8'h01;
parameter D16_OP_SUB = 8'h02;
parameter D16_OP_SHL = 8'h03;
parameter D16_OP_SHR = 8'h04;
parameter D16_OP_OR  = 8'h05;
parameter D16_OP_AND = 8'h06;
parameter D16_OP_EQU = 8'h07;
parameter D16_OP_LTE = 8'h08;
parameter D16_OP_GTE = 8'h09;
parameter D16_OP_LT  = 8'h0a;
parameter D16_OP_GT  = 8'h0b;

// Registers
parameter D16_OP_AFC = 8'hd0;
parameter D16_OP_COP = 8'hd1;

// Memory
parameter D16_OP_LOD = 8'he0;
parameter D16_OP_STR = 8'he1;
parameter D16_OP_LOP = 8'he2;
parameter D16_OP_STP = 8'he3;
parameter D16_OP_LPR = 8'he4;
parameter D16_OP_SPR = 8'he5;

// Affection and jumps
parameter D16_OP_JMP = 8'hf0;
parameter D16_OP_JMZ = 8'hf1;
parameter D16_OP_JMR = 8'hf2;
