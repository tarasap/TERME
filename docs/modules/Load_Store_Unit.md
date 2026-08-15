# Load/Store Unit Module

## Overview

The `Load_Store_Unit` module bridges the processor core and the data memory. It is responsible for formatting data being written to (stores) or read from (loads) memory. For load operations, it extracts the correct byte, half-word, or word based on the address offset and performs zero or sign extension as requested. For store operations, it aligns the data properly and generates a 4-bit write strobe (`LSU_Wstrb_o`) to selectively update specific bytes in memory. The module also implements a basic finite state machine to manage request/ready handshaking with the memory subsystem.

## Parameters

| Parameter | Default Value | Description |
| :--- | :--- | :--- |
| `size` | 32 | The bit width for memory addresses and data buses. |

## Ports

| Port Name | Direction | Width | Description |
| :--- | :--- | :--- | :--- |
| `clk` | Input | 1 | Clock signal |
| `rst` | Input | 1 | Reset signal |
| `LSU_Read_En_i` | Input | 1 | Read enable signal from the core |
| `LSU_Write_En_i` | Input | 1 | Write enable signal from the core |
| `LSU_RData_Type_i` | Input | `[2:0]` | Specifies the size and extension type (signed/unsigned) for loads |
| `LSU_WData_Type_i` | Input | `[1:0]` | Specifies the size for stores (byte, half-word, word) |
| `LSU_Req_Ready_i` | Input | 1 | Handshake signal indicating memory is ready to accept a request |
| `LSU_Req_Valid_o` | Output | 1 | Handshake signal indicating a valid memory request is pending |
| `LSU_Read_En_o` | Output | 1 | Read enable signal forwarded to memory |
| `LSU_Write_En_o` | Output | 1 | Write enable signal forwarded to memory |
| `LSU_Wstrb_o` | Output | `[3:0]` | 4-bit write strobe to mask active bytes during memory writes |
| `LSU_Address_i` | Input | `[size-1:0]` | Target memory address from the core |
| `LSU_Store_Data_i` | Input | `[size-1:0]` | Raw data to be stored into memory |
| `LSU_Load_Data_i` | Input | `[size-1:0]` | Raw data loaded from memory |
| `LSU_Mem_Store_o` | Output | `[size-1:0]` | Byte-aligned formatted data to write to memory |
| `LSU_Load_Data_o` | Output | `[size-1:0]` | Formatted and zero/sign-extended data sent to the core |
| `LSU_Mem_Addr_o` | Output | `[size-1:0]` | Word-aligned memory address |
