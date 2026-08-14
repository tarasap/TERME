// =============================================================================
// Project Name:   TERME
// File Name:      Regfile.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-9
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================
`timescale 1ns/1ns

module Regfile ( 
    input           clk,
    input           rst,

    input           Regwrite_i,
    input           Regread_i,
    
    input  [ 4:0]   Read_Reg1_i, 
    input  [ 4:0]   Read_Reg2_i, 
    input  [ 4:0]   Read_Reg3_i, 
    input  [31:0]   Write_Data_i,
    output [31:0]   Read_Data1_rf_o, 
    output [31:0]   Read_Data2_rf_o        
);

    reg    [31:0]   register [0:31];
    integer         i;

    assign Read_Data1_rf_o = (Regread_i) ? register[Read_Reg1_i] : 32'b0;
    assign Read_Data2_rf_o = (Regread_i) ? register[Read_Reg2_i] : 32'b0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) 
                register[i] <= 32'b0; 
        end else begin
            if (Regwrite_i && (Read_Reg3_i != 5'b0)) 
                register[Read_Reg3_i] <= Write_Data_i;
        end
    end

endmodule