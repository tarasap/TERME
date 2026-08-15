<p align="center">
  <img src="assets/terme-logo.png" width="320">
</p>

<h1 align="center">TERME</h1>

<p align="center">
  <b>Three-stage Embedded RISC-V Microprocessor Engine</b>
</p>

---

## Overview

TERME is a custom 32-bit RISC-V processor designed around a highly efficient, in-order three-stage pipeline. 

The processor is primarily intended as a lightweight embedded core with an emphasis on low area, low power, synthesizability, and clean microarchitecture. It features:

- **RV32I** base integer ISA
- **C** (Compressed) extension for improved code density
- **Zicsr** extension for Control and Status Registers
- **Zmmul** extension for hardware multiplication
- Machine-mode CSR and interrupt handling (Timer, External, Software)
- Separate instruction and data memory interfaces

## Architecture

TERME utilizes a Fetch, Decode-Execute and Memory-Writeback three-stage pipeline. 

<p align="center">
  <img src="assets/TERME-arch.png" width="720">
</p>

## Performance & Physical Metrics

The core has been rigorously benchmarked in gate-level simulation and synthesized targeting the **Nangate 45nm Open Cell Library**.

### Synthesis & Power (Nangate 45nm)
| Metric | Value | Notes |
| :--- | :--- | :--- |
| **Max Frequency ($F_{max}$)** | ~410 MHz | Timing met with 2.45ns target clock |
| **Total Core Area** | ~22,846 µm² | Standalone core (excluding external memory macros) |


### CoreMark Benchmark
| Metric | Value |
| :--- | :--- |
| **CoreMark Score** | 659.87 |
| **CoreMark / MHz** | 1.51 |
| **Simulation Environment**| Gate-level, ideal memory (bare-metal environment) |
| **Compiler Flags** | `-march=rv32ic_zicond_zmmul_zicsr_zca -mabi=ilp32 -Ofast` |

## Repository Structure

The repository is organized to separate physical design, software, and simulation environments:

* `rtl/` - Core standard Verilog source files.
* `sim/` - Bare-metal simulation environment (`tb_coremark.v`, memory models), Boot code (`ctr0.s`), linker scripts (`link.ld`)
* `synthesis/` - Yosys scripts, OpenSTA configurations, and timing constraints (`.sdc`).
* `docs/` - Deep-dive architectural documentation and module-by-module explanations.

*(Navigate to the individual directories above for specific instructions on how to run simulations, compile software, or reproduce synthesis metrics).*
