# Decoder1 Module Documentation

## Overview
The `Decoder1` module is a preliminary instruction decoding unit within the TERME processor's control structure. It evaluates the 7-bit instruction opcode to generate foundational control signals required for the early stages of the pipeline. Specifically, it asserts whether an instruction requires immediate value extraction, register file reading, or branch evaluation, providing essential structural cues to the downstream datapath.

## Ports
| Port Name | Width | Description |
| :--- | :--- | :--- |
| `OPCode_i` | 7 | Instruction opcode |
| `ImmEnable_d1_o` | 1 | Immediate enable flag |
| `Regread_d1_o` | 1 | Register file read enable |
| `BrchEnable_d1_o` | 1 | Branch enable flag |
