# RV32I 5-Stage Pipelined CPU (VHDL)

A 5-stage pipelined RISC-V CPU implementing the full **RV32I** base integer
instruction set, written in VHDL and targeting a Xilinx Artix-7 FPGA.

## Architecture

```
IF  →  ID  →  EX  →  MEM  →  WB
```

| Stage | Function | Main modules |
|---|---|---|
| IF  | Instruction fetch, PC + 4 | `program_counter`, `inst_mem`, `pc_adder`, `pc_mux` |
| ID  | Decode, register read, immediate generation, hazard detection | `control_unit`, `register_file`, `imm_gen`, `hazard_detection_unit` |
| EX  | ALU, branch comparison, branch/jump target | `alu`, `alu_control`, `forwarding_mux`, `comparator`, `target_adder` |
| MEM | Data memory access | `data_memory` |
| WB  | Write-back select | `wb_mux` |

**Hazard handling**
- **Data hazards:** forwarding from EX/MEM and MEM/WB to the EX stage (ALU and branch comparator)
- **Load-use hazards:** detected in ID, resolved with a 1-cycle stall
- **Control hazards:** branches and jumps are resolved in EX; a taken branch or jump flushes the two younger instructions (2-cycle penalty)

**Memory access:** `lb`, `lh`, `lw`, `lbu`, `lhu`, `sb`, `sh`, `sw` with sign and zero extension.

<!-- Datapath diagram -->
![Datapath](docs/datapath.png)

## Implementation Results

Device: `xc7a35t...` &nbsp;|&nbsp; Tool: Vivado 2025.2

| Resource | Used | Available | Utilization |
|---|---|---|---|
| LUT       |  |  |  % |
| Flip-Flop |  |  |  % |
| BRAM      |  |  |  % |
| DSP       |  |  |  % |

| Timing | Value |
|---|---|
| Target clock | MHz |
| Max frequency (Fmax) | MHz |
| WNS | ns |

| Power | Value |
|---|---|
| Total   | W |
| Static  | W |
| Dynamic | W |

## Verification

### Test program

The CPU is verified with a **self-checking test program** of 484 instructions
(`programs/test_program.S`). It covers every RV32I instruction and the pipeline
hazard cases. Each test writes its result to a signature area in data memory
(`0x880`, 109 words). At the end, the program computes a checksum over all
results and writes the verdict to `x31`:

| `x31` | Meaning | Program halts at |
|---|---|---|
| `0x0000600D` | all tests pass | `0x760` |
| `0x00000BAD` | at least one test failed | `0x76C` |

**Algorithm**
```
Step 1: errors = 0
Step 2: for each test group t = 1 .. 19
Step 3:     run t and store each result to sig[k]
Step 4:     if a branch or jump goes the wrong way: errors = errors + 1
Step 5: s1 = 0, s2 = 0
Step 6: for i = 0 .. 108
Step 7:     s1 = s1 + sig[i];  s2 = s2 + s1
Step 8: if s1 = 0x44E3C504 and s2 = 0xDECB7F41 and errors = 0
            x31 = 0x600D   (pass)
        else
            x31 = 0x0BAD   (fail)
```

**Coverage**

| Test group | What it exercises |
|---|---|
| Dependent ADD chain, Fibonacci loop | EX→EX forwarding, backward branch, flush |
| Array sum (`lw` followed by `add`) | load-use stall |
| R-type and I-type ALU | all ALU operations, signed/unsigned compares, shift edge cases, ±2048 immediates |
| LUI / AUIPC | upper immediates, PC-relative values |
| Loads / stores | byte, halfword and word access, sign/zero extension, negative offsets, pointer load |
| Forwarding distance | operands produced 1, 2, 3 and 4 instructions earlier, back-to-back writes to the same register |
| `x0` writes | `x0` stays zero after `lui x0` and `lw x0` |
| All 6 branches | taken and not-taken cases, signed vs. unsigned |
| Branch after ALU / load | forwarding into the branch comparator |
| Back-to-back branches and jumps | correct flushing of wrong-path instructions |
| JAL / JALR | link register, negative offsets, odd JALR target (bit 0 cleared), jump to an address loaded from memory |
| Function calls | GCD by subtraction: `gcd(48, 18) = 6`, `gcd(35, 14) = 7` |

**Memory map**

| Address | Content |
|---|---|
| `0x000 – 0x78F` | program (484 instructions) |
| `0x800 – 0x87F` | data / scratch area |
| `0x87C` | error flag (`0xDEAD` is written on a failed branch/jump test) |
| `0x880 – 0xA33` | signature area (109 words) |

### Testbench

`sim/tb_core.vhd` drives the CPU and records an execution trace:

- **Clock:** 10 ns period (100 MHz).
- **Reset:** held high for 5 clock cycles, then released on a falling edge so the first rising edge sees a stable `reset = 0`.
- **Trace:** after reset, for 5000 cycles it samples the outputs 1 ns after each rising edge and writes `cycle, PC_out, ALU_Result` (hex) to `trace.csv`. `ALU_Result` is the value in the WB stage, so each line shows the result of the instruction that is retiring.
- **Checks:** `assert` statements warn whenever `PC_out` or `ALU_Result` contains `U` / `X` values.

**Running the simulation (Vivado)**
1. Load `programs/instr_program.mem` into the instruction memory (`FILE_NAME` generic of `inst_mem`).
2. Run behavioral simulation and enter `run 60 us`.
3. At the end, `PC_out` loops at `0x760` and register `x31` holds `0x0000600D`.

**Result:** all tests pass.

<!-- Waveform screenshot: PC_out looping at 0x760, x31 = 0000600D -->
![Simulation result](docs/simulation_result.png)

## Repository Structure

```
rtl/        VHDL sources
sim/        testbench
programs/   test_program.S    annotated assembly source
            test_program.c    C reference model (same 109 signature values)
            instr_program.mem machine code loaded into instruction memory
docs/       diagrams and screenshots
```
