`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 23.10.2026
// Design Name: 
// Module Name: datapath
// Project Name: RV32I Single-Cycle Processor
// Target Devices: 
// Tool Versions: 
// Description: Connects fetch, decode, execute, and writeback logic.
// 
// Dependencies: pc, instr_mem, regfile, extend, mux2, controller, alu, adder, mux3
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module datapath (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] ReadData,
    output wire [31:0] PC,
    output wire [31:0] Instr,
    output wire [31:0] ALUResult,
    output wire [31:0] WriteData,
    output wire [31:0] Result,
    output wire        RegWrite,
    output wire        MemWrite
);
    wire [31:0] PCNext, PCPlus4, PCTarget, ImmExt, SrcA, SrcB;
    wire [3:0] ALUControl;
    wire [1:0] ImmSrc, ResultSrc;
    wire ALUSrc, Branch, Jump, PCSrc, Zero;
    wire [31:0] RD1, RD2;

    // Fetch uses a byte PC while the instruction memory indexes words.
    pc u_pc (.clk(clk), .reset(reset), .PCNext(PCNext), .PC(PC));
    instr_mem u_instr_mem (.A(PC), .RD(Instr));

    // Two asynchronous register reads provide operands and store data.
    regfile u_regfile (
        .clk(clk), .reset(reset), .WE3(RegWrite),
        .A1(Instr[19:15]), .A2(Instr[24:20]), .A3(Instr[11:7]),
        .WD3(Result), .RD1(RD1), .RD2(RD2)
    );
    assign SrcA = RD1;
    assign WriteData = RD2;
    extend u_extend (.Instr(Instr), .ImmSrc(ImmSrc), .ImmExt(ImmExt));
    mux2 u_srcb_mux (.A(WriteData), .B(ImmExt), .Sel(ALUSrc), .Y(SrcB));

    // Decode and execute the supported instruction functions.
    controller u_controller (
        .Op(Instr[6:0]), .funct3(Instr[14:12]), .funct7(Instr[31:25]),
        .RegWrite(RegWrite), .ImmSrc(ImmSrc), .ALUSrc(ALUSrc),
        .MemWrite(MemWrite), .ResultSrc(ResultSrc), .Branch(Branch),
        .Jump(Jump), .ALUControl(ALUControl)
    );
    alu u_alu (
        .A(SrcA), .B(SrcB), .ALUControl(ALUControl),
        .ALUResult(ALUResult), .Zero(Zero)
    );

    // PC selection handles branches and jumps; writeback selects the result source.
    adder u_pc_plus4 (.A(PC), .B(32'd4), .Sum(PCPlus4));
    adder u_pc_target (.A(PC), .B(ImmExt), .Sum(PCTarget));
    assign PCSrc = (Branch & Zero) | Jump;
    mux2 u_pc_mux (.A(PCPlus4), .B(PCTarget), .Sel(PCSrc), .Y(PCNext));
    mux3 u_result_mux (
        .A(ALUResult), .B(ReadData), .C(PCPlus4), .Sel(ResultSrc), .Y(Result)
    );
endmodule
