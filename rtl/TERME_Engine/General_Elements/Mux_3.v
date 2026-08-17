// =============================================================================
// Project Name:   TERME
// File Name:      Mux_3.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-9
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================
`timescale 1ns/1ns

module Mux_3 #(parameter size = 32)(
    input  [1 : 0]   select,
    input  [size - 1 : 0]  in_1,
    input  [size - 1 : 0]  in_2,
    input  [size - 1 : 0]  in_3,
    output reg [size - 1 : 0]  mux_out
);

    always @(in_1,in_2,in_3,select) begin
        if (select == 2'b00)
            mux_out  =  in_1;
        else if (select == 2'b01)
            mux_out  = in_2;
        else if (select == 2'b10)
            mux_out  = in_3;
        else   mux_out  =  32'bz;

end 
endmodule
