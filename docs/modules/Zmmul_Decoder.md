# Zmmul_Decoder

## Overview
The `Zmmul_Decoder` module is dedicated to supporting the RISC-V `Zmmul` (multiply-only) instruction extension within the TERME processor. It decodes the instruction's `OPCode`, `Funct3`, and `Funct7` fields to identify multiplication operations and generates the precise control signals required by the hardware multiplier. This includes managing multiplier stalling, activation, operand signedness, and selecting between high or low word results.

## Ports
| Port Name | Width | Description |
| :--- | :--- | :--- |
| `Flush_i` | 1 | Pipeline flush signal |
| `Mul_Busy_i` | 1 | Multiplier busy status flag |
| `Mul_Done_i` | 1 | Multiplier operation complete flag |
| `OPCode_i` | 7 | Instruction opcode |
| `Funct3_i` | 3 | Funct3 instruction field |
| `Funct7_i` | 7 | Funct7 instruction field |
| `Mul_Stall_zd_o` | 1 | Stall signal to pause the pipeline during multiplication |
| `Mul_Sel_zd_o` | 1 | Multiplier result selection flag |
| `Mul_En_zd_o` | 1 | Multiplier enable signal |
| `Mul_Start_zd_o` | 1 | Multiplier start signal |
| `Mul_Hi_zd_o` | 1 | Selector for the high-word of the multiplication result |
| `Mul_Signa_zd_o` | 1 | Signedness flag for operand A |
| `Mul_Signb_zd_o` | 1 | Signedness flag for operand B |
