`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 23.10.2026
// Design Name: 
// Module Name: mainfsm
// Project Name: RV32I Multicycle Processor
// Target Devices: 
// Tool Versions: 
// Description: Sequences the RV32I multicycle controller through S0-S10.
// 
// Dependencies: none
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// State table: S0 Fetch, S1 Decode, S2 MemAdr, S3 MemRead, S4 MemWB,
// S5 MemWrite, S6 ExecuteR, S7 ALUWB, S8 ExecuteI, S9 JAL, S10 BEQ.
//////////////////////////////////////////////////////////////////////////////////
module mainfsm (
    input  wire       clk,
    input  wire       reset,
    input  wire [6:0] Op,
    output reg        AdrSrc,
    output reg        IRWrite,
    output reg        RegWrite,
    output reg        MemWrite,
    output reg [1:0]  ResultSrc,
    output reg [1:0]  ALUSrcA,
    output reg [1:0]  ALUSrcB,
    output reg [1:0]  ALUOp,
    output reg [1:0]  ImmSrc,
    output reg        PCUpdate,
    output reg        Branch
);
    localparam [3:0] S0  = 4'd0;
    localparam [3:0] S1  = 4'd1;
    localparam [3:0] S2  = 4'd2;
    localparam [3:0] S3  = 4'd3;
    localparam [3:0] S4  = 4'd4;
    localparam [3:0] S5  = 4'd5;
    localparam [3:0] S6  = 4'd6;
    localparam [3:0] S7  = 4'd7;
    localparam [3:0] S8  = 4'd8;
    localparam [3:0] S9  = 4'd9;
    localparam [3:0] S10 = 4'd10;

    reg [3:0] state;
    reg [3:0] nextState;

    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= nextState;
    end

    always @(*) begin
        nextState = S0;
        AdrSrc = 1'b0;
        IRWrite = 1'b0;
        RegWrite = 1'b0;
        MemWrite = 1'b0;
        ResultSrc = 2'b00;
        ALUSrcA = 2'b00;
        ALUSrcB = 2'b10;
        ALUOp = 2'b00;
        ImmSrc = 2'b00;
        PCUpdate = 1'b0;
        Branch = 1'b0;

        case (state)
            S0: begin
                IRWrite = 1'b1;
                PCUpdate = 1'b1;
                ResultSrc = 2'b10;
                nextState = S1;
            end
            S1: begin
                ALUSrcA = 2'b01;
                ALUSrcB = 2'b01;
                case (Op)
                    7'b0000011: begin ImmSrc = 2'b00; nextState = S2; end
                    7'b0100011: begin ImmSrc = 2'b01; nextState = S2; end
                    7'b0110011: nextState = S6;
                    7'b0010011: begin ImmSrc = 2'b00; nextState = S8; end
                    7'b1100011: begin ImmSrc = 2'b10; nextState = S10; end
                    7'b1101111: begin ImmSrc = 2'b11; nextState = S9; end
                    default: nextState = S0;
                endcase
            end
            S2: begin
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b01;
                if (Op == 7'b0000011) begin
                    ImmSrc = 2'b00;
                    nextState = S3;
                end else if (Op == 7'b0100011) begin
                    ImmSrc = 2'b01;
                    nextState = S5;
                end
            end
            S3: begin
                AdrSrc = 1'b1;
                nextState = S4;
            end
            S4: begin
                RegWrite = 1'b1;
                ResultSrc = 2'b01;
                nextState = S0;
            end
            S5: begin
                AdrSrc = 1'b1;
                MemWrite = 1'b1;
                nextState = S0;
            end
            S6: begin
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b00;
                ALUOp = 2'b10;
                nextState = S7;
            end
            S7: begin
                RegWrite = 1'b1;
                ALUOp = 2'b10;
                nextState = S0;
            end
            S8: begin
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b01;
                ALUOp = 2'b10;
                ImmSrc = 2'b00;
                nextState = S7;
            end
            S9: begin
                ALUSrcA = 2'b01;
                ALUSrcB = 2'b10;
                PCUpdate = 1'b1;
                nextState = S7;
            end
            S10: begin
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b00;
                ALUOp = 2'b01;
                Branch = 1'b1;
                nextState = S0;
            end
            default: nextState = S0;
        endcase
    end
endmodule
