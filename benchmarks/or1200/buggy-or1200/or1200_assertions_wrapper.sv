// Wrapper to instantiate or1200_assertions as a top-level module
// This allows the symbolic execution engine to find the assertions

`timescale 1ns/1ps
`include "or1200_defines.v"

module or1200_assertions_wrapper;
    // Clock and reset
    logic clk;
    logic rst;

    // Declare all signals as logic (undriven, symbolic)
    logic [31:0] except_wb_pc;
    logic [31:0] except_epcr;
    logic [31:0] except_eear;
    logic [`OR1200_SR_WIDTH-1:0] except_esr;
    logic [31:0] except_lsu_addr;
    logic [31:0] except_spr_dat_npc;

    logic [31:0] sprs_spr_dat_ppc;
    logic [31:0] sprs_spr_dat_npc;
    logic [`OR1200_SR_WIDTH-1:0] sprs_sr;
    logic [`OR1200_SR_WIDTH-1:0] sprs_to_sr;
    logic [31:0] sprs_spr_dat_o;

    logic [31:0] ctrl_ex_insn;
    logic [31:0] ctrl_wb_insn;
    logic [31:0] ctrl_ex_pc;

    logic [4:0] rf_rf_addrw;
    logic [4:0] rf_addrw;
    logic [31:0] rf_rf_dataw;
    logic rf_we;

    logic [31:0] genpc_pc;

    logic [31:0] operand_a;
    logic [31:0] operand_b;
    logic [31:0] ex_simm;

    logic [31:0] if_insn;
    logic [31:0] if_insn_saved;

    logic [31:0] lsu_dcpu_dat_i;
    logic [31:0] mem2reg_regdata;
    logic [31:0] mem2reg_memdata;
    logic [31:0] reg2mem_memdata;
    logic [31:0] reg2mem_regdata;

    logic [31:0] icpu_dat_i;
    logic [31:0] dcpu_adr_o;
    logic [31:0] dcpu_dat_o;

    logic [31:0] id_insn;
    logic id_freeze;

    // Instantiate the assertions module
    or1200_assertions assertions_inst (
        .clk(clk),
        .rst(rst),
        .except_wb_pc(except_wb_pc),
        .except_epcr(except_epcr),
        .except_eear(except_eear),
        .except_esr(except_esr),
        .except_lsu_addr(except_lsu_addr),
        .except_spr_dat_npc(except_spr_dat_npc),
        .sprs_spr_dat_ppc(sprs_spr_dat_ppc),
        .sprs_spr_dat_npc(sprs_spr_dat_npc),
        .sprs_sr(sprs_sr),
        .sprs_to_sr(sprs_to_sr),
        .sprs_spr_dat_o(sprs_spr_dat_o),
        .ctrl_ex_insn(ctrl_ex_insn),
        .ctrl_wb_insn(ctrl_wb_insn),
        .ctrl_ex_pc(ctrl_ex_pc),
        .rf_rf_addrw(rf_rf_addrw),
        .rf_addrw(rf_addrw),
        .rf_rf_dataw(rf_rf_dataw),
        .rf_we(rf_we),
        .genpc_pc(genpc_pc),
        .operand_a(operand_a),
        .operand_b(operand_b),
        .ex_simm(ex_simm),
        .if_insn(if_insn),
        .if_insn_saved(if_insn_saved),
        .lsu_dcpu_dat_i(lsu_dcpu_dat_i),
        .mem2reg_regdata(mem2reg_regdata),
        .mem2reg_memdata(mem2reg_memdata),
        .reg2mem_memdata(reg2mem_memdata),
        .reg2mem_regdata(reg2mem_regdata),
        .icpu_dat_i(icpu_dat_i),
        .dcpu_adr_o(dcpu_adr_o),
        .dcpu_dat_o(dcpu_dat_o),
        .id_insn(id_insn),
        .id_freeze(id_freeze)
    );

endmodule
