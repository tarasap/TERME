// =============================================================================
// Project Name:   TERME
// File Name:      TERME.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-9
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================

`timescale 1ns / 1ps

module TERME #(parameter size = 32)(
    input  clk,
    input  rst,

    input                   Irq_Timer_i,        // From Top
    input                   Irq_Ext_i,          // From Top
    input                   Irq_software_i,     // From Top
    input                   DMem_Interface_Req_Ready_i,
    input                   Imem_Interface_Valid_i,
    output                  Imem_Interface_Stall_o,
    output                  Imem_Interface_Req_o,
    output                  DMem_Interface_Req_Valid_o,
    output                  DMem_Interface_Read_En_o,
    output                  DMem_Interface_Write_En_o,
    output [3 : 0]          DMem_Interface_Wstrb_o,
    
    input  [size - 1 : 0]   Imem_Interface_Data_i,
    input  [size - 1 : 0]   DMem_Interface_Data_i,
    output [size - 1 : 0]   Imem_Interface_Addr_o,
    output [size - 1 : 0]   DMem_Interface_Data_o,
    output [size - 1 : 0]   DMem_Interface_Addr_o

);  
    
    wire [6 : 0]        OPCode_te;
    wire [6 : 0]        OPCode_fe_te;
    wire [6 : 0]        OPCode_mwb_te;
    wire [2 : 0]        Funct3_mwb_te;
    wire [6 : 0]        Funct7_mwb_te;
    wire [2 : 0]        Funct3_te;
    wire [6 : 0]        Funct7_te;
    wire [11 : 0]       Funct12_te;
    wire                OPB5_te;
    wire [4 : 0]        Rs1_dex_te;
    wire [4 : 0]        Rs2_dex_te;
    wire [4 : 0]        Rd_dex_te;
    wire [4 : 0]        Rd_mwb_te;
    wire [1 : 0]        Current_Privilege_te;
    wire [1 : 0]        ResultSrc_mwb_te;
    wire                Mul_Busy_te;
    wire                Mul_Done_te;
  
    wire [2 : 0]        Immediate_Type_tc;
    wire [4 : 0]        ALUControl_tc;
    wire [1 : 0]        ALUSrc_tc;
    wire [1 : 0]        ResultSrc_tc;
    wire                Regwrite_tc;
    wire                Regread_tc;
    wire                ImmEnable_tc;
    wire                BrchEnable_tc;
    wire                Mem_Write_tc;
    wire                Mem_Read_tc;
    wire                Jump_tc;
    wire                PCSrc_tc;
    wire [1 : 0]        ForwardA_tc;
    wire [1 : 0]        ForwardB_tc;
    wire                StallDEX_tc;
    wire                StallF_tc;
    wire                FlushF_tc;
    wire                FlushDEX_tc;
    wire [2 : 0]        R_Type_tc;                
    wire [1 : 0]        W_Type_tc;
    wire [1 : 0]        CSR_Opcode_tc;
    wire                Mret_tc;
    wire                CSR_Imm_tc;
    wire                Irq_Taken_tc;
    wire                External_Activated_tc;
    wire                Timer_Activated_tc;
    wire                Software_Activated_tc;
    wire                CSR_En_tc;
    wire                Mul_En_tc;    
    wire                Mul_Hi_tc;      
    wire                Mul_Signa_tc;  
    wire                Mul_Signb_tc; 
    wire                Mul_Sel_tc;
    wire                Mul_Start_tc;

    TERME_Controller #(.size(size)) TC (
        .clk                            (clk),
        .rst                            (rst),
        .DMem_Interface_Req_Ready_i     (DMem_Interface_Req_Ready_i),
        .Mul_Busy_i                     (Mul_Busy_te),
        .Mul_Done_i                     (Mul_Done_te),
        .ResultSrc_mwb_i                (ResultSrc_mwb_te),
        .PCSrc_i                        (PCSrc_te),
        .Regwrite_mwb_i                 (Regwrite_mwb_te),
        .ImmEnable_tc_o                 (ImmEnable_tc),
        .Regread_tc_o                   (Regread_tc),
        .BrchEnable_tc_o                (BrchEnable_tc),
        .Immediate_Type_tc_o            (Immediate_Type_tc),
        .ResultSrc_tc_o                 (ResultSrc_tc),
        .ALUSrc_tc_o                    (ALUSrc_tc),
        .Regwrite_tc_o                  (Regwrite_tc),
        .R_Type_tc_o                    (R_Type_tc),
        .W_Type_tc_o                    (W_Type_tc),
        .Mem_Read_En_tc_o               (Mem_Read_tc),
        .Mem_Write_En_tc_o              (Mem_Write_tc),
        .Jump_tc_o                      (Jump_tc),
        .ALUControl_tc_o                (ALUControl_tc),
        .ForwardA_tc_o                  (ForwardA_tc),
        .ForwardB_tc_o                  (ForwardB_tc),
        .FlushF_tc_o                    (FlushF_tc),
        .FlushDEX_tc_o                  (FlushDEX_tc),
        .StallF_tc_o                    (StallF_tc),
        .StallDEX_tc_o                  (StallDEX_tc),
        .Irq_Taken_tc_o                 (Irq_Taken_tc),
        .External_Activated_tc_o        (External_Activated_tc),
        .Timer_Activated_tc_o           (Timer_Activated_tc),
        .Software_Activated_tc_o        (Software_Activated_tc),
        .Mret_tc_o                      (Mret_tc),
        .CSR_Imm_tc_o                   (CSR_Imm_tc),
        .CSR_En_tc_o                    (CSR_En_tc),
        .Mul_Start_tc_o                 (Mul_Start_tc),
        .Mul_En_tc_o                    (Mul_En_tc),
        .Mul_Sel_tc_o                   (Mul_Sel_tc),
        .Mul_Hi_tc_o                    (Mul_Hi_tc),
        .Mul_Signa_tc_o                 (Mul_Signa_tc),
        .Mul_Signb_tc_o                 (Mul_Signb_tc),
        .OPCode_mwb_i                   (OPCode_mwb_te),
        .OPCode_fe_i                    (OPCode_fe_te),
        .OPCode_i                       (OPCode_te),
        .Funct7_mwb_i                   (Funct7_mwb_te),
        .Funct3_mwb_i                   (Funct3_mwb_te),
        .Funct3_i                       (Funct3_te),
        .Funct7_i                       (Funct7_te),
        .Funct12_i                      (Funct12_te),
        .OPB5_i                         (OPB5_te),
        .Rs1_i                          (Rs1_dex_te),
        .Rs2_i                          (Rs2_dex_te),
        .Rd_i                           (Rd_dex_te),
        .Rd_mwb_i                       (Rd_mwb_te),
        .Mip_Meip_i                     (Mip_Meip_te),
        .Mip_Mtip_i                     (Mip_Mtip_te),
        .Mip_Msip_i                     (Mip_Msip_te),
        .Mie_Meie_i                     (Mie_Meie_te),
        .Mie_Mtie_i                     (Mie_Mtie_te),
        .Mie_Msie_i                     (Mie_Msie_te),
        .Mstatus_Mie_i                  (Mstatus_Mie_te),
        .Current_Privilege_i            (Current_Privilege_te),
        .CSR_Opcode_tc_o                (CSR_Opcode_tc)
    );

    TERME_Engine #(.size(size)) TE (
        .clk                            (clk),
        .rst                            (rst),
        .Irq_Timer_i                    (Irq_Timer_i),
        .Irq_Ext_i                      (Irq_Ext_i),
        .Irq_software_i                 (Irq_software_i),
        .CSR_En_i                       (CSR_En_tc),
        .Mret_i                         (Mret_tc),
        .CSR_Imm_i                      (CSR_Imm_tc),
        .External_Activated_i           (External_Activated_tc),
        .Timer_Activated_i              (Timer_Activated_tc),
        .Software_Activated_i           (Software_Activated_tc),
        .Irq_Taken_i                    (Irq_Taken_tc),
        .Immediate_Type_i               (Immediate_Type_tc),
        .ResultSrc_i                    (ResultSrc_tc),
        .ALUControl_i                   (ALUControl_tc),
        .ALUSrc_i                       (ALUSrc_tc),
        .Regwrite_i                     (Regwrite_tc),
        .Regread_i                      (Regread_tc),
        .ImmEnable_i                    (ImmEnable_tc),
        .BrchEnable_i                   (BrchEnable_tc),
        .R_Type_i                       (R_Type_tc),
        .W_Type_i                       (W_Type_tc),
        .Mem_Read_en_i                  (Mem_Read_tc),
        .Mem_Write_en_i                 (Mem_Write_tc),
        .Jump_i                         (Jump_tc),
        .DMem_Interface_Req_Ready_i     (DMem_Interface_Req_Ready_i),
        .ForwardA_i                     (ForwardA_tc),
        .ForwardB_i                     (ForwardB_tc),
        .FlushF_i                       (FlushF_tc),
        .FlushDEX_i                     (FlushDEX_tc),
        .StallDEX_i                     (StallDEX_tc),
        .StallF_i                       (StallF_tc),
        .Mul_Start_i                    (Mul_Start_tc),
        .Mul_Hi_i                       (Mul_Hi_tc),
        .Mul_Signa_i                    (Mul_Signa_tc),
        .Mul_Signb_i                    (Mul_Signb_tc),
        .Mul_Sel_i                      (Mul_Sel_tc),
        .Imem_Interface_Valid_i         (Imem_Interface_Valid_i),
        .Imem_Interface_Req_te_o        (Imem_Interface_Req_o),
        .Imem_Interface_Stall_te_o      (Imem_Interface_Stall_o),
        .DMem_Interface_Read_En_te_o    (DMem_Interface_Read_En_o),
        .DMem_Interface_Write_En_te_o   (DMem_Interface_Write_En_o),
        .DMem_Interface_Wstrb_te_o      (DMem_Interface_Wstrb_o),
        .DMem_Interface_Req_Valid_te_o  (DMem_Interface_Req_Valid_o),
        .PCSrc_te_o                     (PCSrc_te),
        .Regwrite_te_o                  (Regwrite_mwb_te),
        .ResultSrc_mwb_te_o             (ResultSrc_mwb_te),
        .Mul_Busy_te_o                  (Mul_Busy_te),
        .Mul_Done_te_o                  (Mul_Done_te),
        .Imem_Interface_Data_i          (Imem_Interface_Data_i),
        .Load_Data_Interface_i          (DMem_Interface_Data_i),
        .CSR_Opcode_i                   (CSR_Opcode_tc),
        .Store_Data_Interface_te_o      (DMem_Interface_Data_o),
        .Mem_Addr_te_o                  (DMem_Interface_Addr_o),
        .Imem_Interface_Addr_te_o       (Imem_Interface_Addr_o),
        .Mip_Meip_te_o                  (Mip_Meip_te),
        .Mip_Mtip_te_o                  (Mip_Mtip_te),
        .Mip_Msip_te_o                  (Mip_Msip_te),
        .Mie_Meie_te_o                  (Mie_Meie_te),
        .Mie_Mtie_te_o                  (Mie_Mtie_te),
        .Mie_Msie_te_o                  (Mie_Msie_te),
        .Mstatus_Mie_te_o               (Mstatus_Mie_te),
        .Current_Privilege_te_o         (Current_Privilege_te),
        .OPCode_te_o                    (OPCode_te),
        .OPCode_fe_te_o                 (OPCode_fe_te),
        .OPCode_mwb_te_o                (OPCode_mwb_te),
        .Funct3_mwb_te_o                (Funct3_mwb_te),
        .Funct7_mwb_te_o                (Funct7_mwb_te),
        .Funct3_te_o                    (Funct3_te),
        .Funct7_te_o                    (Funct7_te),
        .Funct12_te_o                   (Funct12_te),
        .OPB5_te_o                      (OPB5_te),
        .Rs1_dex_te_o                   (Rs1_dex_te),
        .Rs2_dex_te_o                   (Rs2_dex_te),
        .Rd_dex_te_o                    (Rd_dex_te),
        .Rd_mwb_te_o                    (Rd_mwb_te)
    );

endmodule