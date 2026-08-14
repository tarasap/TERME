// =============================================================================
// Project Name:   TERME
// File Name:      Hazard_Unit.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-9
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================

`timescale 1ns / 1ps

module Hazard_Unit (
    input      [4 : 0] Rs1_dex_i,     
    input      [4 : 0] Rs2_dex_i,
    input      [4 : 0] Rd_dex_i,
    input      [4 : 0] Rd_mwb_i,   
    
    input              DMem_Interface_Req_Ready_i,    
    input              Regwrite_i, 
    input              Regwrite_mwb_i, 
    input              PCSrc_i,
    input      [1 : 0] ResultSrc_dex_i,
    input      [1 : 0] ResultSrc_mwb_i,
    input              Irq_Taken_i,
    input              Mret_i,
    input              Mul_Stall_i,
    output reg [1 : 0] ForwardA_hu_o,
    output reg [1 : 0] ForwardB_hu_o,
    output             FlushF_hu_o, 
    output             FlushDEX_hu_o, 
    output             StallF_hu_o,
    output             StallDEX_hu_o
);

    wire               DMem_Interface_Stall;

    always @(*) begin 
        ForwardA_hu_o = 2'b00;
        ForwardB_hu_o = 2'b00;

        if (Regwrite_mwb_i && Rd_mwb_i != 0) begin
            if (Rs1_dex_i == Rd_mwb_i)
                ForwardA_hu_o = 2'b01;

            if (Rs2_dex_i == Rd_mwb_i)
                ForwardB_hu_o = 2'b01;
        end
    end

    assign DMem_Interface_Stall = !DMem_Interface_Req_Ready_i;
    assign StallF_hu_o          = Mul_Stall_i | DMem_Interface_Stall;
    assign StallDEX_hu_o        = DMem_Interface_Stall;
    assign FlushF_hu_o          = PCSrc_i | Irq_Taken_i | Mret_i;   
    assign FlushDEX_hu_o        = Irq_Taken_i | Mret_i | Mul_Stall_i;  

endmodule