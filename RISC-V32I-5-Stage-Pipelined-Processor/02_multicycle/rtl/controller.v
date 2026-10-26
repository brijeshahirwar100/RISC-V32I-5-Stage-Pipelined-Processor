`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 23.10.2026
// Design Name: 
// Module Name: controller
// Project Name: RV32I Multicycle Processor
// Target Devices: 
// Tool Versions: 
// Description: Combines the multicycle FSM and instruction ALU decoder.
// 
// Dependencies: mainfsm, aludec
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module controller (
    input  wire       clk,
    input  wire       reset,
    input  wire [6:0] Op,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    input  wire       Zero,
    output wire       AdrSrc,
    output wire       IRWrite,
    output wire       RegWrite,
    output wire       MemWrite,
    output wire [1:0] ResultSrc,
    output wire [1:0] ALUSrcA,
    output wire [1:0] ALUSrcB,
    output wire [3:0] ALUControl,
    output wire [1:0] ImmSrc,
    output wire       PCWrite
);
    wire [1:0] ALUOp;
    wire PCUpdate;
    wire Branch;
    wire FSMRegWrite;

    mainfsm u_mainfsm (
        .clk(clk), .reset(reset), .Op(Op), .AdrSrc(AdrSrc),
        .IRWrite(IRWrite), .RegWrite(FSMRegWrite), .MemWrite(MemWrite),
        .ResultSrc(ResultSrc), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB),
        .ALUOp(ALUOp), .ImmSrc(ImmSrc), .PCUpdate(PCUpdate),
        .Branch(Branch)
    );

    aludec u_aludec (
        .ALUOp(ALUOp), .Op(Op), .funct3(funct3), .funct7(funct7),
        .ALUControl(ALUControl)
    );

    assign RegWrite = FSMRegWrite;
    assign PCWrite = PCUpdate | (Branch & Zero);
endmodule
