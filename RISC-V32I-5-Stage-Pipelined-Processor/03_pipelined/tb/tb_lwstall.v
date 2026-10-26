`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 26.10.2026
// Design Name: 
// Module Name: tb_lwstall
// Project Name: RV32I Five-Stage Pipeline
// Target Devices: 
// Tool Versions: 
// Description: Checks load-use stalls and the associated register and memory results.
// Ports: none
// 
// Dependencies: riscv_pipeline_top
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module tb_lwstall;
    reg clk, reset;
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

    // Hold reset through two rising edges, then run the directed load program.
    initial begin
        reset = 1'b1;
        repeat (2) @(posedge clk);
        #1 reset = 1'b0;
        repeat (60) @(posedge clk);
        #1;

        if (dut.dp.u_regfile.rf[0] === 32'd0)
            $display("PASS: x0 = 00000000");
        else
            $display("FAIL: x0 expected 00000000, got %08h", dut.dp.u_regfile.rf[0]);
        if (dut.dp.u_regfile.rf[1] === 32'd42)
            $display("PASS: x1 = 0000002A");
        else
            $display("FAIL: x1 expected 0000002A, got %08h", dut.dp.u_regfile.rf[1]);
        if (dut.dp.u_regfile.rf[2] === 32'd42)
            $display("PASS: x2 = 0000002A");
        else
            $display("FAIL: x2 expected 0000002A, got %08h", dut.dp.u_regfile.rf[2]);
        if (dut.dp.u_regfile.rf[3] === 32'd42)
            $display("PASS: x3 = 0000002A");
        else
            $display("FAIL: x3 expected 0000002A, got %08h", dut.dp.u_regfile.rf[3]);
        if (dut.dp.u_regfile.rf[4] === 32'd43)
            $display("PASS: x4 = 0000002B");
        else
            $display("FAIL: x4 expected 0000002B, got %08h", dut.dp.u_regfile.rf[4]);
        if (dut.dp.u_regfile.rf[5] === 32'd42)
            $display("PASS: x5 = 0000002A");
        else
            $display("FAIL: x5 expected 0000002A, got %08h", dut.dp.u_regfile.rf[5]);
        if (dut.dp.u_regfile.rf[6] === 32'd42)
            $display("PASS: x6 = 0000002A");
        else
            $display("FAIL: x6 expected 0000002A, got %08h", dut.dp.u_regfile.rf[6]);
        if (dut.dp.u_regfile.rf[7] === 32'd42)
            $display("PASS: x7 = 0000002A");
        else
            $display("FAIL: x7 expected 0000002A, got %08h", dut.dp.u_regfile.rf[7]);
        if (dut.dp.u_regfile.rf[8] === 32'd42)
            $display("PASS: x8 = 0000002A");
        else
            $display("FAIL: x8 expected 0000002A, got %08h", dut.dp.u_regfile.rf[8]);
        if (dut.dp.u_regfile.rf[9] === 32'd7)
            $display("PASS: x9 = 00000007");
        else
            $display("FAIL: x9 expected 00000007, got %08h", dut.dp.u_regfile.rf[9]);
        if (dut.dp.u_regfile.rf[10] === 32'd49)
            $display("PASS: x10 = 00000031");
        else
            $display("FAIL: x10 expected 00000031, got %08h", dut.dp.u_regfile.rf[10]);
        if (dut.dp.u_regfile.rf[11] === 32'd42)
            $display("PASS: x11 = 0000002A");
        else
            $display("FAIL: x11 expected 0000002A, got %08h", dut.dp.u_regfile.rf[11]);
        if (dut.dp.u_regfile.rf[12] === 32'd5)
            $display("PASS: x12 = 00000005");
        else
            $display("FAIL: x12 expected 00000005, got %08h", dut.dp.u_regfile.rf[12]);

        if (dut.u_data_mem.mem[0] === 32'd42)
            $display("PASS: memory[0] = 0000002A");
        else
            $display("FAIL: memory[0] expected 0000002A, got %08h",
                     dut.u_data_mem.mem[0]);
        if (dut.u_data_mem.mem[1] === 32'd42)
            $display("PASS: memory[1] = 0000002A");
        else
            $display("FAIL: memory[1] expected 0000002A, got %08h",
                     dut.u_data_mem.mem[1]);

        $finish;
    end
endmodule
