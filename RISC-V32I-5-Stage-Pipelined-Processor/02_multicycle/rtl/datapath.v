`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 23.10.2026
// Design Name: 
// Module Name: datapath
// Project Name: RV32I Multicycle Processor
// Target Devices: 
// Tool Versions: 
// Description: Stores multicycle datapath values and executes ALU operations.
// 
// Dependencies: pc, regfile, extend, alu, mux2, mux3
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module datapath (
    input  wire        clk,
    input  wire        reset,
    input  wire        PCWrite,
    input  wire        IRWrite,
    input  wire        RegWrite,
    input  wire        AdrSrc,
    input  wire [1:0]  ResultSrc,
    input  wire [1:0]  ALUSrcA,
    input  wire [1:0]  ALUSrcB,
    input  wire [3:0]  ALUControl,
    input  wire [1:0]  ImmSrc,
    input  wire [31:0] ReadData,
    output wire [31:0] PC,
    output wire [31:0] Instr,
    output wire [31:0] Adr,
    output wire [31:0] WriteData,
    output wire [31:0] ALUResult,
    output wire        Zero,
    output wire [31:0] Result
);
    reg [31:0] IR;
    reg [31:0] OldPC;
    reg [31:0] A;
    reg [31:0] WriteDataReg;
    reg [31:0] ALUOut;
    reg [31:0] Data;
    wire [31:0] RD1;
    wire [31:0] RD2;
    wire [31:0] ImmExt;
    wire [31:0] SrcA;
    wire [31:0] SrcB;
    wire [31:0] PCIncrement;
    wire [31:0] Four;

    assign Instr = IR;
    assign WriteData = WriteDataReg;
    assign Four = 32'd4;

    pc u_pc (
        .clk(clk), .reset(reset), .PCWrite(PCWrite),
        .PCNext(Result), .PC(PC)
    );

    regfile u_regfile (
        .clk(clk), .reset(reset), .WE3(RegWrite),
        .A1(IR[19:15]), .A2(IR[24:20]), .A3(IR[11:7]),
        .WD3(Result), .RD1(RD1), .RD2(RD2)
    );

    extend u_extend (.Instr(IR), .ImmSrc(ImmSrc), .ImmExt(ImmExt));
    alu u_alu (.A(SrcA), .B(SrcB), .ALUControl(ALUControl),
               .ALUResult(ALUResult), .Zero(Zero));
    mux3 u_alu_src_a (.A(PC), .B(OldPC), .C(A), .Sel(ALUSrcA), .Y(SrcA));
    mux3 u_alu_src_b (.A(WriteDataReg), .B(ImmExt), .C(Four),
                      .Sel(ALUSrcB), .Y(SrcB));
    mux3 u_result (.A(ALUOut), .B(Data), .C(ALUResult),
                   .Sel(ResultSrc), .Y(Result));
    mux2 u_adr (.A(PC), .B(ALUOut), .Sel(AdrSrc), .Y(Adr));

    always @(posedge clk) begin
        A <= RD1;
        WriteDataReg <= RD2;
        ALUOut <= ALUResult;
        Data <= ReadData;
        if (IRWrite) begin
            IR <= ReadData;
            OldPC <= PC;
        end
    end
endmodule
