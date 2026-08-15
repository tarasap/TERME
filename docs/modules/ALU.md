# ALU Module

## Overview

The `ALU` (Arithmetic Logic Unit) module is a parameterized component responsible for performing various arithmetic and logical operations within the processor. Governed by a 5-bit control signal, it executes operations such as addition, subtraction, bitwise logic, shifts, and magnitude comparisons between two input operands, returning the computed result. 

## Parameters

| Parameter | Default Value | Description |
| :--- | :--- | :--- |
| `size` | 32 | The bit width for the input operands and the output result. |

## Ports

| Port Name | Direction | Width | Description |
| :--- | :--- | :--- | :--- |
| `clk` | Input | 1 | Clock signal |
| `rst` | Input | 1 | Reset signal |
| `ALUControl_i` | Input | `[4:0]` | 5-bit control signal determining the specific arithmetic or logical operation to execute |
| `Operand1_i` | Input | `[size-1:0]` | The first input operand |
| `Operand2_i` | Input | `[size-1:0]` | The second input operand |
| `Result_alu_o` | Output | `[size-1:0]` | The computed output result of the ALU operation |
