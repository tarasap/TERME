# Decode/Execute Unit (DEX Stage)

## Overview

The `Decode_Execute` module implements the Decode/Execute stage of the
TERME processor pipeline.

TERME uses a three-stage in-order pipeline:
    Fetch              Decode/Execute          Memory/Write-Back

      F  ---------------- DEX ---------------- MWB

The Decode/Execute stage receives the fetched instruction from the Fetch
stage and generates the execution results required by later pipeline
stages.

The module is responsible for integrating:

- Instruction field extraction
- Register file access
- Immediate generation
- Operand selection
- ALU execution
- Branch decision generation
- Multiplication unit interface
- Forwarding support

---

# Module Interface

## Clock and Reset

| Port | Direction | Width | Description |
|---|---|---:|---|
| `clk` | Input | 1 | System clock |
| `rst` | Input | 1 | Processor reset signal |

---

# Control Inputs

| Port | Direction | Width | Description |
|---|---|---:|---|
| `Immediate_Type_i` | Input | 3 | Selects the immediate generation type |
| `Regread_i` | Input | 1 | Enables register-file reading |
| `ImmEnable_i` | Input | 1 | Enables immediate operand usage |
| `ResultSrc_i` | Input | 2 | Result source selection control |
| `ALUSrc_i` | Input | 2 | ALU operand source selection control |
| `ALUControl_i` | Input | 5 | ALU operation control signal |
| `ForwardA_i` | Input | 2 | Forwarding control for first ALU operand |
| `ForwardB_i` | Input | 2 | Forwarding control for second ALU operand |
| `Jump_i` | Input | 1 | Indicates jump instruction execution |
| `Regwrite_mwb_i` | Input | 1 | Enables register write-back from MWB stage |
| `BrchEnable_i` | Input | 1 | Enables branch evaluation |
| `Mul_Start_i` | Input | 1 | Starts multiplication operation |
| `Mul_Hi_i` | Input | 1 | Selects multiplication result mode |
| `Mul_Signa_i` | Input | 1 | Signedness control for operand A |
| `Mul_Signb_i` | Input | 1 | Signedness control for operand B |

---

# Memory/Write-Back Interface Inputs

| Port | Direction | Width | Description |
|---|---|---:|---|
| `Rd_mwb_i` | Input | 5 | Destination register index from MWB stage |
| `Writeback_Result_i` | Input | 32 | Data written back to the register file |

These signals provide the write-back information required for register
updates and forwarding.

---

# Instruction Inputs

| Port | Direction | Width | Description |
|---|---|---:|---|
| `PC_Out_i` | Input | 32 | Current instruction address |
| `PC_Plus_i` | Input | 32 | Sequential PC value |
| `Instruction_i` | Input | 32 | Instruction received from Fetch stage |

---

# Outputs

## Instruction Fields

| Port | Direction | Width | Description |
|---|---|---:|---|
| `Rs1_dex_o` | Output | 5 | Source register 1 index |
| `Rs2_dex_o` | Output | 5 | Source register 2 index |
| `Rd_dex_o` | Output | 5 | Destination register index |
| `OPCode_dex_o` | Output | 7 | RISC-V opcode field |
| `Funct3_dex_o` | Output | 3 | RISC-V funct3 field |
| `Funct7_dex_o` | Output | 7 | RISC-V funct7 field |
| `Funct12_dex_o` | Output | 12 | RISC-V funct12 field |
| `OPB5_dex_o` | Output | 1 | Instruction bit 5 |

---

## Execution Outputs

| Port | Direction | Width | Description |
|---|---|---:|---|
| `Sign_Extended_dex_o` | Output | 32 | Generated immediate value |
| `SrcA_dex_o` | Output | 32 | First execution operand |
| `SrcB_dex_o` | Output | 32 | Second execution operand |
| `Alu_Result_dex_o` | Output | 32 | ALU result |
| `Mul_Result_dex_o` | Output | 32 | Multiplication result |

---

## Control Outputs

| Port | Direction | Width | Description |
|---|---|---:|---|
| `PCSrc_dex_o` | Output | 1 | Indicates PC redirection request |
| `Mul_Busy_dex_o` | Output | 1 | Indicates multiplication unit busy state |
| `Mul_Done_dex_o` | Output | 1 | Indicates multiplication completion |

---

# Internal Structure

The Decode_Execute module connects several execution-related blocks:

| Instance | Module | Purpose |
|---|---|---|
| `RF_dex` | `Regfile` | Register-file interface |
| `SE_dex` | `Sign_Extension` | Immediate generation |
| `BJU_dex` | `Branch_Unit` | Branch decision generation |
| `AL_dex` | `ALU_Lane` | Operand processing and ALU execution |
| `MUL_dex` | `Mul_Unit` | Multiplication operations |

The detailed behavior of each submodule is documented separately.

---

# Instruction Field Extraction

The module extracts standard RISC-V instruction fields:
