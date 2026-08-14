// =============================================================================
// Project Name:   TERME
// File Name:      Pipe_Register.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-9
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================
`timescale 1ns/1ns

module Pipe_Register #(parameter size = 32)(clk, rst, in, en, clr, out);
	input 					clk;
	input	 				rst;
	
	input 					en;
	input 					clr;

	input 		[size-1:0] 	in;
	output reg 	[size-1:0] 	out;

	always@(posedge clk or posedge rst) begin
		if(rst) 		out <= 0;
		else if (clr) 	out <= 0;
		else if (en) 	out <= in;
	end
endmodule