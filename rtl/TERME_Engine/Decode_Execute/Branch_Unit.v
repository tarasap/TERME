// =============================================================================
// Project Name:   TERME
// File Name:      Branch_Unit.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-9
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================
`timescale 1ns/1ns

module Branch_Unit #(parameter size = 32) (
    input                     BrchEnable_i,
    output                    BrchTaken_bd_o,
    
    input      [2        : 0] Funct3_i,
    input      [size - 1 : 0] Operand1_i, 
    input      [size - 1 : 0] Operand2_i 
);

    wire       [size - 1 : 0] Rs1_gated;
    wire       [size - 1 : 0] Rs2_gated;
    wire       [size - 1 : 0] diff_bits;
    wire                      eq;
    wire                      lt_signed;
    wire                      lt_unsigned;
    reg                       taken;

    assign Rs1_gated      = Operand1_i & {(size){BrchEnable_i}};
    assign Rs2_gated      = Operand2_i & {(size){BrchEnable_i}};
    assign diff_bits      = Rs1_gated ^ Rs2_gated;
    assign eq             = BrchEnable_i && (~|diff_bits);
    assign lt_signed      = BrchEnable_i && ($signed(Rs1_gated) < $signed(Rs2_gated));
    assign lt_unsigned    = BrchEnable_i && (Rs1_gated < Rs2_gated);
    assign BrchTaken_bd_o = taken;

    always @(*) begin
        if (!BrchEnable_i) begin
            taken = 1'b0;
        end else begin
            case (Funct3_i)
                3'b000:  taken = eq;
                3'b001:  taken = ~eq;
                3'b100:  taken = lt_signed;
                3'b101:  taken = ~lt_signed;
                3'b110:  taken = lt_unsigned;
                3'b111:  taken = ~lt_unsigned;
                default: taken = 1'b0;
            endcase
        end
    end

endmodule