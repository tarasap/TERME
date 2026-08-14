// =============================================================================
// Project Name:   TERME
// File Name:      ALU_Decoder.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-9
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================
`timescale 1ns/1ns

module ALU_Decoder (
    input              OPB5_i,
    input       [2:0]  Funct3_i,
    input       [6:0]  Funct7_i,
    input       [1:0]  ALUOp_i,
    output reg  [4:0]  ALUControl_ad_o
);

wire Rtypesub;

assign Rtypesub = Funct7_i[5] & OPB5_i;

always @(OPB5_i, Funct3_i, Funct7_i, ALUOp_i) begin
    ALUControl_ad_o = 5'b00000;

    case (ALUOp_i)
        2'b00: begin
            ALUControl_ad_o = 5'b00000;
        end

        2'b01: begin
            case (Funct3_i)
                3'b000: begin
                    if (Rtypesub)
                        ALUControl_ad_o = 5'b0001;
                    else
                        ALUControl_ad_o = 5'b0000;
                end

                3'b001: begin
                    ALUControl_ad_o = 5'b00111;
                end

                3'b010: begin
                    ALUControl_ad_o = 5'b00010;
                end

                3'b011: begin
                    ALUControl_ad_o = 5'b00011;
                end

                3'b100: begin
                    ALUControl_ad_o = 5'b00100;
                end

                3'b101: begin
                    ALUControl_ad_o = Funct7_i[5] ? 5'b01001 : 5'b01000;
                end

                3'b110: begin
                    ALUControl_ad_o = 5'b00101;
                end

                3'b111: begin
                    ALUControl_ad_o = 5'b00110;
                end

                default: begin
                    ALUControl_ad_o = 5'b00000;
                end
            endcase
        end

        2'b10: begin
            ALUControl_ad_o = 5'b00000;
        end

        2'b11: begin
            ALUControl_ad_o = 5'b10000;
        end

        default: begin
            ALUControl_ad_o = 5'b00000;
        end
    endcase
end

endmodule

