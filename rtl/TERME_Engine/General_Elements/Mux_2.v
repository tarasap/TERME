// =============================================================================
// Project Name:   TERME
// File Name:      Mux_2.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-9
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================
`timescale 1ns/1ns

module Mux_2 #(parameter size = 32)(

    input                       select,
    input      [size - 1 : 0]   in_1,
    input      [size - 1 : 0]   in_2,
    output     [size - 1 : 0]   mux_out
);
    assign mux_out = (select) ? in_2 : in_1;
endmodule