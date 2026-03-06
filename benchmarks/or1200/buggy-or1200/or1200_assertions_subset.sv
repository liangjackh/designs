//////////////////////////////////////////////////////////////////////
// Subset of OR1200 Assertions for Paper Verification
// Selected 5 representative assertions covering different complexity levels
//////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps
`include "or1200_defines.v"

module or1200_assertions_subset (
    input wire clk,
    input wire rst,

    // Signals for p1: PC consistency check (SIMPLE)
    input wire [31:0] except_wb_pc,
    input wire [31:0] sprs_spr_dat_ppc,

    // Signals for p30: Register file write check (MEDIUM)
    input wire [31:0] ctrl_ex_insn,
    input wire rf_we,

    // Signals for p49: Specific instruction check (MEDIUM)
    input wire [31:0] id_insn,
    input wire id_freeze,

    // Signals for p51: Data path consistency (COMPLEX)
    input wire [31:0] operand_b,
    input wire [31:0] dcpu_dat_o,

    // Signals for p68: Memory consistency (COMPLEX)
    input wire [31:0] lsu_dcpu_dat_i,
    input wire [31:0] mem2reg_memdata
);

    //////////////////////////////////////////////////////////////////////
    // p1: PC Consistency Check (SIMPLE)
    // Category: Control Flow
    // Complexity: Low (2 signals, simple equality)
    // Description: Write-back PC should match previous PC unless in reset
    //////////////////////////////////////////////////////////////////////
    always @(posedge clk) begin
        p1: assert ((except_wb_pc == sprs_spr_dat_ppc) || (rst == 1));
    end

    //////////////////////////////////////////////////////////////////////
    // p30: Register File Write Check (MEDIUM)
    // Category: Instruction Decoding
    // Complexity: Medium (instruction decode + RF control)
    // Description: l.mfspr instruction should not write to register file
    // Instruction opcode: 47 (0x2F) = l.mfspr
    //////////////////////////////////////////////////////////////////////
    always @(posedge clk) begin
        p30: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 47)) || (rf_we == 0) || (rst == 1));
    end

    //////////////////////////////////////////////////////////////////////
    // p49: Specific Instruction Check (MEDIUM)
    // Category: Instruction Validation
    // Complexity: Medium (specific instruction pattern matching)
    // Description: Checks for specific instruction patterns in ID stage
    // 0x14410000 and 0x14610000 are specific l.mfspr variants
    //////////////////////////////////////////////////////////////////////
    always @(posedge clk) begin
        p49: assert ((id_insn == 32'h14410000) || (id_insn == 32'h14610000) ||
                     (id_insn != 32'h14410000) || (id_freeze == 1) || (rst == 1));
    end

    //////////////////////////////////////////////////////////////////////
    // p51: Data Path Consistency (COMPLEX)
    // Category: Data Path
    // Complexity: High (multi-stage data flow)
    // Description: Operand B should match data output to data cache
    //////////////////////////////////////////////////////////////////////
    always @(posedge clk) begin
        p51: assert ((operand_b == dcpu_dat_o) || (rst == 1));
    end

    //////////////////////////////////////////////////////////////////////
    // p68: Memory Consistency (COMPLEX)
    // Category: Memory System
    // Complexity: High (load/store data consistency)
    // Description: LSU input data should match memory-to-register data
    //////////////////////////////////////////////////////////////////////
    always @(posedge clk) begin
        p68: assert ((lsu_dcpu_dat_i == mem2reg_memdata) || (rst == 1));
    end

endmodule

//////////////////////////////////////////////////////////////////////
// Testing Instructions:
//
// 1. Create a filelist that uses this subset:
//    cp or1200.F or1200_subset.F
//    # Replace or1200_assertions.sv with or1200_assertions_subset.sv
//
// 2. Run with directed search:
//    python3 -m main 50 or1200_subset.F --sv --auto-plan \
//            --llm-provider deepseek --coi --strategy directed \
//            -t or1200_top
//
// 3. Compare with blind search:
//    python3 -m main 50 or1200_subset.F --sv --strategy blind \
//            -t or1200_top
//
// Expected Results for Paper:
// - p1 (SIMPLE): Should find violation quickly (< 1 min)
// - p30 (MEDIUM): Moderate time (1-3 min)
// - p49 (MEDIUM): Moderate time (1-3 min)
// - p51 (COMPLEX): Longer time (3-5 min)
// - p68 (COMPLEX): Longer time (3-5 min)
//
// Metrics to Report:
// - Time to find violation
// - Number of paths explored
// - Number of milestones (if using directed search)
// - Speedup vs blind search
// - COI reduction (% of signals pruned)
//////////////////////////////////////////////////////////////////////
