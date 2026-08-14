// =============================================================================
// Project Name:   TERME
// File Name:      TERME_Controller.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-9
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================

`timescale 1ns / 1ps

module TERME_Controller #(parameter size = 32) (
    input                       clk,
    input                       rst,

    input                       DMem_Interface_Req_Ready_i,
    input                       Mul_Busy_i,
    input                       Mul_Done_i,
    input               [1:0]   ResultSrc_mwb_i,
    input                       PCSrc_i,
    input                       Regwrite_mwb_i,
    output                      ImmEnable_tc_o,
    output                      Regread_tc_o,
    output                      BrchEnable_tc_o,
    output              [2:0]   Immediate_Type_tc_o,
    output              [1:0]   ResultSrc_tc_o,
    output              [1:0]   ALUSrc_tc_o,
    output                      Regwrite_tc_o,
    output              [2:0]   R_Type_tc_o,
    output              [1:0]   W_Type_tc_o,
    output                      Mem_Read_En_tc_o,
    output                      Mem_Write_En_tc_o,
    output                      Jump_tc_o,
    output              [4:0]   ALUControl_tc_o,
    output              [1:0]   ForwardA_tc_o,
    output              [1:0]   ForwardB_tc_o,
    output                      FlushF_tc_o,
    output                      FlushDEX_tc_o,
    output                      StallF_tc_o,
    output                      StallDEX_tc_o,
    output                      Irq_Taken_tc_o,
    output                      External_Activated_tc_o,
    output                      Timer_Activated_tc_o,
    output                      Software_Activated_tc_o,
    output                      Mret_tc_o,
    output                      CSR_Imm_tc_o,
    output                      CSR_En_tc_o,
    output                      Mul_Start_tc_o,
    output                      Mul_En_tc_o,
    output                      Mul_Sel_tc_o,
    output                      Mul_Hi_tc_o,
    output                      Mul_Signa_tc_o,
    output                      Mul_Signb_tc_o,

    input               [6:0]   OPCode_mwb_i,
    input               [6:0]   OPCode_fe_i,
    input               [6:0]   OPCode_i,
    input               [6:0]   Funct7_mwb_i,
    input               [2:0]   Funct3_mwb_i,
    input               [2:0]   Funct3_i,
    input               [6:0]   Funct7_i,
    input               [11:0]  Funct12_i,
    input                       OPB5_i,
    input               [4:0]   Rs1_i,
    input               [4:0]   Rs2_i,
    input               [4:0]   Rd_i,
    input               [4:0]   Rd_mwb_i,
    input                       Mip_Meip_i,
    input                       Mip_Mtip_i,
    input                       Mip_Msip_i,
    input                       Mie_Meie_i,
    input                       Mie_Mtie_i,
    input                       Mie_Msie_i,
    input                       Mstatus_Mie_i,
    input               [1:0]   Current_Privilege_i,
    output              [1:0]   CSR_Opcode_tc_o

);

wire [1:0] ALUOp;
wire       Mul_Stall;

Decoder1 D1_tc (
    .OPCode_i                   (OPCode_fe_i),
    .ImmEnable_d1_o             (ImmEnable_tc_o),
    .Regread_d1_o               (Regread_tc_o),
    .BrchEnable_d1_o            (BrchEnable_tc_o)
);

Decoder2 D2_tc (
    .OPCode_i                   (OPCode_i),
    .Funct3_i                   (Funct3_i),
    .Funct12_i                  (Funct12_i),
    .ResultSrc_d2_o             (ResultSrc_tc_o),
    .ALUOp_d2_o                 (ALUOp),
    .ALUSrc_d2_o                (ALUSrc_tc_o),
    .R_Type_d2_o                (R_Type_tc_o),
    .W_Type_d2_o                (W_Type_tc_o),
    .Mem_Read_d2_o              (Mem_Read_En_tc_o),
    .Mem_Write_d2_o             (Mem_Write_En_tc_o),
    .Immediate_Type_d2_o        (Immediate_Type_tc_o),
    .Regwrite_d2_o              (Regwrite_tc_o),
    .Jump_d2_o                  (Jump_tc_o),
    .Mret_d2_o                  (Mret_tc_o)
);

ALU_Decoder AD_tc (
    .OPB5_i                     (OPB5_i),
    .Funct3_i                   (Funct3_i),
    .Funct7_i                   (Funct7_i),
    .ALUOp_i                    (ALUOp),
    .ALUControl_ad_o            (ALUControl_tc_o)
);

Hazard_Unit HU_tc (
    .Rs1_dex_i                  (Rs1_i),
    .Rs2_dex_i                  (Rs2_i),
    .Rd_dex_i                   (Rd_i),
    .Rd_mwb_i                   (Rd_mwb_i),
    .DMem_Interface_Req_Ready_i (DMem_Interface_Req_Ready_i),
    .ResultSrc_mwb_i            (ResultSrc_mwb_i),
    .Regwrite_i                 (Regwrite_tc_o),
    .Regwrite_mwb_i             (Regwrite_mwb_i),
    .ResultSrc_dex_i            (ResultSrc_tc_o),
    .PCSrc_i                    (PCSrc_i),
    .Irq_Taken_i                (Irq_Taken_tc_o),
    .Mret_i                     (Mret_tc_o),
    .Mul_Stall_i                (Mul_Stall),
    .FlushF_hu_o                (FlushF_tc_o),
    .FlushDEX_hu_o              (FlushDEX_tc_o),
    .ForwardA_hu_o              (ForwardA_tc_o),
    .ForwardB_hu_o              (ForwardB_tc_o),
    .StallF_hu_o                (StallF_tc_o),
    .StallDEX_hu_o              (StallDEX_tc_o)
);

CSR_Controller CSR_tc (
    .clk                        (clk),
    .rst                        (rst),
    .FlushF_i                   (FlushF_tc_o),
    .FlushDEX_i                 (FlushDEX_tc_o),
    .Irq_Taken_Ccnt_o           (Irq_Taken_tc_o),
    .External_Activated_Ccnt_o  (External_Activated_tc_o),
    .Timer_Activated_Ccnt_o     (Timer_Activated_tc_o),
    .Software_Activated_Ccnt_o  (Software_Activated_tc_o),
    .CSR_En_Ccnt_o              (CSR_En_tc_o),
    .CSR_Imm_Ccnt_o             (CSR_Imm_tc_o),
    .Funct3_i                   (Funct3_mwb_i),
    .Funct7_i                   (Funct7_mwb_i),
    .OPCode_i                   (OPCode_mwb_i),
    .Mip_Meip_i                 (Mip_Meip_i),
    .Mip_Mtip_i                 (Mip_Mtip_i),
    .Mip_Msip_i                 (Mip_Msip_i),
    .Mie_Meie_i                 (Mie_Meie_i),
    .Mie_Mtie_i                 (Mie_Mtie_i),
    .Mie_Msie_i                 (Mie_Msie_i),
    .Mstatus_Mie_i              (Mstatus_Mie_i),
    .Current_Privilege_i        (Current_Privilege_i),
    .CSR_Opcode_Ccnt_o          (CSR_Opcode_tc_o)
);

Zmmul_Decoder ZMD_tc (
    .Flush_i                    (FlushF_tc_o),
    .Mul_Busy_i                 (Mul_Busy_i),
    .Mul_Done_i                 (Mul_Done_i),
    .Mul_Stall_zd_o             (Mul_Stall),
    .Mul_Sel_zd_o               (Mul_Sel_tc_o),
    .Mul_En_zd_o                (Mul_En_tc_o),
    .Mul_Start_zd_o             (Mul_Start_tc_o),
    .Mul_Hi_zd_o                (Mul_Hi_tc_o),
    .Mul_Signa_zd_o             (Mul_Signa_tc_o),
    .Mul_Signb_zd_o             (Mul_Signb_tc_o),

    .OPCode_i                   (OPCode_i),
    .Funct3_i                   (Funct3_i),
    .Funct7_i                   (Funct7_i)
    
);

endmodule
