// =============================================================================
// Project Name:   TERME
// File Name:      TERME_Engine.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-9
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================

`timescale 1ns / 1ps

module TERME_Engine #(parameter size = 32) (
    input                     clk,
    input                     rst,

    input                     Irq_Timer_i,
    input                     Irq_Ext_i,
    input                     Irq_software_i,
    input                     CSR_En_i,
    input                     Mret_i,
    input                     CSR_Imm_i,
    input                     External_Activated_i,
    input                     Timer_Activated_i,
    input                     Software_Activated_i,
    input                     Irq_Taken_i,
    input        [     2:0]   Immediate_Type_i,
    input        [     1:0]   ResultSrc_i,
    input        [     4:0]   ALUControl_i,
    input        [     1:0]   ALUSrc_i,
    input                     Regwrite_i,
    input                     Regread_i,
    input                     ImmEnable_i,
    input                     BrchEnable_i,
    input        [     2:0]   R_Type_i,
    input        [     1:0]   W_Type_i,
    input                     Mem_Read_en_i,
    input                     Mem_Write_en_i,
    input                     Jump_i,
    input                     DMem_Interface_Req_Ready_i,
    input        [     1:0]   ForwardA_i,
    input        [     1:0]   ForwardB_i,
    input                     FlushF_i,
    input                     FlushDEX_i,
    input                     StallDEX_i,
    input                     StallF_i,
    input                     Mul_Start_i,
    input                     Mul_Hi_i,
    input                     Mul_Signa_i,
    input                     Mul_Signb_i,
    input                     Mul_Sel_i,
    input                     Imem_Interface_Valid_i,
    output                    Imem_Interface_Req_te_o,
    output                    Imem_Interface_Stall_te_o,
    output                    DMem_Interface_Read_En_te_o,
    output                    DMem_Interface_Write_En_te_o,
    output       [     3:0]   DMem_Interface_Wstrb_te_o,
    output                    DMem_Interface_Req_Valid_te_o,
    output                    PCSrc_te_o,
    output                    Regwrite_te_o,
    output       [     1:0]   ResultSrc_mwb_te_o,
    output                    Mul_Busy_te_o,
    output                    Mul_Done_te_o,
    
    input        [size - 1:0] Imem_Interface_Data_i,
    input        [size - 1:0] Load_Data_Interface_i,
    input        [     1:0]   CSR_Opcode_i,
    output       [size - 1:0] Store_Data_Interface_te_o,
    output       [size - 1:0] Mem_Addr_te_o,
    output       [size - 1:0] Imem_Interface_Addr_te_o,
    output                    Mip_Meip_te_o,
    output                    Mip_Mtip_te_o,
    output                    Mip_Msip_te_o,
    output                    Mie_Meie_te_o,
    output                    Mie_Mtie_te_o,
    output                    Mie_Msie_te_o,
    output                    Mstatus_Mie_te_o,
    output       [     1:0]   Current_Privilege_te_o,
    output       [     6:0]   OPCode_te_o,
    output       [     6:0]   OPCode_fe_te_o,
    output       [     6:0]   OPCode_mwb_te_o,
    output       [     2:0]   Funct3_mwb_te_o,
    output       [     6:0]   Funct7_mwb_te_o,
    output       [     2:0]   Funct3_te_o,
    output       [     6:0]   Funct7_te_o,
    output       [    11:0]   Funct12_te_o,
    output                    OPB5_te_o,
    output       [     4:0]   Rs1_dex_te_o,
    output       [     4:0]   Rs2_dex_te_o,
    output       [     4:0]   Rd_dex_te_o,
    output       [     4:0]   Rd_mwb_te_o
);

    wire         [     4:0]   Rs1_dex;
    wire         [     4:0]   Rs2_dex;
    wire         [     4:0]   Rd_dex;
    wire         [     4:0]   Rs1_mwb;
    wire         [     4:0]   Rd_mwb;
    wire         [size - 1:0] PC_Plus_fe;
    wire         [size - 1:0] PC_Plus_dex;
    wire         [size - 1:0] PC_Out_fe;
    wire         [size - 1:0] PC_Out_dex;
    wire         [size - 1:0] pc_plus_mwb;
    wire         [size - 1:0] SrcA_dex;
    wire         [size - 1:0] SrcA_mwb;
    wire         [size - 1:0] SrcB_dex;
    wire         [size - 1:0] SrcB_mwb;
    wire         [     2:0]   Funct3_dex;
    wire         [     6:0]   Funct7_dex;
    wire         [    11:0]   Funct12_dex;
    wire         [     6:0]   OPCode_dex;
    wire         [size - 1:0] Instruction_fe;
    wire         [size - 1:0] Instruction_dex;
    wire         [size - 1:0] Instruction_mwb;
    wire         [size - 1:0] Sign_Extended_dex;
    wire         [size - 1:0] Alu_Result_dex;
    wire         [size - 1:0] Alu_Result_mwb;
    wire         [size - 1:0] Mul_Result_dex;
    wire         [size - 1:0] Mul_Result_mwb;
    wire         [size - 1:0] Writeback_Result_mwb;
    wire         [size - 1:0] Load_Data_mwb;
    wire                      Mem_Read_en_mwb;
    wire                      Mem_Write_en_mwb;
    wire                      Regwrite_mwb;
    wire         [     2:0]   R_Type_mwb;
    wire         [     1:0]   W_Type_mwb;
    wire         [     1:0]   ResultSrc_mwb;
    wire                      ImmEnable_dex;
    wire                      BrchEnable_dex;
    wire                      Regread_dex;
    wire                      PCSrc_dex;
    wire         [    11:0]   CSR_Addr_mwb;
    wire         [size - 1:0] CSR_Wdata_mwb;
    wire         [size - 1:0] PC_Out_mwb;
    wire         [size - 1:0] trap_next_pc;
    wire         [size - 1:0] CSR_Rdata;
    wire                      mem_write_internal;
    wire                      Mul_Sel_mwb;

    Fetch #(.size(size)) FE_te (
        .clk                 (clk),  
        .rst                 (rst),
        .Irq_Taken_i         (Irq_Taken_i),
        .PCSrc_dex_i         (PCSrc_dex),
        .StallF_i            (StallF_i),
        .Mret_i              (Mret_i),
        .Imem_Valid_i        (Imem_Interface_Valid_i),
        .Imem_Req_fe_o       (Imem_Interface_Req_te_o),
        .Imem_Stall_fe_o     (Imem_Interface_Stall_te_o),
        .Trap_Next_PC_i      (trap_next_pc),
        .Imem_Data_i         (Imem_Interface_Data_i),
        .PC_Target_i         (Alu_Result_dex),
        .PC_Out_fe_o         (PC_Out_fe), 
        .PC_Plus_fe_o        (PC_Plus_fe), 
        .Instruction_fe_o    (Instruction_fe),
        .OPCode_fe_o         (OPCode_fe_te_o)
    );

    Pipe_Register #(3) PR_IF_IDEX_Control_te (
        .clk                 (clk),  
        .rst                 (rst),
        .en                  (~StallF_i), 
        .clr                 (FlushF_i),
        .in                  ({ImmEnable_i, BrchEnable_i, Regread_i}),
        .out                 ({ImmEnable_dex, BrchEnable_dex, Regread_dex})
    );

    Pipe_Register #(32*3) PR_IF_IDEX_Data_te (
        .clk                 (clk),  
        .rst                 (rst),
        .en                  (~StallF_i), 
        .clr                 (FlushF_i),
        .in                  ({Instruction_fe, PC_Out_fe, PC_Plus_fe}),
        .out                 ({Instruction_dex, PC_Out_dex, PC_Plus_dex})
    );

    Decode_Execute #(.size(size)) DEX_te (
        .clk                 (clk),  
        .rst                 (rst),
        .Immediate_Type_i    (Immediate_Type_i),
        .Regread_i           (Regread_dex),
        .ImmEnable_i         (ImmEnable_dex),
        .ResultSrc_i         (ResultSrc_i),
        .ALUSrc_i            (ALUSrc_i),
        .ALUControl_i        (ALUControl_i),
        .ForwardA_i          (ForwardA_i),
        .ForwardB_i          (ForwardB_i),  
        .Jump_i              (Jump_i),
        .Regwrite_mwb_i      (Regwrite_mwb),
        .BrchEnable_i        (BrchEnable_dex),
        .Mul_Start_i         (Mul_Start_i),     
        .Mul_Hi_i            (Mul_Hi_i),        
        .Mul_Signa_i         (Mul_Signa_i),    
        .Mul_Signb_i         (Mul_Signb_i), 
        .PCSrc_dex_o         (PCSrc_dex),
        .Mul_Busy_dex_o      (Mul_Busy_te_o),   
        .Mul_Done_dex_o      (Mul_Done_te_o),      
        .PC_Out_i            (PC_Out_dex),
        .PC_Plus_i           (PC_Plus_dex),
        .Instruction_i       (Instruction_dex),
        .Rd_mwb_i            (Rd_mwb),
        .Writeback_Result_i  (Writeback_Result_mwb),
        .Rs1_dex_o           (Rs1_dex),
        .Rs2_dex_o           (Rs2_dex),             
        .Rd_dex_o            (Rd_dex),
        .OPCode_dex_o        (OPCode_dex),
        .Funct3_dex_o        (Funct3_dex),
        .Funct7_dex_o        (Funct7_dex),
        .Funct12_dex_o       (Funct12_dex),
        .OPB5_dex_o          (OPB5_dex),
        .Sign_Extended_dex_o (Sign_Extended_dex),
        .Alu_Result_dex_o    (Alu_Result_dex),
        .SrcB_dex_o          (SrcB_dex),
        .SrcA_dex_o          (SrcA_dex),
        .Mul_Result_dex_o    (Mul_Result_dex)
    );

    Pipe_Register #(32*5 + 5 + 32 + 5) PR_IDEX_MWB_Data_te (
        .clk                 (clk),  
        .rst                 (rst),
        .en                  (~StallDEX_i),
        .clr                 (FlushDEX_i), 
        .in                  ({Instruction_dex, Alu_Result_dex, Mul_Result_dex, PC_Plus_dex, Rd_dex, SrcB_dex, SrcA_dex, Rs1_dex}),
        .out                 ({Instruction_mwb, Alu_Result_mwb, Mul_Result_mwb, pc_plus_mwb, Rd_mwb, SrcB_mwb, SrcA_mwb, Rs1_mwb})
    );

    Pipe_Register #(3+2+5+1) PR_IDEX_MWB_Control_te (
        .clk                 (clk),  
        .rst                 (rst),
        .en                  (~StallDEX_i),
        .clr                 (FlushDEX_i), 
        .in                  ({Regwrite_i, ResultSrc_i, Mem_Read_en_i, Mem_Write_en_i, R_Type_i, W_Type_i, Mul_Sel_i}),
        .out                 ({Regwrite_mwb, ResultSrc_mwb, Mem_Read_en_mwb, Mem_Write_en_mwb, R_Type_mwb, W_Type_mwb, Mul_Sel_mwb})
    );

    Pipe_Register #(12 + 32 + 3 + 7 + 7) PR_IDEX_MWB_CSR_te (
        .clk                 (clk),  
        .rst                 (rst),
        .en                  (~StallDEX_i),
        .clr                 (FlushDEX_i), 
        .in                  ({Instruction_dex[31:20], PC_Out_dex, Funct3_dex, Funct7_dex, OPCode_dex}),
        .out                 ({CSR_Addr_mwb, PC_Out_mwb, Funct3_mwb_te_o, Funct7_mwb_te_o, OPCode_mwb_te_o})
    );

    Memory_WriteBack #(.size(size)) MWB_te (
        .clk                 (clk),
        .rst                 (rst),
        .CSR_Imm_i           (CSR_Imm_i),
        .Read_En_i           (Mem_Read_en_mwb),
        .Write_En_i          (Mem_Write_en_mwb),
        .RData_Type_i        (R_Type_mwb),
        .WData_Type_i        (W_Type_mwb),
        .Req_Ready_i         (DMem_Interface_Req_Ready_i),
        .ResultSrc_i         (ResultSrc_mwb),
        .Mul_Sel_i           (Mul_Sel_mwb),
        .Req_Valid_mwb_o     (DMem_Interface_Req_Valid_te_o),
        .Read_En_mwb_o       (DMem_Interface_Read_En_te_o),
        .Write_En_mwb_o      (mem_write_internal),
        .Wstrb_mwb_o         (DMem_Interface_Wstrb_te_o),
        .Rs1_i               (Rs1_mwb),
        .SrcA_i              (SrcA_mwb),
        .Alu_Result_i        (Alu_Result_mwb),
        .Mul_Result_i        (Mul_Result_mwb),
        .Store_Data_i        (SrcB_mwb),
        .Load_Data_i         (Load_Data_Interface_i),
        .PC_Plus_i           (pc_plus_mwb),
        .CSR_Rdata_i         (CSR_Rdata),
        .Mem_Store_mwb_o     (Store_Data_Interface_te_o),
        .Load_Data_mwb_o     (Load_Data_mwb),
        .Mem_Addr_mwb_o      (Mem_Addr_te_o),
        .Writeback_Result_mwb_o(Writeback_Result_mwb),
        .CSR_Wdata_mwb_o     (CSR_Wdata_mwb)
    );

    CSRs #(.size(size)) CSRs_te (
        .clk                 (clk),
        .rst                 (rst),
        .Irq_Timer_i         (Irq_Timer_i),
        .Irq_Ext_i           (Irq_Ext_i),
        .Irq_software_i      (Irq_software_i),
        .CSR_En_i            (CSR_En_i),
        .Mret_i              (Mret_i),
        .External_Activated_i(External_Activated_i),
        .Timer_Activated_i   (Timer_Activated_i),
        .Software_Activated_i(Software_Activated_i),
        .Irq_Taken_i         (Irq_Taken_i),
        .CSR_Opcode_i        (CSR_Opcode_i),  
        .CSR_Addr_i          (CSR_Addr_mwb),
        .CSR_Wdata_i         (CSR_Wdata_mwb),        
        .Trap_PC_i           (PC_Out_dex),
        .CSR_Rdata_o         (CSR_Rdata),  
        .Trap_Next_PC_o      (trap_next_pc),
        .Mip_Meip_csr_o      (Mip_Meip_te_o),
        .Mip_Mtip_csr_o      (Mip_Mtip_te_o),
        .Mip_Msip_csr_o      (Mip_Msip_te_o),
        .Mie_Meie_csr_o      (Mie_Meie_te_o),
        .Mie_Mtie_csr_o      (Mie_Mtie_te_o),
        .Mie_Msie_csr_o      (Mie_Msie_te_o), 
        .Mstatus_Mie_csr_o   (Mstatus_Mie_te_o), 
        .Current_Privilege_csr_o(Current_Privilege_te_o)
    );

    assign Imem_Interface_Addr_te_o     = PC_Out_fe;
    assign Funct3_te_o                  = Funct3_dex;
    assign Funct7_te_o                  = Funct7_dex;
    assign Funct12_te_o                 = Funct12_dex;
    assign OPCode_te_o                  = OPCode_dex;
    assign OPB5_te_o                    = OPB5_dex;
    assign Rs1_dex_te_o                 = Rs1_dex;
    assign Rs2_dex_te_o                 = Rs2_dex;
    assign Rd_dex_te_o                  = Rd_dex;
    assign Rd_mwb_te_o                  = Rd_mwb;
    assign PCSrc_te_o                   = PCSrc_dex;
    assign Regwrite_te_o                = Regwrite_mwb & ~Irq_Taken_i;
    assign ResultSrc_mwb_te_o           = ResultSrc_mwb;
    assign DMem_Interface_Write_En_te_o = mem_write_internal & ~Irq_Taken_i;

endmodule