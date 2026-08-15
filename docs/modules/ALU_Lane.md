# ALU Lane Module

## Overview

The `ALU_Lane` module serves as the execution data path wrapper for the ALU operations within the processor pipeline. It is primarily responsible for operand routing and data forwarding. By interpreting forwarding and source control signals, it selects the appropriate data inputs—such as register file outputs, the Program Counter (PC), sign-extended immediate values, or forwarded results from the writeback stage—to accurately supply the core Arithmetic Logic Unit (ALU) with the correct operands.

## Parameters

| Parameter | Default Value | Description |
| :--- | :--- | :--- |
| `size` | 32 | The bit width for the data paths, inputs, and outputs. |

## Ports

| Port Name | Direction | Width | Description |
| :--- | :--- | :--- | :--- |
| `clk` | Input | 1 | Clock signal |
| `rst` | Input | 1 | Reset signal |
| `ForwardA_i` | Input | `[1:0]` | Forwarding control signal for the first operand |
| `ForwardB_i` | Input | `[1:0]` | Forwarding control signal for the second operand |
| `ALUSrc_i` | Input | `[1:0]` | Control signal to select the data source for the ALU operands |
| `ALUControl_i` | Input | `[4:0]` | 5-bit control signal specifying the ALU operation to execute |
| `PC_Out_i` | Input | `[size-1:0]` | Program Counter input value |
| `Read_data1_i` | Input | `[size-1:0]` | First data operand read from the register file |
| `Read_data2_i` | Input | `[size-1:0]` | Second data operand read from the register file |
| `Writeback_Result_i` | Input | `[size-1:0]` | Forwarded data from the writeback stage |
| `Sign_Extended_i` | Input | `[size-1:0]` | Sign-extended immediate value |
| `Alu_Result_al_o` | Output | `[size-1:0]` | Final computed result from the core ALU |
| `SrcA_dex_al_o` | Output | `[size-1:0]` | Forwarded/selected data for Source A |
| `SrcB_dex_al_o` | Output | `[size-1:0]` | Forwarded/selected data for Source B |
| `operand1_o` | Output | `[size-1:0]` | The actual first operand fed into the core ALU |
| `operand2_o` | Output | `[size-1:0]` | The actual second operand fed into the core ALU |
