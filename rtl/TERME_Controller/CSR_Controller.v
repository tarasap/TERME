// =============================================================================
// Project Name:   TERME
// File Name:      CSR_Controller.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-9
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================

`timescale 1ns / 1ps

module CSR_Controller #(parameter size = 32)(
    input                           clk,
    input                           rst,

    input                           FlushF_i, 
    input                           FlushDEX_i,
    output                          Irq_Taken_Ccnt_o,
    output                          External_Activated_Ccnt_o,
    output                          Timer_Activated_Ccnt_o,
    output                          Software_Activated_Ccnt_o,
    output reg                      CSR_En_Ccnt_o,
    output reg                      CSR_Imm_Ccnt_o,
    
    input      [2 : 0]              Funct3_i,
    input      [6 : 0]              Funct7_i,
    input      [6 : 0]              OPCode_i,
    input                           Mip_Meip_i,
    input                           Mip_Mtip_i,
    input                           Mip_Msip_i,
    input                           Mie_Meie_i,
    input                           Mie_Mtie_i,
    input                           Mie_Msie_i,
    input                           Mstatus_Mie_i,
    input      [1 : 0]              Current_Privilege_i,
    output reg [1 : 0]              CSR_Opcode_Ccnt_o
);

    wire                            global_en;
    wire                            irq_pending;
    reg                             bubble;
    wire                            irq_raw;

    assign External_Activated_Ccnt_o = Mip_Meip_i & Mie_Meie_i;
    assign Timer_Activated_Ccnt_o    = Mip_Mtip_i & Mie_Mtie_i;
    assign Software_Activated_Ccnt_o = Mip_Msip_i & Mie_Msie_i;

    assign global_en                 = (Current_Privilege_i == 2'b00) ? 1'b1 : Mstatus_Mie_i;
    assign irq_pending               = External_Activated_Ccnt_o | Timer_Activated_Ccnt_o | Software_Activated_Ccnt_o;

    assign irq_raw                   = global_en & irq_pending;
    assign Irq_Taken_Ccnt_o          = irq_raw   & ~bubble;

    always @(posedge clk) begin
        if (rst) bubble <= 0;
        else     bubble <= FlushF_i | FlushDEX_i;
    end

    always @(*) begin
        CSR_En_Ccnt_o     = 1'b0;
        CSR_Imm_Ccnt_o    = 1'b0;
        CSR_Opcode_Ccnt_o = 2'b00;

        case (Funct3_i)
            3'b000: begin
                CSR_En_Ccnt_o     = 1'b0;
                CSR_Imm_Ccnt_o    = 1'b0;
                CSR_Opcode_Ccnt_o = 2'b00;
            end 
            3'b001: begin 
                CSR_Opcode_Ccnt_o = 2'b00;
                CSR_En_Ccnt_o     = 1'b1; 
                CSR_Imm_Ccnt_o    = 1'b0; 
            end
            3'b010: begin
                CSR_Opcode_Ccnt_o = 2'b01;
                CSR_En_Ccnt_o     = 1'b1;  
                CSR_Imm_Ccnt_o    = 1'b0;
            end
            3'b011: begin 
                CSR_Opcode_Ccnt_o = 2'b10; 
                CSR_En_Ccnt_o     = 1'b1;
                CSR_Imm_Ccnt_o    = 1'b0;  
            end
            3'b101: begin 
                CSR_Opcode_Ccnt_o = 2'b00;
                CSR_En_Ccnt_o     = 1'b1; 
                CSR_Imm_Ccnt_o    = 1'b1;
            end
            3'b110: begin 
                CSR_Opcode_Ccnt_o = 2'b01;
                CSR_En_Ccnt_o     = 1'b1;  
                CSR_Imm_Ccnt_o    = 1'b1;
            end
            3'b111: begin 
                CSR_Opcode_Ccnt_o = 2'b10;
                CSR_En_Ccnt_o     = 1'b1; 
                CSR_Imm_Ccnt_o    = 1'b1; 
            end
            default: begin
                CSR_Opcode_Ccnt_o = 2'b00;
                CSR_En_Ccnt_o     = 1'b0; 
                CSR_Imm_Ccnt_o    = 1'b0;
            end
        endcase
    end

endmodule