`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 23.10.2026
// Design Name: 
// Module Name: riscv_multi_top
// Project Name: RV32I Multicycle Processor
// Target Devices: 
// Tool Versions: 
// Description: Connects the multicycle controller, datapath, and unified memory.
// 
// Dependencies: controller, datapath, mem
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module riscv_multi_top (
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
    wire AdrSrc;
    wire IRWrite;
    wire [1:0] ResultSrc;
    wire [1:0] ALUSrcA;
    wire [1:0] ALUSrcB;
    wire [3:0] ALUControl;
    wire [1:0] ImmSrc;
    wire PCWrite;
    wire Zero;
    wire [31:0] Adr;
    
    controller u_controller (
        .clk(clk), .reset(reset), .Op(Instr[6:0]),
        .funct3(Instr[14:12]), .funct7(Instr[31:25]), .Zero(Zero),
        .AdrSrc(AdrSrc), .IRWrite(IRWrite), .RegWrite(RegWrite),
        .MemWrite(MemWrite), .ResultSrc(ResultSrc), .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB), .ALUControl(ALUControl), .ImmSrc(ImmSrc),
        .PCWrite(PCWrite)
    );

    datapath dp (
        .clk(clk), .reset(reset), .PCWrite(PCWrite), .IRWrite(IRWrite),
        .RegWrite(RegWrite), .AdrSrc(AdrSrc), .ResultSrc(ResultSrc),
        .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .ALUControl(ALUControl),
        .ImmSrc(ImmSrc), .ReadData(ReadData),
        .PC(PC), .Instr(Instr), .Adr(Adr), .WriteData(WriteData),
        .ALUResult(ALUResult), .Zero(Zero), .Result(Result)
    );

    mem u_mem (
        .clk(clk), .WE(MemWrite), .Adr(Adr),
        .WriteData(WriteData), .ReadData(ReadData)
    );
endmodule
