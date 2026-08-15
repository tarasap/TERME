# TERME Architecture

## 1. Overview

TERME is a 32-bit in-order RISC-V processor implementing a three-stage pipeline. It supports the base RV32IC instruction set, alongside the Zicsr (Control and Status Register) and Zmmul (Multiply-Only) extensions.

## 2. Core Modules
### TERME_Engine (Datapath)
The TERME_Engine is the structural backbone of the processor. It contains the logic for the physical execution of instructions across the pipeline stages and manages the pipeline registers that propagate state data. Its responsibilities include program counter generation, ALU computations, hardware multiplication execution, and memory address calculation.

### TERME_Controller (Control Unit)
The TERME_Controller acts as the processor's brain, interpreting fetched instructions to steer the datapath. Rather than relying on a single monolithic block, it evaluates opcodes and function fields to generate precise control signals for the ALU, memory interfaces, and multiplexers. It actively coordinates with the Hazard_Unit to resolve data dependencies via forwarding or to issue pipeline stalls and flushes. It also contains the CSR_Controller to manage hardware interrupts, software exceptions, and system privilege modes.

## 3. Pipeline Stages

### Fetch — F

The Fetch stage determines the next program counter (accounting for sequential execution, branches, or traps) and retrieves the instruction from instruction memory.

### Decode/Execute — DEX

The Decode/Execute stage decodes the instruction, reads required operands, and immediately performs the necessary arithmetic, logical, multiplication, or branch comparison operations. It also calculates effective addresses for upcoming memory accesses.

### Memory/Write-Back — MWB

The Memory/Write-Back stage interfaces with the data memory to perform load and store operations. It formats the retrieved data (e.g., sign-extending bytes) and writes the final results back into the architectural state

## 4. Memory Interfaces

TERME utilizes a Harvard memory architecture, providing separate and concurrent interfaces for instructions and data:

#### Instruction Interface: 
A read-only bus dedicated to instruction fetching.

#### Data Interface: 
A read/write bus featuring a 4-bit write strobe (Wstrb) to support precise sub-word memory operations (byte, half-word, and word). This interface is designed to connect to an external memory controller or an optional data cache.
