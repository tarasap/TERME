// =============================================================================
// Project Name:   TERME
// File Name:      Sign_Extension.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-9
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================
`timescale 1ns/1ns

module Sign_Extension (
    input      [ 2:0] Immediate_Type_i,
    input             ImmEnable_i,
    
    input      [31:7] Instruction_i,
    input      [ 6:0] OPCode_i,       
    input      [ 2:0] Funct3_i,
    output reg [31:0] Sign_Extended_se_o
);

    always @(Instruction_i, OPCode_i, Funct3_i, Immediate_Type_i, ImmEnable_i) begin
        Sign_Extended_se_o = 32'b0;
        if (ImmEnable_i) begin
            case (Immediate_Type_i)
                3'b000: begin
                    if (OPCode_i == 7'b0010011 && Funct3_i == 3'b001)
                        Sign_Extended_se_o = {27'b0, Instruction_i[24:20]};
                    else if (OPCode_i == 7'b0010011 && Funct3_i == 3'b101)
                        Sign_Extended_se_o = {27'b0, Instruction_i[24:20]};
                    else
                        Sign_Extended_se_o = {{20{Instruction_i[31]}}, Instruction_i[31:20]};
                end
                3'b001: Sign_Extended_se_o = {{20{Instruction_i[31]}}, Instruction_i[31:25], Instruction_i[11:7]};
                3'b010: Sign_Extended_se_o = {{19{Instruction_i[31]}}, 
                                              Instruction_i[31], 
                                              Instruction_i[7], 
                                              Instruction_i[30:25], 
                                              Instruction_i[11:8], 
                                              1'b0};
                3'b011: Sign_Extended_se_o = {{12{Instruction_i[31]}}, 
                                              Instruction_i[19:12], 
                                              Instruction_i[20], 
                                              Instruction_i[30:21], 
                                              1'b0};
                3'b100: Sign_Extended_se_o = {Instruction_i[31:12], 12'b0};                        
            endcase
        end   
    end

endmodule