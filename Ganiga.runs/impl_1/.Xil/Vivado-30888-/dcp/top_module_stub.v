// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module top_module(CLK100MHZ, BTNL, BTNR, BTNC, BTNU, sw0, sw1, sw2, HS, VS, RED, GREEN, BLUE);
  input CLK100MHZ;
  input BTNL;
  input BTNR;
  input BTNC;
  input BTNU;
  input sw0;
  input sw1;
  input sw2;
  output HS;
  output VS;
  output [3:0]RED;
  output [3:0]GREEN;
  output [3:0]BLUE;
endmodule
