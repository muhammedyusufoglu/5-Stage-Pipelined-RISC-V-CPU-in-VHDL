# RISC-V 32-bit CPU

5-stage pipelined RV32I CPU written in VHDL. All data and control hazards are
handled with forwarding, load-use stalls and branch flushing.

| | |
|---|---|
| Device | Artix-7 `xc7a35t...` |
| Frequency | 100 MHz |
| WNS | 0.137 ns |
| LUT | 4097 |
| FF | 1754 |

Measured CPI on the test program: 1.40

## Simulation

The CPU was tested with a self-checking program that runs every RV32I instruction types, with 484 instructions.

Each test writes its result to memory. At the end, the program computes a
checksum over all results and writes the verdict to `x31`:

- `x31 = 0x600D` → all tests passed
- `x31 = 0x0BAD` → at least one test failed

**Result:** `x31 = 0x600D`

