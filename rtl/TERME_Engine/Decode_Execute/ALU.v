// =============================================================================
// Project Name:   TERME
// File Name:      ALU.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-9
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================
`timescale 1ns/1ns

module ALU #(parameter size = 32) (
    input                     clk,
    input                     rst,

    input      [4        : 0] ALUControl_i,

    input      [size - 1 : 0] Operand1_i,
    input      [size - 1 : 0] Operand2_i,
    output reg [size - 1 : 0] Result_alu_o
);

    always @(*) begin
        Result_alu_o    = 0;
        
        case (ALUControl_i) 
            5'b00000: begin
                Result_alu_o    = Operand1_i + Operand2_i;
            end
            5'b00001: begin
                Result_alu_o    = Operand1_i - Operand2_i;
            end
            5'b00010: begin
                Result_alu_o    = ($signed(Operand1_i) < $signed(Operand2_i)) ? 1 : 0;
            end
            5'b00011: begin
                Result_alu_o    = (Operand1_i < Operand2_i) ? 1 : 0;
            end
            5'b00100: begin
                Result_alu_o    = Operand1_i ^ Operand2_i;
            end
            5'b00101: begin
                Result_alu_o    = Operand1_i | Operand2_i;
            end
            5'b00110: begin
                Result_alu_o    = Operand1_i & Operand2_i;
            end
            5'b00111: begin
                Result_alu_o    = Operand1_i << Operand2_i[4:0];
            end
            5'b01000: begin
                Result_alu_o    = Operand1_i >> Operand2_i[4:0];
            end
            5'b01001: begin
                Result_alu_o    = $signed(Operand1_i) >>> Operand2_i[4:0];
            end
            5'b01010: begin
                Result_alu_o    = ($signed(Operand1_i) >= $signed(Operand2_i)) ? 1 : 0;
            end
            5'b01011: begin
                Result_alu_o    = (Operand1_i >= Operand2_i) ? 1 : 0;
            end
            5'b10000: begin
                Result_alu_o    = Operand2_i;
            end
            default: begin
                Result_alu_o    = 0;
            end
        endcase
    end

endmodule