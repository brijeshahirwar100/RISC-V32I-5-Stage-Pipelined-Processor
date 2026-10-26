`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 26.10.2026
// Design Name: 
// Module Name: tb_flush
// Project Name: RV32I Five-Stage Pipeline
// Target Devices: 
// Tool Versions: 
// Description: Checks taken-branch and JAL flushes and a not-taken branch.
// Ports: none
// 
// Dependencies: riscv_pipeline_top
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module tb_flush;
    reg clk, reset;
    reg [31:0] expected [0:25];
    integer i;
    wire [31:0] PCF, InstrD, ALUResultM, ReadDataM;
    wire [31:0] ReadDataW, WriteDataM, ResultW;
    wire RegWriteW, MemWriteM, PCSrcE;

    riscv_pipeline_top dut (
        .clk(clk), .reset(reset), .PCF(PCF), .InstrD(InstrD),
        .ALUResultM(ALUResultM), .ReadDataM(ReadDataM),
        .ReadDataW(ReadDataW), .WriteDataM(WriteDataM), .ResultW(ResultW),
        .RegWriteW(RegWriteW), .MemWriteM(MemWriteM), .PCSrcE(PCSrcE)
    );

    // A 10 ns clock gives the register file a falling-edge write each cycle.
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // Hold reset through two rising edges, then run the no-padding program.
    initial begin
        for (i = 0; i < 26; i = i + 1)
            expected[i] = 32'd0;
        expected[1]  = 32'd42;
        expected[2]  = 32'd42;
        expected[4]  = 32'd1;
        expected[8]  = 32'd42;
        expected[11] = 32'h00000034;
        expected[21] = 32'd99;
        expected[22] = 32'd22;

        reset = 1'b1;
        repeat (2) @(posedge clk);
        #1 reset = 1'b0;
        repeat (60) @(posedge clk);
        #1;

        for (i = 0; i < 26; i = i + 1) begin
            if (dut.dp.u_regfile.rf[i] === expected[i])
                $display("PASS: x%0d = %08h", i, dut.dp.u_regfile.rf[i]);
            else
                $display("FAIL: x%0d expected %08h, got %08h",
                         i, expected[i], dut.dp.u_regfile.rf[i]);
        end

        if (dut.u_data_mem.mem[0] === 32'd42)
            $display("PASS: memory[0] = 0000002A");
        else
            $display("FAIL: memory[0] expected 0000002A, got %08h",
                     dut.u_data_mem.mem[0]);
        if (dut.u_data_mem.mem[1] === 32'd99)
            $display("PASS: memory[1] = 00000063");
        else
            $display("FAIL: memory[1] expected 00000063, got %08h",
                     dut.u_data_mem.mem[1]);
        if (dut.u_data_mem.mem[2] === 32'd0)
            $display("PASS: memory[2] = 00000000");
        else
            $display("FAIL: memory[2] expected 00000000, got %08h",
                     dut.u_data_mem.mem[2]);
        if (dut.u_data_mem.mem[3] === 32'd0)
            $display("PASS: memory[3] = 00000000");
        else
            $display("FAIL: memory[3] expected 00000000, got %08h",
                     dut.u_data_mem.mem[3]);
        if (dut.u_data_mem.mem[4] === 32'd0)
            $display("PASS: memory[4] = 00000000");
        else
            $display("FAIL: memory[4] expected 00000000, got %08h",
                     dut.u_data_mem.mem[4]);

        $finish;
    end
endmodule
