`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 23.10.2026
// Design Name: 
// Module Name: controller
// Project Name: RV32I Five-Stage Pipeline
// Target Devices: 
// Tool Versions: 
// Description: Combines opcode and ALU decoding for the supported subset.
// Ports: Op[6:0], funct3[2:0], funct7[6:0], RegWrite, ImmSrc[1:0], ALUSrc,
//        MemWrite, ResultSrc[1:0], Branch, Jump, ALUControl[3:0]
// 
// Dependencies: maindec, aludec
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module controller (
    input  wire [6:0] Op,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    output wire       RegWrite,
    output wire [1:0] ImmSrc,
    output wire       ALUSrc,
    output wire       MemWrite,
    output wire [1:0] ResultSrc,
    output wire       Branch,
    output wire       Jump,
    output wire [3:0] ALUControl
);
    wire raw_RegWrite, raw_MemWrite, raw_Branch, raw_Jump, raw_ALUSrc;
    wire [1:0] raw_ResultSrc, raw_ImmSrc, ALUOp;
    wire ALUValid;

    maindec u_maindec (
        .Op(Op), .RegWrite(raw_RegWrite), .ImmSrc(raw_ImmSrc),
        .ALUSrc(raw_ALUSrc), .MemWrite(raw_MemWrite),
        .ResultSrc(raw_ResultSrc), .Branch(raw_Branch),
        .ALUOp(ALUOp), .Jump(raw_Jump)
    );
    aludec u_aludec (
        .ALUOp(ALUOp), .Op(Op), .funct3(funct3), .funct7(funct7),
        .ALUControl(ALUControl), .ALUValid(ALUValid)
    );

    // Invalid function encodings must not cause architectural side effects.
    assign RegWrite = raw_RegWrite & ALUValid;
    assign MemWrite = raw_MemWrite & ALUValid;
    assign Branch = raw_Branch & ALUValid;
    assign Jump = raw_Jump & ALUValid;
    assign ALUSrc = raw_ALUSrc;
    assign ImmSrc = raw_ImmSrc;
    assign ResultSrc = raw_ResultSrc;
endmodule
