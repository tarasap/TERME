// =============================================================================
// Project Name:   TERME
// File Name:      Reg.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-9
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================
`timescale 1ns/1ns

module Reg #(parameter size = 32)(
    input                       clk,
    input                       rst,

    input                       en,
    
    input      [size - 1 : 0]   d_in,
    output reg [size - 1 : 0]   q_out
);
always @(posedge clk or posedge rst) begin
    if (rst)
        q_out <= 0;
    else if(en)
        q_out <= d_in;
    
end

endmodule