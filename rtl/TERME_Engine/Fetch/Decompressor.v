// =============================================================================
// Project Name:   TERME
// File Name:      Decompressor.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-9
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================
`timescale 1ns/1ns

module Decompressor #(parameter size = 32) (
    input      [      15:0] instruction_i,
    output reg [size - 1:0] instruction_dc_o
);

    wire [ 4:0] rd_c        = {2'b01, instruction_i[4:2]};
    wire [ 4:0] rs1_c       = {2'b01, instruction_i[9:7]};

    wire [11:0] lw_sw_imm   = {5'b00000, instruction_i[5], instruction_i[12:10], instruction_i[6], 2'b00};
    wire [11:0] lwsp_imm    = {4'b0000, instruction_i[3:2], instruction_i[12], instruction_i[6:4], 2'b00};
    wire [11:0] swsp_imm    = {4'b0000, instruction_i[8:7], instruction_i[12:9], 2'b00};
    wire [11:0] addi4sp_imm = {2'b00, instruction_i[10:7], instruction_i[12:11], instruction_i[5], instruction_i[6], 2'b00};
    wire [11:0] addi_imm    = {{6{instruction_i[12]}}, instruction_i[12], instruction_i[6:2]};

    always @(*) begin
        instruction_dc_o = 32'h00000000;
        case (instruction_i[1:0])
            2'b00:
                case (instruction_i[15:13])
                    3'b000: begin
                        instruction_dc_o[ 6: 0] = 7'b0010011;
                        instruction_dc_o[11: 7] = rd_c;
                        instruction_dc_o[14:12] = 3'b000;
                        instruction_dc_o[19:15] = 5'b00010;
                        instruction_dc_o[31:20] = addi4sp_imm;
                    end
                    3'b010: begin
                        instruction_dc_o[ 6: 0] = 7'b0000011;
                        instruction_dc_o[11: 7] = rd_c;
                        instruction_dc_o[14:12] = 3'b010;
                        instruction_dc_o[19:15] = rs1_c;
                        instruction_dc_o[31:20] = lw_sw_imm;
                    end
                    3'b110: begin
                        instruction_dc_o[ 6: 0] = 7'b0100011;
                        instruction_dc_o[11: 7] = lw_sw_imm[4:0];
                        instruction_dc_o[14:12] = 3'b010;
                        instruction_dc_o[19:15] = rs1_c;
                        instruction_dc_o[24:20] = rd_c;
                        instruction_dc_o[31:25] = lw_sw_imm[11:5];
                    end
                    default: instruction_dc_o = 32'h00000000;
                endcase
            2'b01: 
                case (instruction_i[15:13])
                    3'b000: begin
                        instruction_dc_o[ 6: 0] = 7'b0010011;
                        instruction_dc_o[11: 7] = instruction_i[11:7];
                        instruction_dc_o[14:12] = 3'b000;
                        instruction_dc_o[19:15] = instruction_i[11:7];
                        instruction_dc_o[31:20] = addi_imm;
                    end
                    3'b001: begin
                        instruction_dc_o[ 6: 0] = 7'b1101111;
                        instruction_dc_o[11: 7] = 5'b00001;
                        instruction_dc_o[19:12] = {8{instruction_i[12]}};
                        instruction_dc_o[   20] = instruction_i[12];
                        instruction_dc_o[30:21] = {instruction_i[8], instruction_i[10:9], instruction_i[6], instruction_i[7], instruction_i[2], instruction_i[11], instruction_i[5:3]};
                        instruction_dc_o[   31] = instruction_i[12];
                    end
                    3'b010: begin
                        instruction_dc_o[ 6: 0] = 7'b0010011;
                        instruction_dc_o[11: 7] = instruction_i[11:7];
                        instruction_dc_o[14:12] = 3'b000;
                        instruction_dc_o[19:15] = 5'b00000;
                        instruction_dc_o[31:20] = addi_imm;
                    end
                    3'b011: begin
                        if (instruction_i[11:7] == 5'b00010) begin
                            instruction_dc_o[ 6: 0] = 7'b0010011;
                            instruction_dc_o[11: 7] = 5'b00010;
                            instruction_dc_o[14:12] = 3'b000;
                            instruction_dc_o[19:15] = 5'b00010;
                            instruction_dc_o[31:20] = {{2{instruction_i[12]}}, instruction_i[12], instruction_i[4:3], instruction_i[5], instruction_i[2], instruction_i[6], 4'b0000};
                        end else begin
                            instruction_dc_o[ 6: 0] = 7'b0110111;
                            instruction_dc_o[11: 7] = instruction_i[11:7];
                            instruction_dc_o[31:12] = {{14{instruction_i[12]}}, instruction_i[12], instruction_i[6:2]};
                        end
                    end
                    3'b100: begin
                        instruction_dc_o[11: 7] = rs1_c;
                        instruction_dc_o[19:15] = rs1_c;
                        case (instruction_i[11:10])
                            2'b00: begin
                                instruction_dc_o[ 6: 0] = 7'b0010011;
                                instruction_dc_o[14:12] = 3'b101;
                                instruction_dc_o[24:20] = instruction_i[6:2];
                                instruction_dc_o[31:25] = 7'b0000000;
                            end
                            2'b01: begin
                                instruction_dc_o[ 6: 0] = 7'b0010011;
                                instruction_dc_o[14:12] = 3'b101;
                                instruction_dc_o[24:20] = instruction_i[6:2];
                                instruction_dc_o[31:25] = 7'b0100000;
                            end
                            2'b10: begin
                                instruction_dc_o[ 6: 0] = 7'b0010011;
                                instruction_dc_o[14:12] = 3'b111;
                                instruction_dc_o[31:20] = addi_imm;
                            end
                            2'b11: begin
                                instruction_dc_o[ 6: 0] = 7'b0110011;
                                instruction_dc_o[24:20] = rd_c;
                                case (instruction_i[6:5])
                                    2'b00: begin instruction_dc_o[14:12] = 3'b000; instruction_dc_o[31:25] = 7'b0100000; end
                                    2'b01: begin instruction_dc_o[14:12] = 3'b100; instruction_dc_o[31:25] = 7'b0000000; end
                                    2'b10: begin instruction_dc_o[14:12] = 3'b110; instruction_dc_o[31:25] = 7'b0000000; end
                                    2'b11: begin instruction_dc_o[14:12] = 3'b111; instruction_dc_o[31:25] = 7'b0000000; end
                                endcase
                            end
                        endcase
                    end
                    3'b101: begin
                        instruction_dc_o[ 6: 0] = 7'b1101111;
                        instruction_dc_o[11: 7] = 5'b00000;
                        instruction_dc_o[19:12] = {8{instruction_i[12]}};
                        instruction_dc_o[   20] = instruction_i[12];
                        instruction_dc_o[30:21] = {instruction_i[8], instruction_i[10:9], instruction_i[6], instruction_i[7], instruction_i[2], instruction_i[11], instruction_i[5:3]};
                        instruction_dc_o[   31] = instruction_i[12];
                    end
                    3'b110: begin
                        instruction_dc_o[ 6: 0] = 7'b1100011;
                        instruction_dc_o[    7] = instruction_i[12];
                        instruction_dc_o[11: 8] = {instruction_i[11:10], instruction_i[4:3]};
                        instruction_dc_o[14:12] = 3'b000;
                        instruction_dc_o[19:15] = rs1_c;
                        instruction_dc_o[24:20] = 5'b00000;
                        instruction_dc_o[30:25] = {{3{instruction_i[12]}}, instruction_i[6:5], instruction_i[2]};
                        instruction_dc_o[   31] = instruction_i[12];
                    end
                    3'b111: begin
                        instruction_dc_o[ 6: 0] = 7'b1100011;
                        instruction_dc_o[    7] = instruction_i[12];
                        instruction_dc_o[11: 8] = {instruction_i[11:10], instruction_i[4:3]};
                        instruction_dc_o[14:12] = 3'b001;
                        instruction_dc_o[19:15] = rs1_c;
                        instruction_dc_o[24:20] = 5'b00000;
                        instruction_dc_o[30:25] = {{3{instruction_i[12]}}, instruction_i[6:5], instruction_i[2]};
                        instruction_dc_o[   31] = instruction_i[12];
                    end
                    default: instruction_dc_o = 32'h00000000;
                endcase
            2'b10:  
                case (instruction_i[15:13])
                    3'b000: begin
                        instruction_dc_o[ 6: 0] = 7'b0010011;
                        instruction_dc_o[11: 7] = instruction_i[11:7];
                        instruction_dc_o[14:12] = 3'b001;
                        instruction_dc_o[19:15] = instruction_i[11:7];
                        instruction_dc_o[24:20] = instruction_i[6:2];
                        instruction_dc_o[31:25] = 7'b0000000;
                    end
                    3'b010: begin
                        instruction_dc_o[ 6: 0] = 7'b0000011;
                        instruction_dc_o[11: 7] = instruction_i[11:7];
                        instruction_dc_o[14:12] = 3'b010;
                        instruction_dc_o[19:15] = 5'b00010;
                        instruction_dc_o[31:20] = lwsp_imm;
                    end
                    3'b100: begin
                        if (instruction_i[12] == 1'b0) begin
                            if (instruction_i[6:2] == 5'b00000) begin
                                instruction_dc_o[ 6: 0] = 7'b1100111;
                                instruction_dc_o[11: 7] = 5'b00000;
                                instruction_dc_o[14:12] = 3'b000;
                                instruction_dc_o[19:15] = instruction_i[11:7];
                                instruction_dc_o[31:20] = 12'b0;
                            end else begin
                                instruction_dc_o[ 6: 0] = 7'b0110011;
                                instruction_dc_o[11: 7] = instruction_i[11:7];
                                instruction_dc_o[14:12] = 3'b000;
                                instruction_dc_o[19:15] = 5'b00000;
                                instruction_dc_o[24:20] = instruction_i[6:2];
                                instruction_dc_o[31:25] = 7'b0000000;
                            end
                        end else begin
                            if (instruction_i[11:7] == 5'b00000 && instruction_i[6:2] == 5'b00000) begin
                                instruction_dc_o[ 6: 0] = 7'b1110011;
                                instruction_dc_o[31:20] = 12'b000000000001;
                            end else if (instruction_i[6:2] == 5'b00000) begin
                                instruction_dc_o[ 6: 0] = 7'b1100111;
                                instruction_dc_o[11: 7] = 5'b00001;
                                instruction_dc_o[14:12] = 3'b000;
                                instruction_dc_o[19:15] = instruction_i[11:7];
                                instruction_dc_o[31:20] = 12'b0;
                            end else begin
                                instruction_dc_o[ 6: 0] = 7'b0110011;
                                instruction_dc_o[11: 7] = instruction_i[11:7];
                                instruction_dc_o[14:12] = 3'b000;
                                instruction_dc_o[19:15] = instruction_i[11:7];
                                instruction_dc_o[24:20] = instruction_i[6:2];
                                instruction_dc_o[31:25] = 7'b0000000;
                            end
                        end
                    end
                    3'b110: begin
                        instruction_dc_o[ 6: 0] = 7'b0100011;
                        instruction_dc_o[11: 7] = swsp_imm[4:0];
                        instruction_dc_o[14:12] = 3'b010;
                        instruction_dc_o[19:15] = 5'b00010;
                        instruction_dc_o[24:20] = instruction_i[6:2];
                        instruction_dc_o[31:25] = swsp_imm[11:5];
                    end
                    default: instruction_dc_o = 32'h00000000;
                endcase
        endcase            
    end 
    
endmodule