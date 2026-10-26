`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 23.10.2026
// Design Name: 
// Module Name: maindec
// Project Name: RV32I Single-Cycle Processor
// Target Devices: 
// Tool Versions: 
// Description: Selects datapath controls from the instruction opcode.
// 
// Dependencies: none
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module maindec (
    input  wire [6:0] Op,
    output reg        RegWrite,
    output reg [1:0]  ImmSrc,
    output reg        ALUSrc,
    output reg        MemWrite,
    output reg [1:0]  ResultSrc,
    output reg        Branch,
    output reg [1:0]  ALUOp,
    output reg        Jump
);
    // Defaults define safe controls for unsupported opcodes and avoid latches.
    always @(*) begin
        RegWrite = 1'b0;
        ImmSrc = 2'b00;
        ALUSrc = 1'b0;
        MemWrite = 1'b0;
        ResultSrc = 2'b00;
        Branch = 1'b0;
        ALUOp = 2'b00;
        Jump = 1'b0;
        case (Op)
            7'b0000011: begin
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                ResultSrc = 2'b01;
            end
            7'b0100011: begin
                ImmSrc = 2'b01;
                ALUSrc = 1'b1;
                MemWrite = 1'b1;
            end
            7'b0110011: begin
                RegWrite = 1'b1;
                ALUOp = 2'b10;
            end
            7'b1100011: begin
                ImmSrc = 2'b10;
                ALUOp = 2'b01;
                Branch = 1'b1;
            end
            7'b0010011: begin
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                ALUOp = 2'b10;
            end
            7'b1101111: begin
                RegWrite = 1'b1;
                ImmSrc = 2'b11;
                ResultSrc = 2'b10;
                Jump = 1'b1;
            end
            default: begin end
        endcase
    end
endmodule
