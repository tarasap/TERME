# Decoder2 Module Documentation

## Overview
The `Decoder2` module serves as the primary instruction decoding unit within the TERME processor's control architecture. By evaluating the instruction's 7-bit `OPCode`, along with the `Funct3` and `Funct12` fields, it generates the core control signals necessary to steer the datapath. This includes determining ALU operations, resolving operand sources, managing memory read/write permissions and data types, identifying immediate formats, and controlling jump or machine return behaviors.

## Ports

### Inputs
| Port Name | Width | Description |
| :--- | :--- | :--- |
| `OPCode_i` | 7 | Instruction opcode |
| `Funct3_i` | 3 | Funct3 instruction field |
| `Funct12_i` | 12 | Funct12 instruction field |
| `ResultSrc_d2_o` | 2 | Result source multiplexer selector |
| `ALUOp_d2_o` | 2 | ALU operation category selector |
| `ALUSrc_d2_o` | 2 | ALU operand source selector |
| `R_Type_d2_o` | 3 | Memory read data type (e.g., byte, halfword, word) |
| `W_Type_d2_o` | 2 | Memory write data type |
| `Mem_Write_d2_o` | 1 | Memory write enable signal |
| `Mem_Read_d2_o` | 1 | Memory read enable signal |
| `Immediate_Type_d2_o`| 3 | Immediate value decoding type |
| `Regwrite_d2_o` | 1 | Register file write enable signal |
| `Jump_d2_o` | 1 | Jump instruction active flag |
| `Mret_d2_o` | 1 | Machine return (mret) instruction active flag |
