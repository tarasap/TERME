# TERME Architecture

## 1. Overview

TERME is a 32-bit in-order RISC-V processor using a three-stage
pipeline:

**Fetch → Decode/Execute → Memory/Write-Back**

The architecture is optimized for a relatively small hardware
implementation while maintaining support for the most important
embedded RISC-V functionality.

## 2. Pipeline

### Fetch — F

The Fetch stage is responsible for selecting the current program
counter and obtaining the instruction from instruction memory.

### Decode/Execute — DEX

The Decode/Execute stage performs:

- instruction decoding
- register-file reads
- immediate generation
- ALU operations
- multiplication
- branch comparison
- jump-target calculation
- load/store address generation
- CSR operation decoding

### Memory/Write-Back — MWB

The Memory/Write-Back stage performs:

- data-memory accesses
- load result processing
- register-file write-back
- completion of applicable CSR operations

## 3. Pipeline Control

Pipeline-control logic handles:

- stalls
- hazards
- branch redirection
- pipeline flushes
- memory stalls
- interrupt entry
- MRET execution

## 4. Memory Interfaces

TERME provides separate instruction-memory and data-memory interfaces.

The data-memory interface may optionally be connected through the TERME
data cache before reaching external memory.

## 5. Register File

TERME contains 32 architectural integer registers, each 32 bits wide.

Register x0 is permanently hardwired to zero.