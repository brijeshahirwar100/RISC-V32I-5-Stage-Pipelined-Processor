`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Brijesh Ahirwar
// 
// Create Date: 26.10.2026
// Design Name: 
// Module Name: tb_pipeline
// Project Name: RV32I Five-Stage Pipeline
// Target Devices: 
// Tool Versions: 
// Description: Checks the pipeline register and data-memory results.
// Ports: none
// 
// Dependencies: riscv_pipeline_top
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module tb_pipeline;
    reg clk, reset;
    reg [31:0] expected [0:14];
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

    // Hold reset through two rising edges, then allow the padded program to finish.
    initial begin
        expected[0]  = 32'h00000000;
        expected[1]  = 32'h00000005;
        expected[2]  = 32'hFFFFFFFD;
        expected[3]  = 32'h00000002;
        expected[4]  = 32'h00000008;
        expected[5]  = 32'h00000005;
        expected[6]  = 32'hFFFFFFFD;
        expected[7]  = 32'h00000001;
        expected[8]  = 32'h00000002;
        expected[9]  = 32'h00000009;
        expected[10] = 32'hFFFFFFFF;
        // Padding moves jal x11 to 0xD4, so its link value is 0xD8.
        expected[11] = 32'h000000D8;
        expected[12] = 32'h0000000C;
        expected[13] = 32'h00000009;
        expected[14] = 32'h00000001;

        reset = 1'b1;
        repeat (2) @(posedge clk);
        #1 reset = 1'b0;
        repeat (120) @(posedge clk);
        #1;

        for (i = 0; i < 15; i = i + 1) begin
            if (dut.dp.u_regfile.rf[i] === expected[i])
                $display("PASS: x%0d = %08h", i, dut.dp.u_regfile.rf[i]);
            else
                $display("FAIL: x%0d expected %08h, got %08h",
                         i, expected[i], dut.dp.u_regfile.rf[i]);
        end

        if (dut.u_data_mem.mem[0] === 32'h00000002)
            $display("PASS: memory[0] = %08h", dut.u_data_mem.mem[0]);
        else
            $display("FAIL: memory[0] expected 00000002, got %08h",
                     dut.u_data_mem.mem[0]);

        if (dut.u_data_mem.mem[1] === 32'h00000009)
            $display("PASS: memory[1] = %08h", dut.u_data_mem.mem[1]);
        else
            $display("FAIL: memory[1] expected 00000009, got %08h",
                     dut.u_data_mem.mem[1]);

        $finish;
    end
endmodule
