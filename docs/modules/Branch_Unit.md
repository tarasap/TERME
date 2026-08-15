# Branch Unit Module

## Overview

The `Branch_Unit` module is responsible for evaluating branch conditions within the processor. It compares two input operands based on the instruction's functional field to determine if a branch should be taken, outputting a corresponding decision signal when branch operations are enabled.

## Parameters

| Parameter | Default Value | Description |
| :--- | :--- | :--- |
| `size` | 32 | The bit width for the input operands. |

## Ports

| Port Name | Direction | Width | Description |
| :--- | :--- | :--- | :--- |
| `BrchEnable_i` | Input | 1 | Control signal to enable branch condition evaluation |
| `Funct3_i` | Input | `[2:0]` | 3-bit functional code specifying the type of branch condition to evaluate |
| `Operand1_i` | Input | `[size-1:0]` | The first input operand for comparison |
| `Operand2_i` | Input | `[size-1:0]` | The second input operand for comparison |
| `BrchTaken_bd_o` | Output | 1 | Branch decision signal indicating whether the branch condition is met |
