# RISC-V 32-bit CPU

5-stage pipelined RV32I CPU written in VHDL. All data and control hazards are
handled with forwarding, load-use stalls and branch flushing.

| | |
|---|---|
| Device | Artix-7 `xc7a35t...` |
| Frequency | MHz |
| WNS | ns |
| LUT | |
| FF | |

## Simulation

The CPU was tested with a self-checking program (`programs/test_program.S`,
484 instructions) that runs every RV32I instruction, including loads/stores,
branches, jumps, function calls and the pipeline hazard cases.

Each test writes its result to memory. At the end, the program computes a
checksum over all results and writes the verdict to `x31`:

- `x31 = 0x600D` → all tests passed
- `x31 = 0x0BAD` → at least one test failed

The testbench (`sim/tb_core.vhd`) runs the CPU with a 10 ns clock and writes
`PC` and `ALU_Result` for every cycle to `trace.csv`. Run it with `run 60 us`.

**Result:** `x31 = 0x600D`

![Simulation result](docs/simulation_result.png)
