`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 26.10.2026
// Design Name: 
// Module Name: riscv_pipeline_top
// Project Name: RV32I Five-Stage Pipeline
// Target Devices: 
// Tool Versions: 
// Description: Connects the five-stage datapath to data memory.
// Ports: clk, reset, PCF[31:0], InstrD[31:0], ALUResultM[31:0], ReadDataM[31:0],
//        ReadDataW[31:0], WriteDataM[31:0], ResultW[31:0], RegWriteW, MemWriteM, PCSrcE
// 
// Dependencies: datapath, data_mem
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module riscv_pipeline_top (
    input  wire        clk,
    input  wire        reset,
    output wire [31:0] PCF,
    output wire [31:0] InstrD,
    output wire [31:0] ALUResultM,
    output wire [31:0] ReadDataM,
    output wire [31:0] ReadDataW,
    output wire [31:0] WriteDataM,
    output wire [31:0] ResultW,
    output wire        RegWriteW,
    output wire        MemWriteM,
    output wire        PCSrcE
);
    // The datapath presents its Memory-stage interface to data memory.
    datapath dp (
        .clk(clk), .reset(reset), .ReadDataM(ReadDataM),
        .PCF(PCF), .InstrD(InstrD), .ALUResultM(ALUResultM),
        .ReadDataW(ReadDataW), .WriteDataM(WriteDataM), .ResultW(ResultW),
        .RegWriteW(RegWriteW), .MemWriteM(MemWriteM), .PCSrcE(PCSrcE)
    );
    data_mem u_data_mem (
        .clk(clk), .WE(MemWriteM), .A(ALUResultM), .WD(WriteDataM), .RD(ReadDataM)
    );
endmodule
