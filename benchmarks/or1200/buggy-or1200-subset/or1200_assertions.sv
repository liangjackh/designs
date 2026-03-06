//////////////////////////////////////////////////////////////////////
// OR1200 Security Assertions - SUBSET for Paper Verification
// 5 selected assertions from the full 71 assertions
// Selected: p1, p31, p49, p52, p69
// Covers: Control Flow, Register Write, Instruction Validation,
//         Data Path, Memory Consistency
//////////////////////////////////////////////////////////////////////

// synopsys translate_off
`include "../buggy-or1200/timescale.v"
// synopsys translate_on
`include "../buggy-or1200/or1200_defines.v"

module or1200_assertions (
    input wire clk,
    input wire rst,

    // From or1200_except
    input wire [31:0] except_wb_pc,
    input wire [31:0] except_epcr,
    input wire [31:0] except_eear,
    input wire [`OR1200_SR_WIDTH-1:0] except_esr,
    input wire [31:0] except_lsu_addr,
    input wire [31:0] except_spr_dat_npc,

    // From or1200_sprs
    input wire [31:0] sprs_spr_dat_ppc,
    input wire [31:0] sprs_spr_dat_npc,
    input wire [`OR1200_SR_WIDTH-1:0] sprs_sr,
    input wire [`OR1200_SR_WIDTH-1:0] sprs_to_sr,
    input wire [31:0] sprs_spr_dat_o,

    // From or1200_ctrl
    input wire [31:0] ctrl_ex_insn,
    input wire [31:0] ctrl_wb_insn,
    input wire [31:0] ctrl_ex_pc,

    // From or1200_rf
    input wire [4:0] rf_rf_addrw,
    input wire [4:0] rf_addrw,
    input wire [31:0] rf_rf_dataw,
    input wire rf_we,

    // From or1200_genpc
    input wire [31:0] genpc_pc,

    // From or1200_cpu (operand muxes)
    input wire [31:0] operand_a,
    input wire [31:0] operand_b,
    input wire [31:0] ex_simm,

    // From or1200_if
    input wire [31:0] if_insn,
    input wire [31:0] if_insn_saved,

    // From or1200_lsu
    input wire [31:0] lsu_dcpu_dat_i,
    input wire [31:0] mem2reg_regdata,
    input wire [31:0] mem2reg_memdata,
    input wire [31:0] reg2mem_memdata,
    input wire [31:0] reg2mem_regdata,

    // External interfaces
    input wire [31:0] icpu_dat_i,
    input wire [31:0] dcpu_adr_o,
    input wire [31:0] dcpu_dat_o,

    // ID stage
    input wire [31:0] id_insn,
    input wire id_freeze
);

    //==========================================================================
    // p1: Control Flow - PC Consistency (SIMPLE)
    // Category: CWE-1281 Control Flow
    // wb_pc should match spr_dat_ppc unless in reset
    //==========================================================================
    //always @(posedge clk) begin
    //    p1: assert ((except_wb_pc == sprs_spr_dat_ppc) || (rst == 1));
    //end

    //==========================================================================
    // p31: Register File Write Check (MEDIUM)
    // Category: CWE-1262 Update Registers
    // l.mfspr (opcode 47) should not write to register file
    //==========================================================================
    //always @(posedge clk) begin
    //    p31: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 47)) || (rf_we == 0) || (rst == 1));
    //end

    //==========================================================================
    // p49: Instruction Validation (MEDIUM)
    // Category: CWE-1281 Instruction Executed
    // Opcode 0x1c should not be executed
    //==========================================================================
    //always @(posedge clk) begin
    //    p49: assert ((((ctrl_ex_insn & 32'hFC000000) >> 26) != 32'h1c) || (rst == 1));
    //end

    //==========================================================================
    // p52: Data Path Consistency (COMPLEX)
    // Category: CWE-1202 Memory Access
    // operand_b should match dcpu_dat_o
    //==========================================================================
    always @(posedge clk) begin
        p52: assert ((operand_b == dcpu_dat_o) || (rst == 1));
    end

    //==========================================================================
    // p69: Memory Consistency (COMPLEX)
    // Category: CWE-1202 Memory Access
    // LSU data input should match memory-to-register data
    //==========================================================================
    //always @(posedge clk) begin
    //    p69: assert ((lsu_dcpu_dat_i == mem2reg_memdata) || (rst == 1));
    //end

endmodule
