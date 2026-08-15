# ALU_Decoder Module Documentation

## Overview
The `ALU_Decoder` module is responsible for generating the specific control signals required by the Arithmetic Logic Unit (ALU). By combining the broad operational category provided by the main decoder (`ALUOp_i`) with specific instruction fields (`Funct3_i`, `Funct7_i`, and `OPB5_i`), it outputs a precise 5-bit control signal (`ALUControl_ad_o`) that dictates the exact arithmetic or logical operation to be executed by the datapath.

## Ports

### Inputs
| Port Name | Width | Description |
| :--- | :--- | :--- |
| `OPB5_i` | 1 | Opcode bit 5 (used to distinguish between instruction variants, such as add/sub) |
| `Funct3_i` | 3 | Funct3 instruction field |
| `Funct7_i` | 7 | Funct7 instruction field |
| `ALUOp_i` | 2 | ALU operation category selector from the main decoder |
| `ALUControl_ad_o` | 5 | Precise ALU operation control signal |
