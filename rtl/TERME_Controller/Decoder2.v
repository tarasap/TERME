// =============================================================================
// Project Name:   TERME
// File Name:      Decoder2.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-9
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================

`timescale 1ns / 1ps

module Decoder2 ( 
    input             [6  : 0] OPCode_i,
    input             [2  : 0] Funct3_i,
    input             [11 : 0] Funct12_i,
    
    output reg        [1  : 0] ResultSrc_d2_o,
    output reg        [1  : 0] ALUOp_d2_o,
    output reg        [1  : 0] ALUSrc_d2_o,
    output reg        [2  : 0] R_Type_d2_o,               
    output reg        [1  : 0] W_Type_d2_o,  
    output reg                 Mem_Write_d2_o,  
    output reg                 Mem_Read_d2_o,  
    output            [2  : 0] Immediate_Type_d2_o,  
    output reg                 Regwrite_d2_o,            
    output reg                 Jump_d2_o,
    output reg                 Mret_d2_o
);

    assign Immediate_Type_d2_o = (OPCode_i == 7'b0010011 || 
                                  OPCode_i == 7'b0000011 || 
                                  OPCode_i == 7'b1100111) ? 3'b000 : 
                                 (OPCode_i == 7'b0100011) ? 3'b001 : 
                                 (OPCode_i == 7'b1100011) ? 3'b010 : 
                                 (OPCode_i == 7'b1101111) ? 3'b011 : 
                                                            3'b100;

    always @(*) begin
        {ALUOp_d2_o, W_Type_d2_o, Regwrite_d2_o, ALUSrc_d2_o, ResultSrc_d2_o, Jump_d2_o, R_Type_d2_o, Mem_Read_d2_o, Mem_Write_d2_o, Mret_d2_o} = 0;
        
        case (OPCode_i)
            7'b0000011: begin
                ALUSrc_d2_o    = 2'b10;
                Regwrite_d2_o  = 1'b1;
                ALUOp_d2_o     = 2'b00;
                ResultSrc_d2_o = 2'b01;
                case (Funct3_i)
                    3'b000:  begin Mem_Read_d2_o = 1'b1; R_Type_d2_o = 3'b001; end
                    3'b001:  begin Mem_Read_d2_o = 1'b1; R_Type_d2_o = 3'b010; end
                    3'b010:  begin Mem_Read_d2_o = 1'b1; R_Type_d2_o = 3'b011; end
                    3'b100:  begin Mem_Read_d2_o = 1'b1; R_Type_d2_o = 3'b100; end
                    3'b101:  begin Mem_Read_d2_o = 1'b1; R_Type_d2_o = 3'b101; end
                    default: begin Mem_Read_d2_o = 1'b1; R_Type_d2_o = 3'b000; end
                endcase
            end
            7'b0100011: begin
                case (Funct3_i)
                    3'b000:  W_Type_d2_o = 2'b01;
                    3'b001:  W_Type_d2_o = 2'b10;
                    3'b010:  W_Type_d2_o = 2'b11;
                    default: W_Type_d2_o = 2'b00;
                endcase
                Mem_Write_d2_o = 1'b1;
                ALUSrc_d2_o    = 2'b10;
                Regwrite_d2_o  = 1'b0;
                ALUOp_d2_o     = 2'b00;
            end
            7'b0110011: begin
                ALUSrc_d2_o    = 2'b00;
                Regwrite_d2_o  = 1'b1;
                ALUOp_d2_o     = 2'b01;
                ResultSrc_d2_o = 2'b00;
            end
            7'b0010011: begin
                ALUSrc_d2_o    = 2'b10;
                Regwrite_d2_o  = 1'b1;
                ALUOp_d2_o     = 2'b01;
                ResultSrc_d2_o = 2'b00;
            end
            7'b1100011: begin
                ALUSrc_d2_o    = 2'b00;
                Regwrite_d2_o  = 1'b0;
                ALUOp_d2_o     = 2'b10;
                ALUSrc_d2_o    = 2'b11;
            end
            7'b1101111: begin
                Regwrite_d2_o  = 1'b1;
                Jump_d2_o      = 1'b1;
                ResultSrc_d2_o = 2'b10;
                ALUSrc_d2_o    = 2'b11;
            end
            7'b1100111: begin
                Regwrite_d2_o  = 1'b1;
                Jump_d2_o      = 1'b1;
                ResultSrc_d2_o = 2'b10;
                ALUSrc_d2_o    = 2'b10;
                ALUOp_d2_o     = 2'b00;
            end
            7'b0110111: begin
                Regwrite_d2_o  = 1'b1;
                ALUSrc_d2_o    = 2'b10;
                ResultSrc_d2_o = 2'b00;
                ALUOp_d2_o     = 2'b11;
            end
            7'b0010111: begin
                Regwrite_d2_o  = 1'b1;
                ALUSrc_d2_o    = 2'b11;
                ResultSrc_d2_o = 2'b00;
                ALUOp_d2_o     = 2'b00;
            end
            7'b1110011: begin
                if (Funct3_i == 3'b000) begin
                    Regwrite_d2_o = 1'b0; 
                    if (Funct12_i == 12'h302) begin
                        Mret_d2_o = 1'b1; 
                    end
                end else begin
                    Regwrite_d2_o  = 1'b1;
                    ResultSrc_d2_o = 2'b11; 
                end
            end    
        endcase
    end

endmodule
