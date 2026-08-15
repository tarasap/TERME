# Decompressor Module

## Overview

The `Decompressor` module is responsible for taking a 16-bit compressed instruction as input and expanding it into its corresponding full 32-bit instruction equivalent. 
## Parameters

| Parameter | Default Value | Description |
| :--- | :--- | :--- |
| `size` | 32 | The bit width for the output decompressed instruction. |

## Ports

| Port Name | Direction | Width | Description |
| :--- | :--- | :--- | :--- |
| `instruction_i` | Input | `[15:0]` | The incoming 16-bit compressed instruction. |
| `instruction_dc_o` | Output | `[size-1:0]` | The resulting 32-bit decompressed instruction. |
