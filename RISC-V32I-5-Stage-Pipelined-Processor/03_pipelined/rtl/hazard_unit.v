`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 26.10.2026
// Design Name: 
// Module Name: hazard_unit
// Project Name: RV32I Five-Stage Pipeline
// Target Devices: 
// Tool Versions: 
// Description: Selects forwarding sources and generates stall and flush controls.
// Ports: Rs1D[4:0], Rs2D[4:0], Rs1E[4:0], Rs2E[4:0], RdE[4:0], RdM[4:0],
//        RdW[4:0], RegWriteM, RegWriteW, ResultSrcE[1:0], PCSrcE,
//        ForwardAE[1:0], ForwardBE[1:0], StallF, StallD, FlushD, FlushE
// 
// Dependencies: none
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module hazard_unit (
    input  wire [4:0] Rs1D,
    input  wire [4:0] Rs2D,
    input  wire [4:0] Rs1E,
    input  wire [4:0] Rs2E,
    input  wire [4:0] RdE,
    input  wire [4:0] RdM,
    input  wire [4:0] RdW,
    input  wire       RegWriteM,
    input  wire       RegWriteW,
    input  wire [1:0] ResultSrcE,
    input  wire       PCSrcE,
    output reg  [1:0] ForwardAE,
    output reg  [1:0] ForwardBE,
    output reg        StallF,
    output reg        StallD,
    output reg        FlushD,
    output reg        FlushE
);
    wire lwStall;

    assign lwStall = ResultSrcE[0] & ((Rs1D == RdE) | (Rs2D == RdE));

    // Memory forwarding has priority; register zero is never forwarded.
    always @(*) begin
        ForwardAE = 2'b00;
        ForwardBE = 2'b00;
        StallF = lwStall;
        StallD = lwStall;
        FlushD = PCSrcE;
        FlushE = lwStall | PCSrcE;

        if (RegWriteM && (RdM != 5'd0) && (RdM == Rs1E))
            ForwardAE = 2'b10;
        else if (RegWriteW && (RdW != 5'd0) && (RdW == Rs1E))
            ForwardAE = 2'b01;

        if (RegWriteM && (RdM != 5'd0) && (RdM == Rs2E))
            ForwardBE = 2'b10;
        else if (RegWriteW && (RdW != 5'd0) && (RdW == Rs2E))
            ForwardBE = 2'b01;
    end
endmodule
