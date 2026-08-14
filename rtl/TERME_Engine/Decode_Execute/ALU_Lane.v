// =============================================================================
// Project Name:   TERME
// File Name:      ALU_Lane.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-9
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================
`timescale 1ns/1ns

module ALU_Lane #(parameter size = 32)(
    input                     clk,
    input                     rst,

    input      [1        : 0] ForwardA_i, 
    input      [1        : 0] ForwardB_i,
    input      [1        : 0] ALUSrc_i,
    input      [4        : 0] ALUControl_i,
    
    input      [size - 1 : 0] PC_Out_i,
    input      [size - 1 : 0] Read_data1_i,
    input      [size - 1 : 0] Read_data2_i,
    input      [size - 1 : 0] Writeback_Result_i,
    input      [size - 1 : 0] Sign_Extended_i,
    output     [size - 1 : 0] Alu_Result_al_o,
    output     [size - 1 : 0] SrcA_dex_al_o,
    output     [size - 1 : 0] SrcB_dex_al_o,
    output     [size - 1 : 0] operand1_o,
    output     [size - 1 : 0] operand2_o
);

    

    Mux_3 #(.size(size)) M_ForwardA_i(
        .select   (ForwardA_i),
        .in_1     (Read_data1_i),
        .in_2     (Writeback_Result_i),
        .in_3     (32'b0),
        .mux_out  (SrcA_dex_al_o)
    );

    Mux_3 #(.size(size)) M_ForwardB_i(
        .select   (ForwardB_i),
        .in_1     (Read_data2_i),
        .in_2     (Writeback_Result_i), 
        .in_3     (Alu_Result_al_o),
        .mux_out  (SrcB_dex_al_o)
    );

    Mux_2 #(.size(size)) M1 (
        .select   (ALUSrc_i[0]),
        .in_1     (SrcA_dex_al_o),
        .in_2     (PC_Out_i), 
        .mux_out  (operand1_o)
    );

    Mux_2 #(.size(size)) M2 (
        .select   (ALUSrc_i[1]),
        .in_1     (SrcB_dex_al_o),
        .in_2     (Sign_Extended_i),
        .mux_out  (operand2_o)
    );

    ALU #(.size(size)) alu (
        .clk             (clk),  
        .rst             (rst),
        .ALUControl_i    (ALUControl_i),
        .Operand1_i      (operand1_o),
        .Operand2_i      (operand2_o),
        .Result_alu_o    (Alu_Result_al_o)
    );
    
endmodule