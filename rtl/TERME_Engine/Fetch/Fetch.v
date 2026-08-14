// =============================================================================
// Project Name:   TERME
// File Name:      Fetch.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-10
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================
`timescale 1ns/1ns

module Fetch #(parameter size = 32) (
    input                   clk,
    input                   rst,
    
    input                   Irq_Taken_i,
    input                   PCSrc_dex_i,
    input                   StallF_i, 
    input                   Mret_i,
    input                   Imem_Valid_i,
    output                  Imem_Req_fe_o,
    output                  Imem_Stall_fe_o,
     
    input  [size - 1:0]     Trap_Next_PC_i,
    input  [size - 1:0]     Imem_Data_i,
    input  [size - 1:0]     PC_Target_i,     
    output [size - 1:0]     PC_Out_fe_o,        
    output [size - 1:0]     PC_Plus_fe_o,
    output [size - 1:0]     Instruction_fe_o,
    output [       6:0]     OPCode_fe_o
);

    wire   [size - 1:0]     instruction_ilu;
    wire   [size - 1:0]     instruction_dc;
    wire   [size - 1:0]     pc_next_branch;
    wire   [size - 1:0]     pc_next;
    wire   [size - 1:0]     pc_out;
    wire                    pc_enable;
    wire                    trap_or_mret;
    wire   [      15:0]     compressed_inst;
    wire                    is_compressed;

    assign OPCode_fe_o     = Instruction_fe_o[6:0];
    assign trap_or_mret    = Mret_i | Irq_Taken_i;


    assign pc_next         = trap_or_mret   ? Trap_Next_PC_i :
                             PCSrc_dex_i    ? PC_Target_i    :
                             PC_Plus_fe_o;

    Reg #(.size(size)) Reg_PC_fe (
        .clk               (clk),  
        .rst               (rst),
        .en                (pc_enable),
        .d_in              (pc_next),
        .q_out             (pc_out)
    );

    assign PC_Plus_fe_o    = pc_out + (is_compressed ? 32'd2 : 32'd4);

    Instruction_Load_Unit #(.size(size)) ILU_fe (
        .clk               (clk),
        .rst               (rst),
        .StallF_i          (StallF_i),
        .Imem_Valid_i      (Imem_Valid_i),
        .Imem_Req_ilu_o    (Imem_Req_fe_o), 
        .Imem_Stall_ilu_o  (Imem_Stall_fe_o), 
        .PC_Enable_ilu_o   (pc_enable),
        .PC_i              (pc_out),
        .Imem_Data_i       (Imem_Data_i),
        .Imem_Addr_ilu_o   (PC_Out_fe_o),   
        .Instruction_ilu_o (instruction_ilu)
    );

    assign compressed_inst = instruction_ilu[15:0];
    assign is_compressed   = (compressed_inst[1:0] != 2'b11);

    Decompressor #(.size(size)) DC_fe (
        .instruction_i     (compressed_inst),
        .instruction_dc_o  (instruction_dc)
    );

    Mux_2 #(.size(size)) M2_Inst_fe (
        .select            (is_compressed),
        .in_1              (instruction_ilu),
        .in_2              (instruction_dc),
        .mux_out           (Instruction_fe_o)
    );

endmodule