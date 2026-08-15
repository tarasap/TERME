# Hazard_Unit

## Overview
The `Hazard_Unit` module is a critical control component responsible for maintaining the correct execution of instructions within the TERME processor's pipeline. It continuously monitors the active registers across different pipeline stages to detect and resolve data hazards via operand forwarding. Additionally, it handles control hazards and structural delays by generating appropriate flush and stall signals in response to taken branches, interrupts, machine returns, multiplier operations, and data memory interface delays.

## Ports
| Port Name | Width | Description |
| :--- | :--- | :--- |
| `Rs1_dex_i` | 5 | Source register 1 address from Decode/Execute stage |
| `Rs2_dex_i` | 5 | Source register 2 address from Decode/Execute stage |
| `Rd_dex_i` | 5 | Destination register address from Decode/Execute stage |
| `Rd_mwb_i` | 5 | Destination register address from Memory/Writeback stage |
| `DMem_Interface_Req_Ready_i` | 1 | Data memory interface ready signal |
| `Regwrite_i` | 1 | Register file write enable signal |
| `Regwrite_mwb_i` | 1 | Register file write enable signal from Memory/Writeback stage |
| `PCSrc_i` | 1 | Program Counter source selector (indicates branch/jump taken) |
| `ResultSrc_dex_i` | 2 | Result source multiplexer selector from Decode/Execute stage |
| `ResultSrc_mwb_i` | 2 | Result source multiplexer selector from Memory/Writeback stage |
| `Irq_Taken_i` | 1 | Interrupt taken signal |
| `Mret_i` | 1 | Machine return (mret) instruction active flag |
| `Mul_Stall_i` | 1 | Stall request signal from the multiplier |
| `ForwardA_hu_o` | 2 | Forwarding multiplexer control for ALU operand A |
| `ForwardB_hu_o` | 2 | Forwarding multiplexer control for ALU operand B |
| `FlushF_hu_o` | 1 | Flush signal for the Fetch pipeline stage |
| `FlushDEX_hu_o` | 1 | Flush signal for the Decode/Execute pipeline stage |
| `StallF_hu_o` | 1 | Stall signal for the Fetch pipeline stage |
| `StallDEX_hu_o` | 1 | Stall signal for the Decode/Execute pipeline stage |
