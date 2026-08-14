// =============================================================================
// Project Name:   TERME
// File Name:      Decode_Execute.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-9
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================
`timescale 1ns/1ns

module Decode_Execute #(parameter size = 32) (
    input                       clk,
    input                       rst,

    input        [2        : 0] Immediate_Type_i,
    input                       Regread_i,
    input                       ImmEnable_i,
    input        [1        : 0] ResultSrc_i,
    input        [1        : 0] ALUSrc_i,
    input        [4        : 0] ALUControl_i,
    input        [1        : 0] ForwardA_i,
    input        [1        : 0] ForwardB_i,
    input                       Jump_i,
    input                       Regwrite_mwb_i,
    input                       BrchEnable_i,
    input                       Mul_Start_i,
    input                       Mul_Hi_i,
    input                       Mul_Signa_i,
    input                       Mul_Signb_i,
    output                      PCSrc_dex_o,
    output                      Mul_Busy_dex_o,
    output                      Mul_Done_dex_o,

    input        [size - 1 : 0] PC_Out_i,
    input        [size - 1 : 0] PC_Plus_i,
    input        [size - 1 : 0] Instruction_i,
    input        [4        : 0] Rd_mwb_i,
    input        [size - 1 : 0] Writeback_Result_i,
    output       [4        : 0] Rs1_dex_o,
    output       [4        : 0] Rs2_dex_o,
    output       [4        : 0] Rd_dex_o,
    output       [6        : 0] OPCode_dex_o,
    output       [2        : 0] Funct3_dex_o,
    output       [6        : 0] Funct7_dex_o,
    output       [11       : 0] Funct12_dex_o,
    output                      OPB5_dex_o,
    output       [size - 1 : 0] Sign_Extended_dex_o,
    output       [size - 1 : 0] Alu_Result_dex_o,
    output       [size - 1 : 0] SrcB_dex_o,
    output       [size - 1 : 0] SrcA_dex_o,
    output       [size - 1 : 0] Mul_Result_dex_o
);

    wire         [size - 1 : 0] ReadReg1_rf;
    wire         [size - 1 : 0] ReadReg2_rf;
    wire         [size - 1 : 0] SrcA_al;
    wire         [size - 1 : 0] SrcB_al;
    wire         [size - 1 : 0] Alu_Result_al;
    wire         [size - 1 : 0] Sign_Extended_se;
    wire                        BrchTaken_bd;
    wire         [size - 1 : 0] operand1;
    wire         [size - 1 : 0] operand2;

    assign OPCode_dex_o        = Instruction_i[6  :  0];
    assign Funct3_dex_o        = Instruction_i[14 : 12];
    assign Funct7_dex_o        = Instruction_i[31 : 25];
    assign Funct12_dex_o       = Instruction_i[31 : 20];
    assign OPB5_dex_o          = Instruction_i[5];
    assign Rs1_dex_o           = Instruction_i[19 : 15];
    assign Rs2_dex_o           = Instruction_i[24 : 20];
    assign Rd_dex_o            = Instruction_i[11 :  7];
    assign Sign_Extended_dex_o = Sign_Extended_se;
    assign Alu_Result_dex_o    = Alu_Result_al;
    assign SrcB_dex_o          = SrcB_al;
    assign SrcA_dex_o          = SrcA_al;
    assign PCSrc_dex_o         = (BrchTaken_bd) | Jump_i;


    Regfile RF_dex (
        .clk                (clk),
        .rst                (rst),
        .Regwrite_i         (Regwrite_mwb_i),
        .Regread_i          (Regread_i),
        .Read_Reg1_i        (Rs1_dex_o),
        .Read_Reg2_i        (Rs2_dex_o),
        .Read_Reg3_i        (Rd_mwb_i), 
        .Write_Data_i       (Writeback_Result_i), 
        .Read_Data1_rf_o    (ReadReg1_rf),
        .Read_Data2_rf_o    (ReadReg2_rf)
    );


    Sign_Extension SE_dex (
        .Instruction_i      (Instruction_i[31 : 7]),
        .OPCode_i           (OPCode_dex_o),
        .Funct3_i           (Funct3_dex_o),
        .ImmEnable_i        (ImmEnable_i),
        .Immediate_Type_i   (Immediate_Type_i),
        .Sign_Extended_se_o (Sign_Extended_se)
    );

    Branch_Unit #(.size(size)) BJU_dex(
        .BrchEnable_i       (BrchEnable_i),
        .BrchTaken_bd_o     (BrchTaken_bd),
        .Funct3_i           (Funct3_dex_o),
        .Operand1_i         (SrcA_al),
        .Operand2_i         (SrcB_al)
    );

    ALU_Lane #(.size(size)) AL_dex(
        .clk                (clk),
        .rst                (rst),
        .PC_Out_i           (PC_Out_i),
        .Read_data1_i       (ReadReg1_rf),
        .Read_data2_i       (ReadReg2_rf),
        .Writeback_Result_i (Writeback_Result_i),
        .ForwardA_i         (ForwardA_i),
        .ForwardB_i         (ForwardB_i),
        .ALUSrc_i           (ALUSrc_i),
        .Sign_Extended_i    (Sign_Extended_se),
        .ALUControl_i       (ALUControl_i),
        .Alu_Result_al_o    (Alu_Result_al),
        .SrcA_dex_al_o      (SrcA_al),
        .SrcB_dex_al_o      (SrcB_al),
        .operand1_o         (operand1),
        .operand2_o         (operand2)
    );

    Mul_Unit #(.size(size)) MUL_dex(
        .clk                (clk),
        .rst                (rst),
        .Mul_Start_i        (Mul_Start_i),
        .Mul_Hi_i           (Mul_Hi_i),
        .Mul_Signa_i        (Mul_Signa_i),
        .Mul_Signb_i        (Mul_Signb_i),
        .Mul_Busy_mul_o     (Mul_Busy_dex_o),
        .Mul_Done_mul_o     (Mul_Done_dex_o),
        .Operand_a_i        (operand1),
        .Operand_b_i        (operand2),
        .Mul_Result_mul_o   (Mul_Result_dex_o)
    );

endmodule