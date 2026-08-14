// =============================================================================
// Project Name:   TERME
// File Name:      Memory_WriteBack.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-9
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================
`timescale 1ns/1ns

module Memory_WriteBack #(parameter size = 32) (
    input                     clk,
    input                     rst,

    input                     CSR_Imm_i,
    input                     Read_En_i,
    input                     Write_En_i,
    input        [     2:0]   RData_Type_i,
    input        [     1:0]   WData_Type_i,
    input        [     1:0]   ResultSrc_i,
    input                     Mul_Sel_i,
    input                     Req_Ready_i,
    output                    Req_Valid_mwb_o,
    output                    Read_En_mwb_o,
    output                    Write_En_mwb_o,
    output       [     3:0]   Wstrb_mwb_o,

    input        [     4:0]   Rs1_i,
    input        [size - 1:0] SrcA_i,
    input        [size - 1:0] Alu_Result_i,
    input        [size - 1:0] Mul_Result_i,
    input        [size - 1:0] Store_Data_i,
    input        [size - 1:0] Load_Data_i,
    input        [size - 1:0] PC_Plus_i,
    input        [size - 1:0] CSR_Rdata_i,
    output       [size - 1:0] Mem_Store_mwb_o,
    output       [size - 1:0] Load_Data_mwb_o,
    output       [size - 1:0] Mem_Addr_mwb_o,
    output       [size - 1:0] Writeback_Result_mwb_o,
    output       [size - 1:0] CSR_Wdata_mwb_o
);

    wire         [size - 1:0] Address;
    wire         [size - 1:0] Exec_Result;
    wire         [size - 1:0] Load_Data_mwb;
    
    assign Address        = Alu_Result_i;
    assign Exec_Result      = Mul_Sel_i ? Mul_Result_i : Alu_Result_i;
    assign Load_Data_mwb_o  = Load_Data_mwb;

    Load_Store_Unit #(.size(size)) LSU_mwb (
        .clk                (clk),
        .rst                (rst),
        .LSU_Read_En_i      (Read_En_i),
        .LSU_Write_En_i     (Write_En_i),
        .LSU_RData_Type_i   (RData_Type_i),
        .LSU_WData_Type_i   (WData_Type_i),    
        .LSU_Req_Ready_i    (Req_Ready_i),
        .LSU_Req_Valid_o    (Req_Valid_mwb_o),
        .LSU_Read_En_o      (Read_En_mwb_o),
        .LSU_Write_En_o     (Write_En_mwb_o),
        .LSU_Wstrb_o        (Wstrb_mwb_o), 
        .LSU_Address_i      (Address),
        .LSU_Store_Data_i   (Store_Data_i),
        .LSU_Load_Data_i    (Load_Data_i),
        .LSU_Mem_Store_o    (Mem_Store_mwb_o),
        .LSU_Load_Data_o    (Load_Data_mwb),
        .LSU_Mem_Addr_o     (Mem_Addr_mwb_o) 
    );  

    Mux_4 #(.size(size)) M4_mwb (
        .select             (ResultSrc_i),
        .in_1               (Exec_Result),
        .in_2               (Load_Data_mwb),
        .in_3               (PC_Plus_i),
        .in_4               (CSR_Rdata_i),
        .mux_out            (Writeback_Result_mwb_o)
    );

    Mux_2 #(.size(size)) M2_CSR_WData_mwb (
        .select             (CSR_Imm_i),
        .in_1               (SrcA_i),
        .in_2               ({27'd0, Rs1_i}),
        .mux_out            (CSR_Wdata_mwb_o)
    );

endmodule