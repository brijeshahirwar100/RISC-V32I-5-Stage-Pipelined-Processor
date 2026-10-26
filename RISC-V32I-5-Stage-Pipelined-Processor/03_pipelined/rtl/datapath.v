`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 26.10.2026
// Design Name: 
// Module Name: datapath
// Project Name: RV32I Five-Stage Pipeline
// Target Devices: 
// Tool Versions: 
// Description: Connects the Fetch, Decode, Execute, Memory, and Writeback stages.
// Ports: clk, reset, ReadDataM[31:0], PCF[31:0], InstrD[31:0], ALUResultM[31:0],
//        ReadDataW[31:0], WriteDataM[31:0], ResultW[31:0], RegWriteW, MemWriteM, PCSrcE
// 
// Dependencies: pc, instr_mem, regfile, extend, mux2, mux3, controller, alu, adder, pipeline_reg, hazard_unit
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module datapath (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] ReadDataM,
    output wire [31:0] PCF,
    output wire [31:0] InstrD,
    output wire [31:0] ALUResultM,
    output wire [31:0] ReadDataW,
    output wire [31:0] WriteDataM,
    output wire [31:0] ResultW,
    output wire        RegWriteW,
    output wire        MemWriteM,
    output wire        PCSrcE
);
    wire [31:0] PCNextF, PCPlus4F, InstrF;
    wire [31:0] PCD, PCPlus4D;
    wire [31:0] RD1D, RD2D, ImmExtD;
    wire [4:0]  Rs1D, Rs2D, RdD;
    wire [3:0]  ALUControlD;
    wire [1:0]  ImmSrcD, ResultSrcD;
    wire ALUSrcD, RegWriteD, MemWriteD, BranchD, JumpD;

    wire [31:0] PCE, PCPlus4E, RD1E, RD2E, ImmExtE;
    wire [4:0]  Rs1E, Rs2E, RdE;
    wire [3:0]  ALUControlE;
    wire [1:0]  ResultSrcE;
    wire ALUSrcE, RegWriteE, MemWriteE, BranchE, JumpE;
    wire [31:0] SrcAE, SrcBE, ALUResultE, PCTargetE, WriteDataE;
    wire ZeroE;

    wire [31:0] ALUResultW, PCPlus4M, PCPlus4W;
    wire [4:0]  RdM, RdW;
    wire [1:0]  ResultSrcM, ResultSrcW;
    wire RegWriteM;
    wire [1:0] ForwardAE, ForwardBE;
    wire StallF, StallD, FlushD, FlushE;
    wire EnD, ClrD, ClrE, EnF;
    wire [31:0] ForwardedAE, ForwardedBE;

    assign EnD = ~StallD;
    assign ClrD = reset | FlushD;
    assign ClrE = reset | FlushE;
    assign EnF = ~StallF;

    hazard_unit u_hazard_unit (
        .Rs1D(Rs1D), .Rs2D(Rs2D), .Rs1E(Rs1E), .Rs2E(Rs2E), .RdE(RdE),
        .RdM(RdM), .RdW(RdW), .RegWriteM(RegWriteM), .RegWriteW(RegWriteW),
        .ResultSrcE(ResultSrcE), .PCSrcE(PCSrcE),
        .ForwardAE(ForwardAE), .ForwardBE(ForwardBE),
        .StallF(StallF), .StallD(StallD), .FlushD(FlushD), .FlushE(FlushE)
    );

    // Fetch selects the next sequential instruction or an Execute-stage target.
    pc u_pc (
        .clk(clk), .reset(reset), .EN(EnF), .PCNext(PCNextF), .PC(PCF)
    );
    instr_mem u_instr_mem (.A(PCF), .RD(InstrF));
    adder u_pc_plus4_f (.A(PCF), .B(32'd4), .Sum(PCPlus4F));
    mux2 u_pc_mux (
        .A(PCPlus4F), .B(PCTargetE), .Sel(PCSrcE), .Y(PCNextF)
    );

    // Fetch/Decode carries the instruction address and instruction together.
    pipeline_reg #(.WIDTH(32)) u_fd_instr (
        .clk(clk), .EN(EnD), .CLR(ClrD), .D(InstrF), .Q(InstrD)
    );
    pipeline_reg #(.WIDTH(32)) u_fd_pc (
        .clk(clk), .EN(EnD), .CLR(ClrD), .D(PCF), .Q(PCD)
    );
    pipeline_reg #(.WIDTH(32)) u_fd_pc_plus4 (
        .clk(clk), .EN(EnD), .CLR(ClrD), .D(PCPlus4F), .Q(PCPlus4D)
    );

    // Decode reads registers, builds the immediate, and decodes controls.
    assign Rs1D = InstrD[19:15];
    assign Rs2D = InstrD[24:20];
    assign RdD  = InstrD[11:7];
    regfile u_regfile (
        .clk(clk), .reset(reset), .WE3(RegWriteW),
        .A1(Rs1D), .A2(Rs2D), .A3(RdW), .WD3(ResultW),
        .RD1(RD1D), .RD2(RD2D)
    );
    controller u_controller (
        .Op(InstrD[6:0]), .funct3(InstrD[14:12]), .funct7(InstrD[31:25]),
        .RegWrite(RegWriteD), .ImmSrc(ImmSrcD), .ALUSrc(ALUSrcD),
        .MemWrite(MemWriteD), .ResultSrc(ResultSrcD), .Branch(BranchD),
        .Jump(JumpD), .ALUControl(ALUControlD)
    );
    extend u_extend (.Instr(InstrD), .ImmSrc(ImmSrcD), .ImmExt(ImmExtD));

    // Decode/Execute carries operands, addresses, destinations, and controls.
    pipeline_reg #(.WIDTH(32)) u_de_pc (
        .clk(clk), .EN(1'b1), .CLR(ClrE), .D(PCD), .Q(PCE)
    );
    pipeline_reg #(.WIDTH(32)) u_de_pc_plus4 (
        .clk(clk), .EN(1'b1), .CLR(ClrE), .D(PCPlus4D), .Q(PCPlus4E)
    );
    pipeline_reg #(.WIDTH(32)) u_de_rd1 (
        .clk(clk), .EN(1'b1), .CLR(ClrE), .D(RD1D), .Q(RD1E)
    );
    pipeline_reg #(.WIDTH(32)) u_de_rd2 (
        .clk(clk), .EN(1'b1), .CLR(ClrE), .D(RD2D), .Q(RD2E)
    );
    pipeline_reg #(.WIDTH(32)) u_de_imm (
        .clk(clk), .EN(1'b1), .CLR(ClrE), .D(ImmExtD), .Q(ImmExtE)
    );
    pipeline_reg #(.WIDTH(5)) u_de_rs1 (
        .clk(clk), .EN(1'b1), .CLR(ClrE), .D(Rs1D), .Q(Rs1E)
    );
    pipeline_reg #(.WIDTH(5)) u_de_rs2 (
        .clk(clk), .EN(1'b1), .CLR(ClrE), .D(Rs2D), .Q(Rs2E)
    );
    pipeline_reg #(.WIDTH(5)) u_de_rd (
        .clk(clk), .EN(1'b1), .CLR(ClrE), .D(RdD), .Q(RdE)
    );
    pipeline_reg #(.WIDTH(4)) u_de_alucontrol (
        .clk(clk), .EN(1'b1), .CLR(ClrE), .D(ALUControlD), .Q(ALUControlE)
    );
    pipeline_reg #(.WIDTH(1)) u_de_alusrc (
        .clk(clk), .EN(1'b1), .CLR(ClrE), .D(ALUSrcD), .Q(ALUSrcE)
    );
    pipeline_reg #(.WIDTH(1)) u_de_regwrite (
        .clk(clk), .EN(1'b1), .CLR(ClrE), .D(RegWriteD), .Q(RegWriteE)
    );
    pipeline_reg #(.WIDTH(2)) u_de_resultsrc (
        .clk(clk), .EN(1'b1), .CLR(ClrE), .D(ResultSrcD), .Q(ResultSrcE)
    );
    pipeline_reg #(.WIDTH(1)) u_de_memwrite (
        .clk(clk), .EN(1'b1), .CLR(ClrE), .D(MemWriteD), .Q(MemWriteE)
    );
    pipeline_reg #(.WIDTH(1)) u_de_branch (
        .clk(clk), .EN(1'b1), .CLR(ClrE), .D(BranchD), .Q(BranchE)
    );
    pipeline_reg #(.WIDTH(1)) u_de_jump (
        .clk(clk), .EN(1'b1), .CLR(ClrE), .D(JumpD), .Q(JumpE)
    );

    // Execute computes the ALU result and resolves branch and JAL targets.
    mux3 u_forward_a_mux (
        .A(RD1E), .B(ResultW), .C(ALUResultM), .Sel(ForwardAE), .Y(ForwardedAE)
    );
    mux3 u_forward_b_mux (
        .A(RD2E), .B(ResultW), .C(ALUResultM), .Sel(ForwardBE), .Y(ForwardedBE)
    );
    assign SrcAE = ForwardedAE;
    assign WriteDataE = ForwardedBE;
    mux2 u_srcb_mux (
        .A(ForwardedBE), .B(ImmExtE), .Sel(ALUSrcE), .Y(SrcBE)
    );
    alu u_alu (
        .A(SrcAE), .B(SrcBE), .ALUControl(ALUControlE),
        .ALUResult(ALUResultE), .Zero(ZeroE)
    );
    adder u_pc_target_e (.A(PCE), .B(ImmExtE), .Sum(PCTargetE));
    assign PCSrcE = (BranchE & ZeroE) | JumpE;

    // Execute/Memory carries results and store data to the Memory stage.
    pipeline_reg #(.WIDTH(32)) u_em_aluresult (
        .clk(clk), .EN(1'b1), .CLR(reset), .D(ALUResultE), .Q(ALUResultM)
    );
    pipeline_reg #(.WIDTH(32)) u_em_writedata (
        .clk(clk), .EN(1'b1), .CLR(reset), .D(WriteDataE), .Q(WriteDataM)
    );
    pipeline_reg #(.WIDTH(32)) u_em_pc_plus4 (
        .clk(clk), .EN(1'b1), .CLR(reset), .D(PCPlus4E), .Q(PCPlus4M)
    );
    pipeline_reg #(.WIDTH(5)) u_em_rd (
        .clk(clk), .EN(1'b1), .CLR(reset), .D(RdE), .Q(RdM)
    );
    pipeline_reg #(.WIDTH(1)) u_em_regwrite (
        .clk(clk), .EN(1'b1), .CLR(reset), .D(RegWriteE), .Q(RegWriteM)
    );
    pipeline_reg #(.WIDTH(2)) u_em_resultsrc (
        .clk(clk), .EN(1'b1), .CLR(reset), .D(ResultSrcE), .Q(ResultSrcM)
    );
    pipeline_reg #(.WIDTH(1)) u_em_memwrite (
        .clk(clk), .EN(1'b1), .CLR(reset), .D(MemWriteE), .Q(MemWriteM)
    );

    // Memory/Writeback carries the selected result sources and destination.
    pipeline_reg #(.WIDTH(32)) u_mw_aluresult (
        .clk(clk), .EN(1'b1), .CLR(reset), .D(ALUResultM), .Q(ALUResultW)
    );
    pipeline_reg #(.WIDTH(32)) u_mw_readdata (
        .clk(clk), .EN(1'b1), .CLR(reset), .D(ReadDataM), .Q(ReadDataW)
    );
    pipeline_reg #(.WIDTH(32)) u_mw_pc_plus4 (
        .clk(clk), .EN(1'b1), .CLR(reset), .D(PCPlus4M), .Q(PCPlus4W)
    );
    pipeline_reg #(.WIDTH(5)) u_mw_rd (
        .clk(clk), .EN(1'b1), .CLR(reset), .D(RdM), .Q(RdW)
    );
    pipeline_reg #(.WIDTH(1)) u_mw_regwrite (
        .clk(clk), .EN(1'b1), .CLR(reset), .D(RegWriteM), .Q(RegWriteW)
    );
    pipeline_reg #(.WIDTH(2)) u_mw_resultsrc (
        .clk(clk), .EN(1'b1), .CLR(reset), .D(ResultSrcM), .Q(ResultSrcW)
    );
    mux3 u_result_mux (
        .A(ALUResultW), .B(ReadDataW), .C(PCPlus4W),
        .Sel(ResultSrcW), .Y(ResultW)
    );
endmodule
