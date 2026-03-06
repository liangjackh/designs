// Formal verification assertions module for OR1200
// This module is instantiated in or1200_top as or1200_assertions

module or1200_assertions(
    input clk,
    input rst,

    // From or1200_except
    input [31:0] except_wb_pc,
    input [31:0] except_epcr,
    input [31:0] except_eear,
    input [16:0] except_esr,
    input [31:0] except_lsu_addr,
    input [31:0] except_spr_dat_npc,

    // From or1200_sprs
    input [31:0] sprs_spr_dat_ppc,
    input [31:0] sprs_spr_dat_npc,
    input [16:0] sprs_sr,
    input [16:0] sprs_to_sr,
    input [31:0] sprs_spr_dat_o,

    // From or1200_ctrl
    input [31:0] ctrl_ex_insn,
    input [31:0] ctrl_wb_insn,
    input [31:0] ctrl_ex_pc,

    // From or1200_rf
    input [4:0]  rf_rf_addrw,
    input [4:0]  rf_addrw,
    input [31:0] rf_rf_dataw,
    input        rf_we,

    // From or1200_genpc
    input [31:0] genpc_pc,

    // From or1200_cpu (operand muxes)
    input [31:0] operand_a,
    input [31:0] operand_b,
    input [31:0] ex_simm,

    // From or1200_if
    input [31:0] if_insn,
    input [31:0] if_insn_saved,

    // From or1200_lsu
    input [31:0] lsu_dcpu_dat_i,
    input [31:0] mem2reg_regdata,
    input [31:0] mem2reg_memdata,
    input [31:0] reg2mem_memdata,
    input [31:0] reg2mem_regdata,

    // External interfaces
    input [31:0] icpu_dat_i,
    input [31:0] dcpu_adr_o,
    input [31:0] dcpu_dat_o,

    // ID stage
    input [31:0] id_insn,
    input        id_freeze
);

// Previous-cycle registers
reg        prev_sr0;
reg [31:0] prev_epcr;
reg [31:0] prev_eear;
reg [16:0] prev_esr;
reg [31:0] prev_if_insn;
reg        prev_id_freeze;
reg [31:0] prev_ex_insn;

always @(posedge clk) begin
    prev_sr0      <= sprs_sr[0];
    prev_epcr     <= except_epcr;
    prev_eear     <= except_eear;
    prev_esr      <= except_esr;
    prev_if_insn  <= if_insn;
    prev_id_freeze <= id_freeze;
    prev_ex_insn  <= ctrl_ex_insn;
end

`ifdef FORMAL
// Reset constraint: force rst high for first cycle, then low thereafter
// so the solver cannot trivially satisfy all assertions by keeping rst=1.
reg init_done = 0;
always @(posedge clk) begin
    init_done <= 1;
    if (!init_done)
        assume(rst == 1);
    else
        assume(rst == 0);
end

always @(posedge clk) begin
    // Property 1: wb_pc matches spr_dat_ppc
    assert((except_wb_pc == sprs_spr_dat_ppc) || (rst == 1));

    // Property 2: ALU insn (class 1) - ex_pc matches spr_dat_npc
    assert((~(((ctrl_ex_insn & 32'hC0000000) >> 30 == 1))) || (ctrl_ex_pc == sprs_spr_dat_npc) || (rst == 1));

    // Property 3: ALU insn (class 2) - ex_pc matches spr_dat_npc
    assert((~(((ctrl_ex_insn & 32'hC0000000) >> 30 == 2))) || (ctrl_ex_pc == sprs_spr_dat_npc) || (rst == 1));

    // Property 4: ALU insn (class 3) - ex_pc matches spr_dat_npc
    assert((~(((ctrl_ex_insn & 32'hC0000000) >> 30 == 3))) || (ctrl_ex_pc == sprs_spr_dat_npc) || (rst == 1));

    // Property 5: l.sfgtu sets SR[F] when operand_a > operand_b
    assert(~(((ctrl_ex_insn & 32'hFFE00000) >> 21 == 1826) && (operand_a > operand_b)) || (sprs_to_sr[9] == 1) || (rst == 1));

    // Property 6: l.sfgeu sets SR[F] when operand_a <= operand_b
    assert(~(((ctrl_ex_insn & 32'hFFE00000) >> 21 == 1829) && (operand_a <= operand_b)) || (sprs_to_sr[9] == 1) || (rst == 1));

    // Property 7: l.jal writes to r9
    assert((~((ctrl_ex_insn & 32'hFC000000)>>26==1)) || (rf_rf_addrw==9) || (rst == 1));

    // Property 8: class-2 insn does not write to r9
    assert((~(((ctrl_ex_insn & 32'hC0000000) >> 30 == 2))) || (rf_rf_addrw != 9) || (rst == 1));

    // Property 9: class-1 insn does not change SR[0]
    assert((~(((ctrl_ex_insn & 32'hC0000000) >> 30 == 1))) || (sprs_sr[0] == prev_sr0) || (rst == 1));

    // Property 10: class-2 insn does not change SR[0]
    assert((~(((ctrl_ex_insn & 32'hC0000000) >> 30 == 2))) || (sprs_sr[0] == prev_sr0) || (rst == 1));

    // Property 11: class-3 non-SPR insn does not change SR[0]
    assert((~( ((ctrl_ex_insn & 32'hC0000000) >> 30 == 3) & (ctrl_ex_insn & 32'h3C000000 != 0) )) || (sprs_sr[0] == prev_sr0) || (rst == 1));

    // Property 12: class-1 insn does not change EPCR
    assert((~(((ctrl_ex_insn & 32'hC0000000) >> 30 == 1))) || (except_epcr == prev_epcr) || (rst == 1));

    // Property 13: class-2 insn does not change EPCR
    assert((~(((ctrl_ex_insn & 32'hC0000000) >> 30 == 2))) || (except_epcr == prev_epcr) || (rst == 1));

    // Property 14: class-3 insn does not change EPCR
    assert((~(((ctrl_ex_insn & 32'hC0000000) >> 30 == 3))) || (except_epcr == prev_epcr) || (rst == 1));

    // Property 15: class-1 insn does not change EEAR
    assert((~(((ctrl_ex_insn & 32'hC0000000) >> 30 == 1))) || (except_eear == prev_eear) || (rst == 1));

    // Property 16: class-2 insn does not change EEAR
    assert((~(((ctrl_ex_insn & 32'hC0000000) >> 30 == 2))) || (except_eear == prev_eear) || (rst == 1));

    // Property 17: class-3 insn does not change EEAR
    assert((~(((ctrl_ex_insn & 32'hC0000000) >> 30 == 3))) || (except_eear == prev_eear) || (rst == 1));

    // Property 18: class-1 insn does not change ESR
    assert((~(((ctrl_ex_insn & 32'hC0000000) >> 30 == 1))) || (except_esr == prev_esr) || (rst == 1));

    // Property 19: class-2 insn does not change ESR
    assert((~(((ctrl_ex_insn & 32'hC0000000) >> 30 == 2))) || (except_esr == prev_esr) || (rst == 1));

    // Property 20: class-3 non-SPR insn does not change ESR
    assert((~( ((ctrl_ex_insn & 32'hC0000000) >> 30 == 3) & (ctrl_ex_insn & 32'h3C000000 != 0) )) || (except_esr == prev_esr) || (rst == 1));

    // Property 21: l.rfe does not change EEAR
    assert((~(((ctrl_ex_insn & 32'hFC000000) >> 26 == 9))) || (except_eear == prev_eear) || (rst == 1));

    // Property 22: l.rfe does not change EPCR
    assert((~(((ctrl_ex_insn & 32'hFC000000) >> 26 == 9))) || (except_epcr == prev_epcr) || (rst == 1));

    // Property 23: l.rfe does not change ESR
    assert((~(((ctrl_ex_insn & 32'hFC000000) >> 26 == 9))) || (except_esr == prev_esr) || (rst == 1));

    // Property 24: l.rfe restores PC from EPCR
    assert((~((ctrl_ex_insn & 32'hFC000000) >> 26 == 9)) || (genpc_pc == except_epcr) || (rst == 1));

    // Property 25: l.rfe restores SR from ESR
    assert((~((ctrl_ex_insn & 32'hFC000000) >> 26 == 9)) || (sprs_to_sr == except_esr) || (rst == 1));

    // Property 26: load exception records LSU address in EEAR
    assert((~((prev_ex_insn & 32'hFFFF0000) >> 16 == 8192)) || (~((ctrl_ex_insn & 32'hFFFF0000) >> 16 != 8192)) || (except_lsu_addr == except_eear) || (rst == 1));

    // Property 27: load exception records NPC in EPCR
    assert((~((prev_ex_insn & 32'hFFFF0000) >> 16 == 8192)) || (~((ctrl_ex_insn & 32'hFFFF0000) >> 16 != 8192)) || (except_spr_dat_npc == except_epcr) || (rst == 1));

    // Property 28: WB-stage load exception records LSU address in EEAR
    assert((~((ctrl_wb_insn & 32'hFFFF0000) >> 16 == 8192)) || (except_lsu_addr == except_eear) || (rst == 1));

    // Property 29: WB-stage load exception records NPC in EPCR
    assert((~((ctrl_wb_insn & 32'hFFFF0000) >> 16 == 8192)) || (except_spr_dat_npc == except_epcr) || (rst == 1));

    // Property 30: load insn writes correct register address
    assert((~((ctrl_ex_insn & 32'hFFFF0000) >> 16 == 8192)) || (rf_rf_addrw == ((ctrl_ex_insn & 32'h03E00000) >> 21)) || (rst == 1));

    // Property 31: l.sw does not write to register file
    assert((~(((ctrl_ex_insn & 32'hFC000000) >> 26 == 47))) || (rf_we == 0) || (rst == 1));

    // Property 32: l.sd does not write to register file
    assert((~(((ctrl_ex_insn & 32'hFC000000) >> 26 == 57))) || (rf_we == 0) || (rst == 1));

    // Property 33: l.sb does not write to register file
    assert((~(((ctrl_ex_insn & 32'hFC000000) >> 26 == 51))) || (rf_we == 0) || (rst == 1));

    // Property 34: opcode 52 does not write to register file
    assert((~(((ctrl_ex_insn & 32'hFC000000) >> 26 == 52))) || (rf_we == 0) || (rst == 1));

    // Property 35: opcode 53 does not write to register file
    assert((~(((ctrl_ex_insn & 32'hFC000000) >> 26 == 53))) || (rf_we == 0) || (rst == 1));

    // Property 36: opcode 54 does not write to register file
    assert((~(((ctrl_ex_insn & 32'hFC000000) >> 26 == 54))) || (rf_we == 0) || (rst == 1));

    // Property 37: opcode 55 does not write to register file
    assert((~(((ctrl_ex_insn & 32'hFC000000) >> 26 == 55))) || (rf_we == 0) || (rst == 1));

    // Property 38: l.mtspr does not write to register file
    assert((~(((ctrl_ex_insn & 32'hFC000000) >> 26 == 48))) || (rf_we == 0) || (rst == 1));

    // Property 39: opcode 0x15 does not write to register file
    assert((~(((ctrl_ex_insn & 32'hFF000000) >> 24 == 21))) || (rf_we == 0) || (rst == 1));

    // Property 40: l.rfe does not write to register file
    assert((~(((ctrl_ex_insn & 32'hFC000000) >> 26 == 9))) || (rf_we == 0) || (rst == 1));

    // Property 41: l.bf does not write to register file
    assert((~(((ctrl_ex_insn & 32'hFC000000) >> 26 == 17))) || (rf_we == 0) || (rst == 1));

    // Property 42: l.j does not write to register file
    assert((~(((ctrl_ex_insn & 32'hFC000000) >> 26 == 0))) || (rf_we == 0) || (rst == 1));

    // Property 43: l.bf (opcode 4) does not write to register file
    assert((~(((ctrl_ex_insn & 32'hFC000000) >> 26 == 4))) || (rf_we == 0) || (rst == 1));

    // Property 44: l.bnf does not write to register file
    assert((~(((ctrl_ex_insn & 32'hFC000000) >> 26 == 3))) || (rf_we == 0) || (rst == 1));

    // Property 45: l.jr does not write to register file
    assert((~(((ctrl_ex_insn & 32'hFC000000) >> 26 == 8))) || (rf_we == 0) || (rst == 1));

    // Property 46: l.mfspr reads correct SPR data
    assert((~((ctrl_ex_insn & 32'hFC000000) >> 26 == 48)) || (sprs_spr_dat_o == operand_b));

    // Property 47: class-2 insn writes correct register address
    assert((~(((ctrl_ex_insn & 32'hC0000000) >> 30 == 2))) || ((ctrl_ex_insn & 32'h03e00000) >> 21 == rf_addrw) || (rst == 1));

    // Property 48: class-3 insn writes correct register address
    assert((~(((ctrl_ex_insn & 32'hC0000000) >> 30 == 3))) || ((ctrl_ex_insn & 32'h03e00000) >> 21 == rf_addrw) || (rst == 1));

    // Property 49: opcode 0x1c is not executed
    assert(((ctrl_ex_insn & 32'hFC000000) >> 26 != 32'h1c) || (rst == 1));

    // Property 50: id_insn is either NOP, previous if_insn, or id_freeze
    assert((id_insn == 32'h14410000) || (id_insn == 32'h14610000) || (id_insn == prev_if_insn) || (prev_id_freeze) || (rst == 1));

    // Property 51: if_insn is valid
    assert((if_insn == 32'h14610000) || (if_insn == 32'h14410000) || (if_insn == icpu_dat_i) || (if_insn == 0) || (rst == 1) || (if_insn == if_insn_saved));

    // Property 52: operand_b matches dcpu_dat_o
    assert((operand_b == dcpu_dat_o) || (rst == 1));

    // Property 53: l.lws result comes from data bus
    assert((~((ctrl_ex_insn & 32'hFC000000) >> 26 == 32)) || (rf_rf_dataw == dcpu_dat_o) || (rst == 1));

    // Property 54: l.lbz result comes from data bus
    assert((~((ctrl_ex_insn & 32'hFC000000) >> 26 == 33)) || (rf_rf_dataw == dcpu_dat_o) || (rst == 1));

    // Property 55: l.lbs result comes from data bus
    assert((~((ctrl_ex_insn & 32'hFC000000) >> 26 == 34)) || (rf_rf_dataw == dcpu_dat_o) || (rst == 1));

    // Property 56: l.lhz result comes from data bus
    assert((~((ctrl_ex_insn & 32'hFC000000) >> 26 == 35)) || (rf_rf_dataw == dcpu_dat_o) || (rst == 1));

    // Property 57: l.lhs result comes from data bus
    assert((~((ctrl_ex_insn & 32'hFC000000) >> 26 == 36)) || (rf_rf_dataw == dcpu_dat_o) || (rst == 1));

    // Property 58: opcode 37 result comes from data bus
    assert((~((ctrl_ex_insn & 32'hFC000000) >> 26 == 37)) || (rf_rf_dataw == dcpu_dat_o) || (rst == 1));

    // Property 59: opcode 38 result comes from data bus
    assert((~((ctrl_ex_insn & 32'hFC000000) >> 26 == 38)) || (rf_rf_dataw == dcpu_dat_o) || (rst == 1));

    // Property 60: l.lws address is operand_a + ex_simm
    assert((~((ctrl_ex_insn & 32'hFC000000) >> 26 == 32)) || (dcpu_adr_o == operand_a + ex_simm) || (rst == 1));

    // Property 61: l.lbz address is operand_a + ex_simm
    assert((~((ctrl_ex_insn & 32'hFC000000) >> 26 == 33)) || (dcpu_adr_o == operand_a + ex_simm) || (rst == 1));

    // Property 62: l.lbs address is operand_a + ex_simm
    assert((~((ctrl_ex_insn & 32'hFC000000) >> 26 == 34)) || (dcpu_adr_o == operand_a + ex_simm) || (rst == 1));

    // Property 63: l.lhz address is operand_a + ex_simm
    assert((~((ctrl_ex_insn & 32'hFC000000) >> 26 == 35)) || (dcpu_adr_o == operand_a + ex_simm) || (rst == 1));

    // Property 64: l.lhs address is operand_a + ex_simm
    assert((~((ctrl_ex_insn & 32'hFC000000) >> 26 == 36)) || (dcpu_adr_o == operand_a + ex_simm) || (rst == 1));

    // Property 65: opcode 37 address is operand_a + ex_simm
    assert((~((ctrl_ex_insn & 32'hFC000000) >> 26 == 37)) || (dcpu_adr_o == operand_a + ex_simm) || (rst == 1));

    // Property 66: opcode 38 address is operand_a + ex_simm
    assert((~((ctrl_ex_insn & 32'hFC000000) >> 26 == 38)) || (dcpu_adr_o == operand_a + ex_simm) || (rst == 1));

    // Property 67: opcode 37 (lhz?) upper 16 bits of regdata are zero
    assert((~((ctrl_ex_insn & 32'hFC000000) >> 26 == 37)) || ((mem2reg_regdata & 32'hFFFF0000) == 0) || (rst == 1));

    // Property 68: l.sh lower 16 bits of memdata match regdata
    assert((~((ctrl_ex_insn & 32'hFC000000) >> 26 == 53)) || ((reg2mem_memdata & 16'hFFFF) == (reg2mem_regdata & 16'hFFFF)) || (rst == 1));

    // Property 69: lsu dcpu_dat_i matches mem2reg memdata
    assert((lsu_dcpu_dat_i == mem2reg_memdata) || (rst == 1));

    // Property 70: writing to r0 always writes 0
    assert((~((rf_we == 1) && (rf_rf_addrw == 0))) || (rf_rf_dataw == 0) || (rst == 1));

    // Property 71: l.ror result is correct (rotate right)
    assert((~((ctrl_ex_insn & 32'hFC0003CF) == 32'hE00000C8)) || (((operand_a << (6'd32 - {1'b0, operand_b[4:0]})) | (operand_a >> operand_b[4:0])) == rf_rf_dataw) || (rf_rf_dataw == 0) || (rst == 1));

end
`endif

endmodule
