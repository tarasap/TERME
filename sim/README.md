# TERME Bare-Metal Testing Environment

This directory contains the bare-metal simulation and linking environment for the TERME RISC-V processor. It is specifically designed to provide a deterministic, lightweight environment for executing standard benchmarking suites like CoreMark.

## Supported Architecture
The boot code and linker are configured for the **`rv32ic_zicsr_zmmul`** instruction set. The environment fully supports:
* Base 32-bit Integer Instruction Set (RV32I)
* Compressed Instructions (C) for improved code density
* Control and Status Registers (Zicsr)
* Multiplication Extension (Zmmul)

## File Overview

* **`link.ld` (Linker Script)**
  Defines a contiguous 256KB memory space divided equally between instruction and data memory. It carefully aligns the `.text`, `.data`, and `.bss` sections, ensuring that the bootloader and main execution flow remain deterministic.
* **`ctr0.s` (Boot Assembly)**
  The entry point (`_start`) for the processor. It initializes the stack pointer at the very top of the data memory (`0x40000`), clears the `.bss` section to zero (critical for accurate CoreMark scoring), and jumps to the `main()` function. Upon return, it safely halts the simulation.
* **`tb_coremark.v` (RTL Testbench)**
  A robust simulation wrapper that instantiates the TERME core and memory system. It includes memory-mapped I/O and several hardware-level safeguards to catch execution anomalies.

## Memory Map

| Region | Start Address | End Address | Size | Access | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **IMEM** | `0x0000_0000` | `0x0001_FFFF` | 128 KB | RX | Boot code, read-only data, and instructions |
| **DMEM** | `0x0002_0000` | `0x0003_FFFF` | 128 KB | RWX | Initialized data, BSS, and Stack (grows down from top) |
| **CLINT** | `0x0200_0000` | `0x0200_FFFF` | 64 KB | RW | Core Local Interruptor (Timer/Software Interrupts) |
| **UART TX**| `0x1000_0000` | `0x1000_0000` | 1 Byte | W | Memory-mapped UART transmission for console output |
| **SIMEND** | `0x2000_0000` | `0x2000_0000` | 1 Byte | W | Magic address to terminate RTL simulation |

## Testbench Features

To accelerate debugging during RTL simulation, `tb_coremark.v` implements several hardware monitors:
1. **Simulation Exit Hook:** Writing to `0x20000000` immediately halts `$finish` the simulation, printing the cycle count and exit code.
2. **Infinite Loop Watchdog:** Monitors the Program Counter (PC). If the processor hangs on the exact same instruction for more than 1,000 cycles, the testbench forcefully terminates the simulation to prevent runaway logs.
3. **Trap/Exception Catcher:** If the CPU attempts to fetch from address `0x00000000` after the first 100 cycles (indicative of a null-pointer jump or an unhandled trap), the testbench catches the fatal error and exits.