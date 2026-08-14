// =============================================================================
// Project Name:   TERME
// File Name:      CSRs.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-10
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================
`timescale 1ns/1ns

module CSRs #(parameter size = 32)(
    input                               clk,
    input                               rst,

    input                               Irq_Timer_i,
    input                               Irq_Ext_i,
    input                               Irq_software_i,
    input                               CSR_En_i,
    input                               Mret_i,
    input                               External_Activated_i,
    input                               Timer_Activated_i,
    input                               Software_Activated_i,
    input                               Irq_Taken_i,
    output reg [1        : 0]           Current_Privilege_csr_o,

    input      [1        : 0]           CSR_Opcode_i,  
    input      [11       : 0]           CSR_Addr_i,
    input      [size - 1 : 0]           CSR_Wdata_i,        
    input      [size - 1 : 0]           Trap_PC_i,      
    output     [size - 1 : 0]           CSR_Rdata_o,  
    output reg [size - 1 : 0]           Mcause_o,
    output     [size - 1 : 0]           Trap_Next_PC_o,
    output                              Mip_Meip_csr_o,
    output                              Mip_Mtip_csr_o,
    output                              Mip_Msip_csr_o,
    output reg                          Mie_Meie_csr_o,
    output reg                          Mie_Mtie_csr_o,
    output reg                          Mie_Msie_csr_o, 
    output reg                          Mstatus_Mie_csr_o
    
);

    reg                                 mstatus_mpie;
    reg        [1        : 0]           mstatus_mpp;
    reg        [size - 1 : 0]           Mtvec;
    reg        [size - 1 : 0]           Mepc;
    wire       [size - 1 : 0]           Mstatus;
    reg        [size - 1 : 0]           Mhartid;
    wire       [size - 1 : 0]           trap_vector;
    reg        [size - 1 : 0]           trap_cause;
    reg        [size - 1 : 0]           next_csr_val;
    reg        [size - 1 : 0]           csr_read;
    wire                                csr_sec_check;
    wire                                direct_vector;

    assign Mip_Meip_csr_o = Irq_Ext_i;
    assign Mip_Mtip_csr_o = Irq_Timer_i;
    assign Mip_Msip_csr_o = Irq_software_i;

    assign CSR_Rdata_o    = csr_read;
    assign Mstatus        = {19'b0, mstatus_mpp, 3'b0, mstatus_mpie, 3'b0, Mstatus_Mie_csr_o, 3'b0};

    assign csr_sec_check  = (Current_Privilege_csr_o >= CSR_Addr_i[9:8]);  
    assign direct_vector  = (Mtvec[1:0] == 2'b01) && trap_cause[31];
    assign Trap_Next_PC_o = Irq_Taken_i  ? trap_vector :
                            direct_vector  ? {Mtvec[31 : 2], 2'b00} + {trap_cause[29 : 0], 2'b00}    :
                            {Mtvec[31 : 2], 2'b00};

    always @(*) begin
        if (External_Activated_i)       trap_cause = 32'h8000000B;
        else if (Software_Activated_i)  trap_cause = 32'h80000003;
        else if (Timer_Activated_i)     trap_cause = 32'h80000007;
        else                            trap_cause = 32'h00000000;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Mhartid                 <= {(size){1'b0}};
            Mtvec                   <= {(size){1'b0}};  
            Mepc                    <= {(size){1'b0}};  
            Mcause_o                <= {(size){1'b0}}; 
            Current_Privilege_csr_o <= 2'b11;
            Mstatus_Mie_csr_o       <= 1'b0; 
            mstatus_mpie            <= 1'b0;
            mstatus_mpp             <= 2'b11;
            Mie_Meie_csr_o          <= 1'b0;
            Mie_Mtie_csr_o          <= 1'b0;
            Mie_Msie_csr_o          <= 1'b0;
        end else if(Irq_Taken_i) begin
            Mepc                    <= Trap_PC_i;
            mstatus_mpie            <= Mstatus_Mie_csr_o;
            Mstatus_Mie_csr_o       <= 1'b0;
            Mcause_o                <= trap_cause;
            mstatus_mpp             <= Current_Privilege_csr_o;
            Current_Privilege_csr_o <= 2'b11;
        end else if (Mret_i) begin
            Mstatus_Mie_csr_o       <= mstatus_mpie;
            mstatus_mpie            <= 1'b1;
            Current_Privilege_csr_o <= mstatus_mpp;
            mstatus_mpp             <= 2'b00;
        end else if (CSR_En_i && csr_sec_check) begin
            case (CSR_Addr_i)
                12'h300: begin
                    Mstatus_Mie_csr_o <= next_csr_val[3];
                    mstatus_mpie      <= next_csr_val[7];
                    mstatus_mpp       <= next_csr_val[12 : 11];
                end
                12'h304: begin
                    Mie_Msie_csr_o    <= next_csr_val[3];
                    Mie_Mtie_csr_o    <= next_csr_val[7];
                    Mie_Meie_csr_o    <= next_csr_val[11];
                end 
                12'h305: Mtvec        <= next_csr_val;  
                12'h341: Mepc         <= next_csr_val; 
                12'h342: Mcause_o     <= next_csr_val; 
                default: ; 
            endcase
        end
    end

    always @(*) begin
        if (CSR_En_i && csr_sec_check) begin
            case (CSR_Addr_i)
                12'h300: csr_read = Mstatus;
                12'h304: csr_read = {20'b0, Mie_Meie_csr_o, 3'b0, Mie_Mtie_csr_o, 3'b0, Mie_Msie_csr_o, 3'b0}; 
                12'h305: csr_read = Mtvec;
                12'h341: csr_read = Mepc;
                12'h342: csr_read = Mcause_o;
                12'h344: csr_read = {20'b0, Mip_Meip_csr_o, 3'b0, Mip_Mtip_csr_o, 3'b0, Mip_Msip_csr_o, 3'b0};
                12'hF14: csr_read = Mhartid;
                default: csr_read = 32'h0;
            endcase
        end else begin
            csr_read = 32'h0;
        end
    end

    always @(*) begin
        case (CSR_Opcode_i)
            2'b00:   next_csr_val = CSR_Wdata_i;
            2'b01:   next_csr_val = csr_read | CSR_Wdata_i;
            2'b10:   next_csr_val = csr_read & ~CSR_Wdata_i;
            default: next_csr_val = CSR_Wdata_i;
        endcase
    end

endmodule