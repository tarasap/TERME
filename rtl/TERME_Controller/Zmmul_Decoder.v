// =============================================================================
// Project Name:   TERME
// File Name:      Zmmul_Decoder.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-9
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================

`timescale 1ns / 1ps

module Zmmul_Decoder (
    input              Flush_i,
    input              Mul_Busy_i,
    input              Mul_Done_i,
    output             Mul_Stall_zd_o,
    output             Mul_Sel_zd_o,
    output             Mul_En_zd_o, 
    output             Mul_Start_zd_o,
    output             Mul_Hi_zd_o,      
    output             Mul_Signa_zd_o,  
    output             Mul_Signb_zd_o,

    input      [6 : 0] OPCode_i,
    input      [2 : 0] Funct3_i,
    input      [6 : 0] Funct7_i  
    
);

    localparam [6 : 0] OP_OP    = 7'b0110011;
    localparam [6 : 0] FUNCT7_M = 7'b0000001;

    assign Mul_En_zd_o     = (OPCode_i == OP_OP) & (Funct7_i == FUNCT7_M) & ~Funct3_i[2];
    assign Mul_Hi_zd_o     = |Funct3_i[1 : 0];
    assign Mul_Signa_zd_o  = ~(Funct3_i[1] & Funct3_i[0]);
    assign Mul_Signb_zd_o  = ~Funct3_i[1];                   
    assign Mul_Stall_zd_o  = Mul_En_zd_o & ~Mul_Done_i;
    assign Mul_Sel_zd_o    = Mul_Done_i;
    assign Mul_Start_zd_o  = Mul_En_zd_o;

endmodule