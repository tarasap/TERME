// =============================================================================
// Project Name:   TERME
// File Name:      Decoder1.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-9
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================

`timescale 1ns / 1ps

module Decoder1 ( 
    input      [6 : 0] OPCode_i,
    
    output reg         ImmEnable_d1_o,            
    output reg         Regread_d1_o,
    output reg         BrchEnable_d1_o
);

    always @(OPCode_i) begin
        {ImmEnable_d1_o, Regread_d1_o, BrchEnable_d1_o} = 0;

        case (OPCode_i)
            7'b0000011: begin
                Regread_d1_o    = 1'b1;
                ImmEnable_d1_o  = 1'b1;    
            end
            7'b0100011: begin
                Regread_d1_o    = 1'b1;
                ImmEnable_d1_o  = 1'b1;
            end
            7'b0110011: begin
                Regread_d1_o    = 1'b1;
            end
            7'b0010011: begin
                Regread_d1_o    = 1'b1;
                ImmEnable_d1_o  = 1'b1;
            end
            7'b1100011: begin
                Regread_d1_o    = 1'b1;
                ImmEnable_d1_o  = 1'b1;
                BrchEnable_d1_o = 1'b1;
            end
            7'b1101111: begin
                ImmEnable_d1_o  = 1'b1;
            end
            7'b1100111: begin
                Regread_d1_o    = 1'b1;
                ImmEnable_d1_o  = 1'b1;
            end
            7'b0110111: begin
                ImmEnable_d1_o  = 1'b1;
            end
            7'b0010111: begin
                ImmEnable_d1_o  = 1'b1;
            end
            7'b1110011: begin
                ImmEnable_d1_o  = 1'b1;
            end  
        endcase
    end

endmodule