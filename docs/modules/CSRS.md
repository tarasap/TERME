# Control and Status Registers (CSRs) Module

## Overview

The `CSRs` module implements the Control and Status Registers for the processor, primarily handling machine-level privileges, interrupts, and traps. It maintains core state registers including `mstatus` (machine status), `mtvec` (machine trap-handler base address), `mepc` (machine exception program counter), `mcause` (machine trap cause), `mie` (machine interrupt enable), and `mip` (machine interrupt pending). The module processes hardware and software interrupts, handles trap vector generation (`Trap_Next_PC_o`), and supports CSR read/write, read/set, and read/clear operations based on the incoming opcode.

## Parameters

| Parameter | Default Value | Description |
| :--- | :--- | :--- |
| `size` | 32 | The bit width for the registers and data buses. |

## Ports

| Port Name | Direction | Width | Description |
| :--- | :--- | :--- | :--- |
| `clk` | Input | 1 | Clock signal |
| `rst` | Input | 1 | Reset signal |
| `Irq_Timer_i` | Input | 1 | Timer interrupt request |
| `Irq_Ext_i` | Input | 1 | External interrupt request |
| `Irq_software_i` | Input | 1 | Software interrupt request |
| `CSR_En_i` | Input | 1 | Enable signal for CSR access |
| `Mret_i` | Input | 1 | Machine-mode return signal |
| `External_Activated_i` | Input | 1 | Flag indicating an external interrupt is active |
| `Timer_Activated_i` | Input | 1 | Flag indicating a timer interrupt is active |
| `Software_Activated_i` | Input | 1 | Flag indicating a software interrupt is active |
| `Irq_Taken_i` | Input | 1 | Flag indicating the processor is taking an interrupt/trap |
| `Current_Privilege_csr_o` | Output | `[1:0]` | Current privilege level of the processor |
| `CSR_Opcode_i` | Input | `[1:0]` | Operation type (Write, Set, Clear) |
| `CSR_Addr_i` | Input | `[11:0]` | 12-bit CSR address |
| `CSR_Wdata_i` | Input | `[size-1:0]` | Data to be written to the selected CSR |
| `Trap_PC_i` | Input | `[size-1:0]` | Program counter value at the time of the trap |
| `CSR_Rdata_o` | Output | `[size-1:0]` | Data read from the selected CSR |
| `Mcause_o` | Output | `[size-1:0]` | Machine trap cause register output |
| `Trap_Next_PC_o` | Output | `[size-1:0]` | Target program counter for trap handling |
| `Mip_Meip_csr_o` | Output | 1 | Machine external interrupt pending flag |
| `Mip_Mtip_csr_o` | Output | 1 | Machine timer interrupt pending flag |
| `Mip_Msip_csr_o` | Output | 1 | Machine software interrupt pending flag |
| `Mie_Meie_csr_o` | Output | 1 | Machine external interrupt enable flag |
| `Mie_Mtie_csr_o` | Output | 1 | Machine timer interrupt enable flag |
| `Mie_Msie_csr_o` | Output | 1 | Machine software interrupt enable flag |
| `Mstatus_Mie_csr_o` | Output | 1 | Global machine interrupt enable flag |
