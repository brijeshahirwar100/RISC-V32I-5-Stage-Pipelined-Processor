`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 23.10.2026
// Design Name: 
// Module Name: alu
// Project Name: RV32I Single-Cycle Processor
// Target Devices: 
// Tool Versions: 
// Description: Executes the arithmetic and logic operations used by the core.
// 
// Dependencies: none
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module alu (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [3:0]  ALUControl,
    output reg  [31:0] ALUResult,
    output wire        Zero
);
    localparam [3:0] ADD = 4'b0000;
    localparam [3:0] SUB = 4'b0001;
    localparam [3:0] AND_OP = 4'b0010;
    localparam [3:0] OR_OP = 4'b0011;
    localparam [3:0] SLT = 4'b1000;

    // These are the only ALU operations used by the supported instruction set.
    always @(*) begin
        case (ALUControl)
            ADD:    ALUResult = A + B;
            SUB:    ALUResult = A - B;
            AND_OP: ALUResult = A & B;
            OR_OP:  ALUResult = A | B;
            SLT:    ALUResult = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
            default: ALUResult = 32'd0;
        endcase
    end

    // Branch logic uses Zero after subtracting the two operands.
    assign Zero = (ALUResult == 32'd0);
endmodule
