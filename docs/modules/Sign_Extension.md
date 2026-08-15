# Sign Extension Module

## Overview

The `Sign_Extension` module is responsible for extracting immediate values embedded within an instruction word and expanding them into a full 32-bit representation. Governed by format control signals and specific instruction fields (such as the opcode and `funct3`), it properly aligns, zero-pads, or sign-extends the extracted bits to provide accurate immediate operands for the processor's execution stage.

## Ports

| Port Name | Direction | Width | Description |
| :--- | :--- | :--- | :--- |
| `Immediate_Type_i` | Input | `[2:0]` | Signal indicating the structural format of the immediate value |
| `ImmEnable_i` | Input | 1 | Control signal enabling the immediate extraction process |
| `Instruction_i` | Input | `[31:7]` | Upper subset of the instruction word containing the immediate bits |
| `OPCode_i` | Input | `[6:0]` | The 7-bit opcode extracted from the instruction |
| `Funct3_i` | Input | `[2:0]` | The 3-bit functional code extracted from the instruction |
| `Sign_Extended_se_o` | Output | `[31:0]` | The final 32-bit sign-extended or zero-extended immediate value |
