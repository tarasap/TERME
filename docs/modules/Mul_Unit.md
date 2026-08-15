# Multiplier Unit Module

## Overview

The Mul_Unit module is a sequential add-and-shift multiplier that calculates the product of two 32-bit operands using a state-machine-driven architecture. It accommodates both signed and unsigned multiplication operations and can selectively output either the upper or lower 32 bits of the full 64-bit product based on control inputs. Additionally, it features status handshaking signals to indicate active computation (busy) and completion (done) states, ensuring proper synchronization within the processor's execution pipeline.
## Parameters

| Parameter | Default Value | Description |
| :--- | :--- | :--- |
| `size` | 32 | The bit width for the multiplier operands and the output result. |

## Ports

| Port Name | Direction | Width | Description |
| :--- | :--- | :--- | :--- |
| `clk` | Input | 1 | Clock signal |
| `rst` | Input | 1 | Reset signal |
| `Mul_Start_i` | Input | 1 | Control signal to initiate the multiplication process |
| `Mul_Hi_i` | Input | 1 | Control signal to output the upper 32 bits (1) or lower 32 bits (0) of the product |
| `Mul_Signa_i` | Input | 1 | Indicates if the first operand should be treated as a signed integer |
| `Mul_Signb_i` | Input | 1 | Indicates if the second operand should be treated as a signed integer |
| `Mul_Busy_mul_o` | Output | 1 | Status flag indicating that the multiplier is actively computing |
| `Mul_Done_mul_o` | Output | 1 | Status flag indicating that the multiplication operation has finished |
| `Operand_a_i` | Input | `[size-1:0]` | The first input operand (multiplicand) |
| `Operand_b_i` | Input | `[size-1:0]` | The second input operand (multiplier) |
| `Mul_Result_mul_o` | Output | `[size-1:0]` | The selected 32-bit segment of the final computed product |
