# Memory/Write-Back Unit (MWB Stage)

## Overview

The `Memory_WriteBack` module implements the final stage of the TERME
three-stage pipeline.

TERME uses the following pipeline organization:

        Fetch              Decode/Execute          Memory/Write-Back

          F  ---------------- DEX ---------------- MWB

The Memory/Write-Back stage is responsible for handling:

- Data memory access requests
- Load and store operations
- Execution result selection
- Write-back data generation
- CSR write-data preparation

The module receives execution results from the Decode/Execute stage and
generates the final result written back to the register file or CSR
subsystem.

---

# Module Interface
## Clock and Reset

| Port | Direction | Width | Description |
|---|---|---:|---|
| `clk` | Input | 1 | System clock |
| `rst` | Input | 1 | Processor reset signal |

---

# Control Signals

| Port | Direction | Width | Description |
|---|---|---:|---|
| `CSR_Imm_i` | Input | 1 | Selects CSR immediate mode |
| `Read_En_i` | Input | 1 | Enables memory read operation |
| `Write_En_i` | Input | 1 | Enables memory write operation |
| `RData_Type_i` | Input | 3 | Load data type selection |
| `WData_Type_i` | Input | 2 | Store data type selection |
| `ResultSrc_i` | Input | 2 | Selects the source of the write-back result |
| `Mul_Sel_i` | Input | 1 | Selects multiplication result as execution result |
| `Req_Ready_i` | Input | 1 | Indicates memory request readiness |
| `Req_Valid_mwb_o` | Output | 1 | Indicates a valid memory request |
| `Read_En_mwb_o` | Output | 1 | Memory read enable output |
| `Write_En_mwb_o` | Output | 1 | Memory write enable output |
| `Wstrb_mwb_o` | Output | 4 | Memory byte write-enable signals |

---

# Data Signals

| Port | Direction | Width | Description |
|---|---|---:|---|
| `Rs1_i` | Input | 5 | Source register index used for CSR write-data generation |
| `SrcA_i` | Input | size | Source A value from execution stage |
| `Alu_Result_i` | Input | size | ALU execution result |
| `Mul_Result_i` | Input | size | Multiplication result |
| `Store_Data_i` | Input | size | Data to be written during store operations |
| `Load_Data_i` | Input | size | Data returned from memory |
| `PC_Plus_i` | Input | size | Incremented PC value |
| `CSR_Rdata_i` | Input | size | CSR read data |
| `Mem_Store_mwb_o` | Output | size | Store data sent to memory |
| `Load_Data_mwb_o` | Output | size | Loaded data from memory |
| `Mem_Addr_mwb_o` | Output | size | Memory access address |
| `Writeback_Result_mwb_o` | Output | size | Final data selected for register write-back |
| `CSR_Wdata_mwb_o` | Output | size | Data sent for CSR write operations |

---

# Internal Structure

The `Memory_WriteBack` module contains three main components:

| Instance | Module | Purpose |
|---|---|---|
| `LSU_mwb` | `Load_Store_Unit` | Handles load/store memory transactions |
| `M4_mwb` | `Mux_4` | Selects the write-back data source |
| `M2_CSR_WData_mwb` | `Mux_2` | Selects CSR write data source |


