// =============================================================================
// Project Name:   TERME
// File Name:      Instruction_Load_Unit.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-9
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================
`timescale 1ns/1ns

module Instruction_Load_Unit #(parameter size = 32) (
    input                   clk,
    input                   rst,

    input                   StallF_i,
    input                   Imem_Valid_i,
    output                  Imem_Req_ilu_o,
    output                  Imem_Stall_ilu_o,
    output                  PC_Enable_ilu_o,
    
    input  [size - 1:0]     PC_i,
    input  [size - 1:0]     Imem_Data_i,
    output [size - 1:0]     Imem_Addr_ilu_o,     
    output [size - 1:0]     Instruction_ilu_o
);

    reg    [size - 1:0]     inst_buffer;

    assign Imem_Req_ilu_o    = ~StallF_i;
    assign Imem_Addr_ilu_o   = PC_i;
    assign Imem_Stall_ilu_o  = ~Imem_Valid_i;
    assign PC_Enable_ilu_o   = ~StallF_i & Imem_Valid_i;
    assign Instruction_ilu_o = (Imem_Valid_i) ? Imem_Data_i : inst_buffer;
    
    always @(posedge clk) begin
        if (rst)
            inst_buffer <= 32'h00000000; 
        else if (Imem_Valid_i && ~StallF_i)
            inst_buffer <= Imem_Data_i;
    end

endmodule