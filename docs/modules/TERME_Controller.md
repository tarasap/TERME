# TERME Controller Module Documentation

## Overview
The `TERME_Controller` is the primary control unit for the TERME processor core. It acts as the brain behind the datapath, responsible for decoding instructions and orchestrating the operation of the entire pipeline. The module integrates multiple specialized decoders—including the primary instruction decoders (`Decoder1`, `Decoder2`), the `ALU_Decoder`, and the `Zmmul_Decoder` for multiplication extensions. It also encompasses a `Hazard_Unit` to manage data and control hazards (stalls and flushes) and a `CSR_Controller` to oversee Control and Status Register operations, interrupt handling, and privilege modes.

## Parameters
| Parameter | Default Value | Description |
| :--- | :--- | :--- |
| `size` | `32` | The standard bit width for the processor datapath operations. |

## Ports

### Inputs
| Port Name | Width | Description |
| :--- | :--- | :--- |
| `clk` | 1 | System clock signal |
| `rst` | 1 | Active-high system reset signal |
| `DMem_Interface_Req_Ready_i` | 1 | Data memory interface ready signal |
| `Mul_Busy_i` | 1 | Multiplier busy status flag |
| `Mul_Done_i` | 1 | Multiplier operation done flag |
| `ResultSrc_mwb_i` | 2 | Result source selector from Memory/Writeback stage |
| `PCSrc_i` | 1 | Program Counter source selector signal |
| `Regwrite_mwb_i` | 1 | Register file write enable from Memory/Writeback stage |
| `OPCode_mwb_i` | 7 | Instruction opcode from Memory/Writeback stage |
| `OPCode_fe_i` | 7 | Instruction opcode from Fetch stage |
| `OPCode_i` | 7 | Instruction opcode from Decode/Execute stage |
| `Funct7_mwb_i` | 7 | Funct7 field from Memory/Writeback stage |
| `Funct3_mwb_i` | 3 | Funct3 field from Memory/Writeback stage |
| `Funct3_i` | 3 | Funct3 field from Decode/Execute stage |
| `Funct7_i` | 7 | Funct7 field from Decode/Execute stage |
| `Funct12_i` | 12 | Funct12 field from Decode/Execute stage |
| `OPB5_i` | 1 | Opcode bit 5 (instruction decoding aid) |
| `Rs1_i` | 5 | Source register 1 address |
| `Rs2_i` | 5 | Source register 2 address |
| `Rd_i` | 5 | Destination register address (Decode/Execute) |
| `Rd_mwb_i` | 5 | Destination register address (Memory/Writeback) |
| `Mip_Meip_i` | 1 | Machine External Interrupt Pending |
| `Mip_Mtip_i` | 1 | Machine Timer Interrupt Pending |
| `Mip_Msip_i` | 1 | Machine Software Interrupt Pending |
| `Mie_Meie_i` | 1 | Machine External Interrupt Enable |
| `Mie_Mtie_i` | 1 | Machine Timer Interrupt Enable |
| `Mie_Msie_i` | 1 | Machine Software Interrupt Enable |
| `Mstatus_Mie_i` | 1 | Machine Interrupt Enable global flag |
| `Current_Privilege_i`| 2 | Current processor privilege level |
| `ImmEnable_tc_o` | 1 | Immediate enable flag |
| `Regread_tc_o` | 1 | Register file read enable |
| `BrchEnable_tc_o` | 1 | Branch enable flag |
| `Immediate_Type_tc_o`| 3 | Immediate value decoding type |
| `ResultSrc_tc_o` | 2 | Result source multiplexer selector |
| `ALUSrc_tc_o` | 2 | ALU source multiplexer selector |
| `Regwrite_tc_o` | 1 | Register file write enable |
| `R_Type_tc_o` | 3 | Memory read type |
| `W_Type_tc_o` | 2 | Memory write type |
| `Mem_Read_En_tc_o` | 1 | Memory read enable |
| `Mem_Write_En_tc_o` | 1 | Memory write enable |
| `Jump_tc_o` | 1 | Jump instruction active |
| `ALUControl_tc_o` | 5 | ALU operation control signal |
| `ForwardA_tc_o` | 2 | Forwarding control for ALU operand A |
| `ForwardB_tc_o` | 2 | Forwarding control for ALU operand B |
| `FlushF_tc_o` | 1 | Flush signal for Fetch stage |
| `FlushDEX_tc_o` | 1 | Flush signal for Decode/Execute stage |
| `StallF_tc_o` | 1 | Stall signal for Fetch stage |
| `StallDEX_tc_o` | 1 | Stall signal for Decode/Execute stage |
| `Irq_Taken_tc_o` | 1 | Interrupt taken signal |
| `External_Activated_tc_o` | 1 | External interrupt activated flag |
| `Timer_Activated_tc_o` | 1 | Timer interrupt activated flag |
| `Software_Activated_tc_o` | 1 | Software interrupt activated flag |
| `Mret_tc_o` | 1 | Machine return instruction active |
| `CSR_Imm_tc_o` | 1 | CSR immediate operation flag |
| `CSR_En_tc_o` | 1 | CSR enable signal |
| `Mul_Start_tc_o` | 1 | Multiplier start signal |
| `Mul_En_tc_o` | 1 | Multiplier enable signal |
| `Mul_Sel_tc_o` | 1 | Multiplier select flag |
| `Mul_Hi_tc_o` | 1 | Multiplier high-word selector |
| `Mul_Signa_tc_o` | 1 | Multiplier operand A signed flag |
| `Mul_Signb_tc_o` | 1 | Multiplier operand B signed flag |
| `CSR_Opcode_tc_o` | 2 | CSR operation code |
