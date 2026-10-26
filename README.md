# RV32I Processor Implementations

This repository contains three self-contained Verilog processor projects: a single-cycle core, a multicycle core, and a five-stage pipelined core. Each design has its own RTL, testbench, memory image, and design README.

## Designs

| Folder | Architecture | Main features | Testbenches |
|---|---|---|---|
| [01_single_cycle](01_single_cycle/README.md) | Single-cycle | Separate instruction and data memories; arithmetic, memory, branch, and JAL operations used by the program. | `tb_single` |
| [02_multicycle](02_multicycle/README.md) | Multicycle | Main FSM, shared datapath, unified instruction/data memory. | `tb_multi` |
| [03_pipelined](03_pipelined/README.md) | Five-stage pipeline | Fetch, Decode, Execute, Memory, Writeback; forwarding, load-use stall, and branch/JAL flush handling. | `tb_forwarding`, `tb_lwstall`, `tb_flush`, `tb_pipeline`, `tb_golden` |

The pipeline resolves branch and JAL control in Execute with predict-not-taken. Execute forwarding selects Memory before Writeback and does not forward x0. A load-use dependency inserts a one-cycle stall; `FlushD = PCSrcE` and `FlushE = lwStall | PCSrcE`. The pipeline register boundaries are F/D, D/E, E/M, and M/W. The register file writes on the falling edge.

## Test programs and reported results

| Design / testbench | Program image | Checks or reported result |
|---|---|---|
| Single-cycle `tb_single` | `01_single_cycle/mem/program.hex` | Checks x0–x14 and data-memory words 0–1. The project README gives the expected values; a saved PASS transcript is not included here. |
| Multicycle `tb_multi` | `02_multicycle/mem/program.hex` | The Tcl capture reports 73 cycles to PC 84 and PASS for register, memory, and state-sequence checks. |
| Pipeline `tb_forwarding` | `03_pipelined/mem/test_forwarding.hex` | Directed forwarding test; expected register values are listed in the pipeline README. |
| Pipeline `tb_lwstall` | `03_pipelined/mem/test_lwstall.hex` | Directed load-use test; expected register and memory values are listed in the pipeline README. |
| Pipeline `tb_flush` | `03_pipelined/mem/test_flush.hex` | Directed branch/JAL test; the testbench checks 31 register and memory values. |
| Pipeline `tb_pipeline` | `03_pipelined/mem/program_padded.hex` | User-reported Vivado run passed 17 checks; x11 is 0xD8. |
| Pipeline `tb_golden` | `03_pipelined/mem/program_golden.hex` | User-reported Vivado run passed 17 checks; x11 is 0x40 and the checked state matches the single-cycle core. |

The user reports that all five pipeline testbenches passed in Vivado. For each pipeline test, copy its listed image to `03_pipelined/mem/program.hex` before running.

## Before running in Vivado

Each instruction memory uses an absolute `$readmemh` path. Update the path to the `mem/program.hex` in the corresponding design folder before simulation:

- `01_single_cycle/rtl/instr_mem.v`, line 28
- `02_multicycle/rtl/mem.v`, line 34
- `03_pipelined/rtl/instr_mem.v`, line 28

Add one design's `rtl/` files as Design Sources and its testbench as a Simulation Source. Set that testbench as the simulation top, choose **Run Behavioral Simulation**, then **Run All**. See each design README for its test-specific instructions and images.

## Repository layout

```text
RISC-V32I-5-Stage-Pipelined-Processor/
├── README.md
├── 01_single_cycle/
│   ├── README.md
│   ├── doc/
│   ├── mem/
│   ├── rtl/
│   └── tb/
├── 02_multicycle/
│   ├── README.md
│   ├── doc/img/
│   ├── mem/
│   ├── rtl/
│   └── tb/
└── 03_pipelined/
    ├── README.md
    ├── doc/ (waveforms, schematics, padded listing, schematic PDF)
    ├── mem/
    ├── rtl/
    └── tb/
```
## Author

**Brijesh Ahirwar**  
Electronics and Communication Engineering (ECE)  
Indian Institute of Technology (BHU), Varanasi

## Reference

The processor designs follow concepts in Harris & Harris, *Digital Design and Computer Architecture: RISC-V Edition*, Chapter 7.
