# Regfile Module

## Overview

The `Regfile` module acts as the general-purpose register file for the processor. It maintains an array of 32-bit registers, allowing simultaneous read operations from two specified source registers and a synchronized write operation to a destination register.

## Ports

| Port Name | Direction | Width | Description |
| :--- | :--- | :--- | :--- |
| `clk` | Input | 1 | Clock signal |
| `rst` | Input | 1 | Reset signal |
| `Regwrite_i` | Input | 1 | Control signal to enable writing to a register |
| `Regread_i` | Input | 1 | Control signal to enable reading from registers |
| `Read_Reg1_i` | Input | `[4:0]` | 5-bit address for the first read source register |
| `Read_Reg2_i` | Input | `[4:0]` | 5-bit address for the second read source register |
| `Read_Reg3_i` | Input | `[4:0]` | 5-bit address for the destination write register |
| `Write_Data_i` | Input | `[31:0]` | 32-bit data to be written to the destination register |
| `Read_Data1_rf_o` | Output | `[31:0]` | 32-bit data read from the first source register |
| `Read_Data2_rf_o` | Output | `[31:0]` | 32-bit data read from the second source register |
