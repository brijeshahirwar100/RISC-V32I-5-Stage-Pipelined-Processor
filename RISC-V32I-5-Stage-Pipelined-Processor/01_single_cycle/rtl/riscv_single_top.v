`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 23.10.2026
// Design Name: 
// Module Name: riscv_single_top
// Project Name: RV32I Single-Cycle Processor
// Target Devices: 
// Tool Versions: 
// Description: Integrates the single-cycle datapath and data memory.
// 
// Dependencies: datapath, data_mem
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module riscv_single_top (
    input  wire        clk,
    input  wire        reset,
    output wire [31:0] PC,
    output wire [31:0] Instr,
    output wire [31:0] ALUResult,
    output wire [31:0] ReadData,
    output wire [31:0] Result,
    output wire [31:0] WriteData,
    output wire        RegWrite,
    output wire        MemWrite
);
    // The top connects the datapath memory interface to data storage.
    datapath dp (
        .clk(clk), .reset(reset), .ReadData(ReadData),
        .PC(PC), .Instr(Instr), .ALUResult(ALUResult),
        .WriteData(WriteData), .Result(Result),
        .RegWrite(RegWrite), .MemWrite(MemWrite)
    );
    data_mem u_data_mem (
        .clk(clk), .WE(MemWrite), .A(ALUResult), .WD(WriteData), .RD(ReadData)
    );
endmodule
