`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 26.10.2026
// Design Name: 
// Module Name: tb_forwarding
// Project Name: RV32I Five-Stage Pipeline
// Target Devices: 
// Tool Versions: 
// Description: Checks Execute forwarding with the directed forwarding program.
// Ports: none
// 
// Dependencies: riscv_pipeline_top
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module tb_forwarding;
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

    // Hold reset through two rising edges before checking forwarded results.
    initial begin
        reset = 1'b1;
        repeat (2) @(posedge clk);
        #1 reset = 1'b0;
        repeat (40) @(posedge clk);
        #1;

        if (dut.dp.u_regfile.rf[0] === 32'd0)
            $display("PASS: x0 = 00000000");
        else
            $display("FAIL: x0 expected 00000000, got %08h", dut.dp.u_regfile.rf[0]);
        if (dut.dp.u_regfile.rf[1] === 32'd3)
            $display("PASS: x1 = 00000003");
        else
            $display("FAIL: x1 expected 00000003, got %08h", dut.dp.u_regfile.rf[1]);
        if (dut.dp.u_regfile.rf[2] === 32'd6)
            $display("PASS: x2 = 00000006");
        else
            $display("FAIL: x2 expected 00000006, got %08h", dut.dp.u_regfile.rf[2]);
        if (dut.dp.u_regfile.rf[3] === 32'd9)
            $display("PASS: x3 = 00000009");
        else
            $display("FAIL: x3 expected 00000009, got %08h", dut.dp.u_regfile.rf[3]);
        if (dut.dp.u_regfile.rf[4] === 32'd9)
            $display("PASS: x4 = 00000009");
        else
            $display("FAIL: x4 expected 00000009, got %08h", dut.dp.u_regfile.rf[4]);
        if (dut.dp.u_regfile.rf[5] === 32'd11)
            $display("PASS: x5 = 0000000B");
        else
            $display("FAIL: x5 expected 0000000B, got %08h", dut.dp.u_regfile.rf[5]);
        if (dut.dp.u_regfile.rf[6] === 32'd11)
            $display("PASS: x6 = 0000000B");
        else
            $display("FAIL: x6 expected 0000000B, got %08h", dut.dp.u_regfile.rf[6]);

        $finish;
    end
endmodule
