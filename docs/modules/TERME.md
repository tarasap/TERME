# TERME

## Overview
The `TERME` module serves as the top-level wrapper for the TERME processor core. It instantiates and interconnects the two primary functional blocks of the processor: the `TERME_Engine` (which contains the datapath and pipeline stages) and the `TERME_Controller` (which houses the instruction decoding and control logic). This module acts as the unified boundary for the processor, providing the external interfaces for instruction memory, data memory, and system interrupts.

## Parameters
| Parameter | Default Value | Description |
| :--- | :--- | :--- |
| `size` | `32` | The standard bit width for the processor datapath and memory interfaces. |

## Ports
| Port Name | Width | Description |
| :--- | :--- | :--- |
| `clk` | 1 | System clock signal |
| `rst` | 1 | Active-high system reset signal |
| `Irq_Timer_i` | 1 | Timer interrupt request |
| `Irq_Ext_i` | 1 | External interrupt request |
| `Irq_software_i` | 1 | Software interrupt request |
| `DMem_Interface_Req_Ready_i` | 1 | Data memory interface ready signal |
| `Imem_Interface_Valid_i` | 1 | Instruction memory valid data flag |
| `Imem_Interface_Stall_o` | 1 | Instruction memory stall signal |
| `Imem_Interface_Req_o` | 1 | Instruction memory request signal |
| `DMem_Interface_Req_Valid_o`| 1 | Data memory request valid signal |
| `DMem_Interface_Read_En_o` | 1 | Data memory read enable |
| `DMem_Interface_Write_En_o` | 1 | Data memory write enable |
| `DMem_Interface_Wstrb_o` | 4 | Data memory write strobe (byte enables) |
| `Imem_Interface_Data_i` | `size` | Data received from instruction memory |
| `DMem_Interface_Data_i` | `size` | Data received from data memory |
| `Imem_Interface_Addr_o` | `size` | Instruction fetch memory address |
| `DMem_Interface_Data_o` | `size` | Data to be written to data memory |
| `DMem_Interface_Addr_o` | `size` | Target address for data memory operations |
