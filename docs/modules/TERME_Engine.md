# TERME Engine  

## Overview
The `TERME_Engine` is the central processing core of the TERME project, implementing a 3-stage pipelined 32-bit RISC-V architecture capable of supporting RV32I, Zicsr, Zmmul, and compressed instructions. This top-level module acts as the primary structural backbone of the processor. It integrates the core pipeline stages—Instruction Fetch, Decode/Execute, and Memory/Writeback—via dedicated pipeline registers. Additionally, it instantiates the Control and Status Registers (CSRs) to handle hardware interrupts, and privilege modes, while coordinating communications with the instruction and data memory interfaces.

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
| `CSR_En_i` | 1 | CSR enable signal |
| `Mret_i` | 1 | Machine return instruction active |
| `CSR_Imm_i` | 1 | CSR immediate operation flag |
| `External_Activated_i` | 1 | External interrupt activated flag |
| `Timer_Activated_i` | 1 | Timer interrupt activated flag |
| `Software_Activated_i` | 1 | Software interrupt activated flag |
| `Irq_Taken_i` | 1 | Interrupt taken signal |
| `Immediate_Type_i` | 3 | Immediate value decoding type |
| `ResultSrc_i` | 2 | Result source multiplexer selector |
| `ALUControl_i` | 5 | ALU operation control signal |
| `ALUSrc_i` | 2 | ALU source multiplexer selector |
| `Regwrite_i` | 1 | Register file write enable |
| `Regread_i` | 1 | Register file read enable |
| `ImmEnable_i` | 1 | Immediate enable flag |
| `BrchEnable_i` | 1 | Branch enable flag |
| `R_Type_i` | 3 | Memory read type (e.g., byte, halfword, word) |
| `W_Type_i` | 2 | Memory write type |
| `Mem_Read_en_i` | 1 | Memory read enable |
| `Mem_Write_en_i` | 1 | Memory write enable |
| `Jump_i` | 1 | Jump instruction active |
| `DMem_Interface_Req_Ready_i`| 1 | Data memory interface ready signal |
| `ForwardA_i` | 2 | Forwarding control for ALU operand A |
| `ForwardB_i` | 2 | Forwarding control for ALU operand B |
| `FlushF_i` | 1 | Flush signal for Fetch stage |
| `FlushDEX_i` | 1 | Flush signal for Decode/Execute stage |
| `StallDEX_i` | 1 | Stall signal for Decode/Execute stage |
| `StallF_i` | 1 | Stall signal for Fetch stage |
| `Mul_Start_i` | 1 | Multiplier start signal |
| `Mul_Hi_i` | 1 | Multiplier high-word selector |
| `Mul_Signa_i` | 1 | Multiplier operand A signed flag |
| `Mul_Signb_i` | 1 | Multiplier operand B signed flag |
| `Mul_Sel_i` | 1 | Multiplier select flag |
| `Imem_Interface_Valid_i` | 1 | Instruction memory valid data flag |
| `Imem_Interface_Data_i` | `size` | Data from instruction memory |
| `Load_Data_Interface_i` | `size` | Data loaded from data memory |
| `CSR_Opcode_i` | 2 | CSR operation code |
| `Imem_Interface_Req_te_o` | 1 | Instruction memory request |
| `Imem_Interface_Stall_te_o` | 1 | Instruction memory stall signal |
| `DMem_Interface_Read_En_te_o` | 1 | Data memory read enable |
| `DMem_Interface_Write_En_te_o`| 1 | Data memory write enable |
| `DMem_Interface_Wstrb_te_o` | 4 | Data memory write strobe |
| `DMem_Interface_Req_Valid_te_o`| 1 | Data memory request valid |
| `PCSrc_te_o` | 1 | Program Counter source selector |
| `Regwrite_te_o` | 1 | Writeback stage register write enable |
| `ResultSrc_mwb_te_o` | 2 | Writeback stage result source |
| `Mul_Busy_te_o` | 1 | Multiplier busy flag |
| `Mul_Done_te_o` | 1 | Multiplier operation done flag |
| `Store_Data_Interface_te_o` | `size` | Data to be stored to data memory |
| `Mem_Addr_te_o` | `size` | Target memory address |
| `Imem_Interface_Addr_te_o` | `size` | Instruction fetch address |
| `Mip_Meip_te_o` | 1 | Machine External Interrupt Pending |
| `Mip_Mtip_te_o` | 1 | Machine Timer Interrupt Pending |
| `Mip_Msip_te_o` | 1 | Machine Software Interrupt Pending |
| `Mie_Meie_te_o` | 1 | Machine External Interrupt Enable |
| `Mie_Mtie_te_o` | 1 | Machine Timer Interrupt Enable |
| `Mie_Msie_te_o` | 1 | Machine Software Interrupt Enable |
| `Mstatus_Mie_te_o` | 1 | Machine Interrupt Enable global flag |
| `Current_Privilege_te_o` | 2 | Current processor privilege level |
| `OPCode_te_o` | 7 | Execute stage instruction opcode |
| `OPCode_fe_te_o` | 7 | Fetch stage instruction opcode |
| `OPCode_mwb_te_o` | 7 | Memory/Writeback stage instruction opcode |
| `Funct3_mwb_te_o` | 3 | Memory/Writeback stage Funct3 |
| `Funct7_mwb_te_o` | 7 | Memory/Writeback stage Funct7 |
| `Funct3_te_o` | 3 | Execute stage Funct3 |
| `Funct7_te_o` | 7 | Execute stage Funct7 |
| `Funct12_te_o` | 12 | Execute stage Funct12 |
| `OPB5_te_o` | 1 | Opcode bit 5 (instruction decoding aid) |
| `Rs1_dex_te_o` | 5 | Source register 1 (Decode/Execute) |
| `Rs2_dex_te_o` | 5 | Source register 2 (Decode/Execute) |
| `Rd_dex_te_o` | 5 | Destination register (Decode/Execute) |
| `Rd_mwb_te_o` | 5 | Destination register (Memory/Writeback) |
