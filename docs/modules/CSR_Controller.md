# CSR_Controller Module Documentation

## Overview
The `CSR_Controller` module manages the control logic for the processor's Control and Status Registers (CSRs) alongside its interrupt handling mechanism. It evaluates pending interrupt requests (external, timer, and software) against their respective enable bits and the processor's global privilege state to determine if an interrupt should be taken. Additionally, it decodes the `Funct3` field of incoming CSR instructions to dictate the specific CSR operation (such as read/write, set, or clear) and identifies whether the operation utilizes an immediate value.

## Parameters
| Parameter | Default Value | Description |
| :--- | :--- | :--- |
| `size` | `32` | The standard bit width for the processor datapath parameters. |

## Ports

| Port Name | Width | Description |
| :--- | :--- | :--- |
| `clk` | 1 | System clock signal |
| `rst` | 1 | Active-high system reset signal |
| `FlushF_i` | 1 | Flush signal for the Fetch pipeline stage |
| `FlushDEX_i` | 1 | Flush signal for the Decode/Execute pipeline stage |
| `Funct3_i` | 3 | Funct3 instruction field |
| `Funct7_i` | 7 | Funct7 instruction field |
| `OPCode_i` | 7 | Instruction opcode |
| `Mip_Meip_i` | 1 | Machine External Interrupt Pending flag |
| `Mip_Mtip_i` | 1 | Machine Timer Interrupt Pending flag |
| `Mip_Msip_i` | 1 | Machine Software Interrupt Pending flag |
| `Mie_Meie_i` | 1 | Machine External Interrupt Enable flag |
| `Mie_Mtie_i` | 1 | Machine Timer Interrupt Enable flag |
| `Mie_Msie_i` | 1 | Machine Software Interrupt Enable flag |
| `Mstatus_Mie_i` | 1 | Machine Interrupt Enable global flag |
| `Current_Privilege_i`| 2 | Current processor privilege level |
| `Irq_Taken_Ccnt_o` | 1 | Interrupt taken signal |
| `External_Activated_Ccnt_o`| 1 | External interrupt activated flag |
| `Timer_Activated_Ccnt_o` | 1 | Timer interrupt activated flag |
| `Software_Activated_Ccnt_o`| 1 | Software interrupt activated flag |
| `CSR_En_Ccnt_o` | 1 | CSR instruction enable signal |
| `CSR_Imm_Ccnt_o` | 1 | CSR immediate operation flag |
| `CSR_Opcode_Ccnt_o` | 2 | CSR operation code |
