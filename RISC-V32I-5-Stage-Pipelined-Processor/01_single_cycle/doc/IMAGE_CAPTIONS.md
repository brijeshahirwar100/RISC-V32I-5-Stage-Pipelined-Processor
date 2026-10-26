# Image Caption Review — Single-Cycle

| file | caption | where used |
|---|---|---|
| `doc/Screenshot_2026-10-23_004535.png` | Vivado elaborated controller schematic showing the `maindec` and `aludec` blocks and their control-signal connections. | `README.md`, Figure 1 |
| `doc/Screenshot_2026-10-23_004609.png` | Vivado elaborated data-memory schematic showing address comparison, the memory register, write controls, and the read mux connected to `A`, `WD`, `WE`, `clk`, and `RD`. | `README.md`, Figure 2 |
| `doc/Screenshot_2026-10-23_004633.png` | Vivado elaborated instruction-memory schematic showing a ROM, address comparison, and output mux between the address input and instruction output. | `README.md`, Figure 3 |
| `doc/Screenshot_2026-10-23_004714.png` | Vivado elaborated ALU schematic showing add, subtract, AND, OR, less-than, result selection, and the `Zero` output. | `README.md`, Figure 4 |
| `doc/Single_Cycle_Schematics_DP.png` | Vivado elaborated schematic of the single-cycle datapath showing its controller, register file, PC and target logic, ALU, extender, and muxes. | `README.md`, Figure 5 |
| `doc/Single_Cycle_Schematics.png` | Top-level block diagram connecting the controller/datapath to data memory and exposing the clock, reset, memory, PC, instruction, and result signals. | `README.md`, Figure 6 |
| `doc/Single_Cycle_Simulation_hex.png` | The 0–150 ns simulation waveform shows `PC`, hexadecimal `Instr`, `ALUResult`, `ReadData`, `Result`, `WriteData`, `RegWrite`, and `MemWrite`; the cursor is at 140.823 ns. | `README.md`, Figure 7 |
| `doc/Single_Cycle_Simulation.png` | The 0–220 ns simulation waveform shows `PC`, `Instr`, `ALUResult`, `ReadData`, `Result`, `WriteData`, `RegWrite`, and `MemWrite` through the final displayed PC value of 84. | `README.md`, Figure 8 |
