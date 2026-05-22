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

    // Registers to track previous-cycle values for temporal assertions
    reg        prev_sr0;
    reg [31:0] prev_epcr;
    reg [31:0] prev_eear;
    reg [`OR1200_SR_WIDTH-1:0] prev_esr;
    reg [31:0] prev_ex_insn;
    reg [31:0] prev_if_insn;
    reg        prev_id_freeze;

    always @(posedge clk) begin
        prev_sr0       <= sprs_sr[0];
        prev_epcr      <= except_epcr;
        prev_eear      <= except_eear;
        prev_esr       <= except_esr;
        prev_ex_insn   <= ctrl_ex_insn;
        prev_if_insn   <= if_insn;
        prev_id_freeze <= id_freeze;
    end

    // p1: wb_pc should match spr_dat_ppc unless in reset
    always @(posedge clk) begin
        p1: assert ((except_wb_pc == sprs_spr_dat_ppc) || (rst == 1));
    end

    // p2: type-1 insn => ex_pc matches spr_dat_npc
    always @(posedge clk) begin
        p2: assert ((~(((ctrl_ex_insn & 32'hC0000000) >> 30) == 1)) || (ctrl_ex_pc == sprs_spr_dat_npc) || (rst == 1));
    end

    // p3: type-2 insn => ex_pc matches spr_dat_npc
    always @(posedge clk) begin
        p3: assert ((~(((ctrl_ex_insn & 32'hC0000000) >> 30) == 2)) || (ctrl_ex_pc == sprs_spr_dat_npc) || (rst == 1));
    end

    // p4: type-3 insn => ex_pc matches spr_dat_npc
    always @(posedge clk) begin
        p4: assert ((~(((ctrl_ex_insn & 32'hC0000000) >> 30) == 3)) || (ctrl_ex_pc == sprs_spr_dat_npc) || (rst == 1));
    end

    // p5: insn 1826 with operand_a > operand_b => to_sr[9] set
    always @(posedge clk) begin
        p5: assert ((~(((ctrl_ex_insn & 32'hFFE00000) >> 21) == 1826) || ~(operand_a > operand_b)) || (sprs_to_sr[9] == 1) || (rst == 1));
    end

    // p6: insn 1829 with operand_a <= operand_b => to_sr[9] set
    always @(posedge clk) begin
        p6: assert ((~(((ctrl_ex_insn & 32'hFFE00000) >> 21) == 1829) || ~(operand_a <= operand_b)) || (sprs_to_sr[9] == 1) || (rst == 1));
    end

    // p7: opcode 1 => rf_addrw == 9
    always @(posedge clk) begin
        p7: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 1)) || (rf_rf_addrw == 9) || (rst == 1));
    end

    // p8: type-2 insn => rf_addrw != 9
    always @(posedge clk) begin
        p8: assert ((~(((ctrl_ex_insn & 32'hC0000000) >> 30) == 2)) || (rf_rf_addrw != 9) || (rst == 1));
    end

    // p9: type-1 insn => sr[0] unchanged
    always @(posedge clk) begin
        p9: assert ((~(((ctrl_ex_insn & 32'hC0000000) >> 30) == 1)) || (sprs_sr[0] == prev_sr0) || (rst == 1));
    end

    // p10: type-2 insn => sr[0] unchanged
    always @(posedge clk) begin
        p10: assert ((~(((ctrl_ex_insn & 32'hC0000000) >> 30) == 2)) || (sprs_sr[0] == prev_sr0) || (rst == 1));
    end

    // p11: type-3 insn with non-zero subfield => sr[0] unchanged
    always @(posedge clk) begin
        p11: assert ((~(((ctrl_ex_insn & 32'hC0000000) >> 30) == 3) || ~((ctrl_ex_insn & 32'h3C000000) != 0)) || (sprs_sr[0] == prev_sr0) || (rst == 1));
    end

    // p12: type-1 insn => epcr unchanged
    always @(posedge clk) begin
        p12: assert ((~(((ctrl_ex_insn & 32'hC0000000) >> 30) == 1)) || (except_epcr == prev_epcr) || (rst == 1));
    end

    // p13: type-2 insn => epcr unchanged
    always @(posedge clk) begin
        p13: assert ((~(((ctrl_ex_insn & 32'hC0000000) >> 30) == 2)) || (except_epcr == prev_epcr) || (rst == 1));
    end

    // p14: type-3 insn => epcr unchanged
    always @(posedge clk) begin
        p14: assert ((~(((ctrl_ex_insn & 32'hC0000000) >> 30) == 3)) || (except_epcr == prev_epcr) || (rst == 1));
    end

    // p15: type-1 insn => eear unchanged
    always @(posedge clk) begin
        p15: assert ((~(((ctrl_ex_insn & 32'hC0000000) >> 30) == 1)) || (except_eear == prev_eear) || (rst == 1));
    end

    // p16: type-2 insn => eear unchanged
    always @(posedge clk) begin
        p16: assert ((~(((ctrl_ex_insn & 32'hC0000000) >> 30) == 2)) || (except_eear == prev_eear) || (rst == 1));
    end

    // p17: type-3 insn => eear unchanged
    always @(posedge clk) begin
        p17: assert ((~(((ctrl_ex_insn & 32'hC0000000) >> 30) == 3)) || (except_eear == prev_eear) || (rst == 1));
    end

    // p18: type-1 insn => esr unchanged
    always @(posedge clk) begin
        p18: assert ((~(((ctrl_ex_insn & 32'hC0000000) >> 30) == 1)) || (except_esr == prev_esr) || (rst == 1));
    end

    // p19: type-2 insn => esr unchanged
    always @(posedge clk) begin
        p19: assert ((~(((ctrl_ex_insn & 32'hC0000000) >> 30) == 2)) || (except_esr == prev_esr) || (rst == 1));
    end

    // p20: type-3 insn with non-zero subfield => esr unchanged
    always @(posedge clk) begin
        p20: assert ((~(((ctrl_ex_insn & 32'hC0000000) >> 30) == 3) || ~((ctrl_ex_insn & 32'h3C000000) != 0)) || (except_esr == prev_esr) || (rst == 1));
    end

    // p21: opcode 9 => eear unchanged
    always @(posedge clk) begin
        p21: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 9)) || (except_eear == prev_eear) || (rst == 1));
    end

    // p22: opcode 9 => epcr unchanged
    always @(posedge clk) begin
        p22: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 9)) || (except_epcr == prev_epcr) || (rst == 1));
    end

    // p23: opcode 9 => esr unchanged
    always @(posedge clk) begin
        p23: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 9)) || (except_esr == prev_esr) || (rst == 1));
    end

    // p24: opcode 9 => genpc_pc == epcr
    always @(posedge clk) begin
        p24: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 9)) || (genpc_pc == except_epcr) || (rst == 1));
    end

    // p25: opcode 9 => to_sr == esr
    always @(posedge clk) begin
        p25: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 9)) || (sprs_to_sr == except_esr) || (rst == 1));
    end

    // p26: prev_ex_insn[31:16]==8192 and ex_insn[31:16]!=8192 => lsu_addr==eear
    always @(posedge clk) begin
        p26: assert ((~(((prev_ex_insn & 32'hFFFF0000) >> 16) == 8192)) || (~(((ctrl_ex_insn & 32'hFFFF0000) >> 16) != 8192)) || (except_lsu_addr == except_eear) || (rst == 1));
    end

    // p27: prev_ex_insn[31:16]==8192 and ex_insn[31:16]!=8192 => spr_dat_npc==epcr
    always @(posedge clk) begin
        p27: assert ((~(((prev_ex_insn & 32'hFFFF0000) >> 16) == 8192)) || (~(((ctrl_ex_insn & 32'hFFFF0000) >> 16) != 8192)) || (except_spr_dat_npc == except_epcr) || (rst == 1));
    end

    // p28: wb_insn[31:16]==8192 => lsu_addr==eear
    always @(posedge clk) begin
        p28: assert ((~(((ctrl_wb_insn & 32'hFFFF0000) >> 16) == 8192)) || (except_lsu_addr == except_eear) || (rst == 1));
    end

    // p29: wb_insn[31:16]==8192 => spr_dat_npc==epcr
    always @(posedge clk) begin
        p29: assert ((~(((ctrl_wb_insn & 32'hFFFF0000) >> 16) == 8192)) || (except_spr_dat_npc == except_epcr) || (rst == 1));
    end

    // p30: ex_insn[31:16]==8192 => rf_addrw matches insn field
    always @(posedge clk) begin
        p30: assert ((~(((ctrl_ex_insn & 32'hFFFF0000) >> 16) == 8192)) || (rf_rf_addrw == ((ctrl_ex_insn & 32'h03E00000) >> 21)) || (rst == 1));
    end

    // p31: opcode 47 (l.mfspr) => rf_we == 0
    always @(posedge clk) begin
        p31: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 47)) || (rf_we == 0) || (rst == 1));
    end

    // p32: opcode 57 => rf_we == 0
    always @(posedge clk) begin
        p32: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 57)) || (rf_we == 0) || (rst == 1));
    end

    // p33: opcode 51 => rf_we == 0
    always @(posedge clk) begin
        p33: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 51)) || (rf_we == 0) || (rst == 1));
    end

    // p34: opcode 52 => rf_we == 0
    always @(posedge clk) begin
        p34: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 52)) || (rf_we == 0) || (rst == 1));
    end

    // p35: opcode 53 => rf_we == 0
    always @(posedge clk) begin
        p35: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 53)) || (rf_we == 0) || (rst == 1));
    end

    // p36: opcode 54 => rf_we == 0
    always @(posedge clk) begin
        p36: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 54)) || (rf_we == 0) || (rst == 1));
    end

    // p37: opcode 55 => rf_we == 0
    always @(posedge clk) begin
        p37: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 55)) || (rf_we == 0) || (rst == 1));
    end

    // p38: opcode 48 => rf_we == 0
    always @(posedge clk) begin
        p38: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 48)) || (rf_we == 0) || (rst == 1));
    end

    // p39: opcode[31:24]==21 => rf_we == 0
    always @(posedge clk) begin
        p39: assert ((~(((ctrl_ex_insn & 32'hFF000000) >> 24) == 21)) || (rf_we == 0) || (rst == 1));
    end

    // p40: opcode 9 => rf_we == 0
    always @(posedge clk) begin
        p40: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 9)) || (rf_we == 0) || (rst == 1));
    end

    // p41: opcode 17 => rf_we == 0
    always @(posedge clk) begin
        p41: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 17)) || (rf_we == 0) || (rst == 1));
    end

    // p42: opcode 0 => rf_we == 0
    always @(posedge clk) begin
        p42: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 0)) || (rf_we == 0) || (rst == 1));
    end

    // p43: opcode 4 => rf_we == 0
    always @(posedge clk) begin
        p43: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 4)) || (rf_we == 0) || (rst == 1));
    end

    // p44: opcode 3 => rf_we == 0
    always @(posedge clk) begin
        p44: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 3)) || (rf_we == 0) || (rst == 1));
    end

    // p45: opcode 8 => rf_we == 0
    always @(posedge clk) begin
        p45: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 8)) || (rf_we == 0) || (rst == 1));
    end

    // p46: opcode 48 => spr_dat_o == operand_b
    always @(posedge clk) begin
        p46: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 48)) || (sprs_spr_dat_o == operand_b));
    end

    // p47: type-2 insn => addrw matches insn field
    always @(posedge clk) begin
        p47: assert ((~(((ctrl_ex_insn & 32'hC0000000) >> 30) == 2)) || (((ctrl_ex_insn & 32'h03E00000) >> 21) == rf_addrw) || (rst == 1));
    end

    // p48: type-3 insn => addrw matches insn field
    always @(posedge clk) begin
        p48: assert ((~(((ctrl_ex_insn & 32'hC0000000) >> 30) == 3)) || (((ctrl_ex_insn & 32'h03E00000) >> 21) == rf_addrw) || (rst == 1));
    end

    // p49: opcode 0x1c must not be executed
    always @(posedge clk) begin
        p49: assert ((((ctrl_ex_insn & 32'hFC000000) >> 26) != 32'h1c) || (rst == 1));
    end

    // p50: id_insn must be NOP, prev insn, or frozen
    always @(posedge clk) begin
        p50: assert ((id_insn == 32'h14410000) || (id_insn == 32'h14610000) || (id_insn == prev_if_insn) || (prev_id_freeze) || (rst == 1));
    end

    // p51: if_insn must be NOP, icpu_dat_i, 0, or insn_saved
    always @(posedge clk) begin
        p51: assert ((if_insn == 32'h14610000) || (if_insn == 32'h14410000) || (if_insn == icpu_dat_i) || (if_insn == 0) || (rst == 1) || (if_insn == if_insn_saved));
    end

    // p52: operand_b should match dcpu_dat_o
    always @(posedge clk) begin
        p52: assert ((operand_b == dcpu_dat_o) || (rst == 1));
    end

    // p53: opcode 32 => rf_dataw == dcpu_dat_o
    always @(posedge clk) begin
        p53: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 32)) || (rf_rf_dataw == dcpu_dat_o) || (rst == 1));
    end

    // p54: opcode 33 => rf_dataw == dcpu_dat_o
    always @(posedge clk) begin
        p54: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 33)) || (rf_rf_dataw == dcpu_dat_o) || (rst == 1));
    end

    // p55: opcode 34 => rf_dataw == dcpu_dat_o
    always @(posedge clk) begin
        p55: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 34)) || (rf_rf_dataw == dcpu_dat_o) || (rst == 1));
    end

    // p56: opcode 35 => rf_dataw == dcpu_dat_o
    always @(posedge clk) begin
        p56: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 35)) || (rf_rf_dataw == dcpu_dat_o) || (rst == 1));
    end

    // p57: opcode 36 => rf_dataw == dcpu_dat_o
    always @(posedge clk) begin
        p57: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 36)) || (rf_rf_dataw == dcpu_dat_o) || (rst == 1));
    end

    // p58: opcode 37 => rf_dataw == dcpu_dat_o
    always @(posedge clk) begin
        p58: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 37)) || (rf_rf_dataw == dcpu_dat_o) || (rst == 1));
    end

    // p59: opcode 38 => rf_dataw == dcpu_dat_o
    always @(posedge clk) begin
        p59: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 38)) || (rf_rf_dataw == dcpu_dat_o) || (rst == 1));
    end

    // p60: opcode 32 => dcpu_adr_o == operand_a + ex_simm
    always @(posedge clk) begin
        p60: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 32)) || (dcpu_adr_o == operand_a + ex_simm) || (rst == 1));
    end

    // p61: opcode 33 => dcpu_adr_o == operand_a + ex_simm
    always @(posedge clk) begin
        p61: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 33)) || (dcpu_adr_o == operand_a + ex_simm) || (rst == 1));
    end

    // p62: opcode 34 => dcpu_adr_o == operand_a + ex_simm
    always @(posedge clk) begin
        p62: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 34)) || (dcpu_adr_o == operand_a + ex_simm) || (rst == 1));
    end

    // p63: opcode 35 => dcpu_adr_o == operand_a + ex_simm
    always @(posedge clk) begin
        p63: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 35)) || (dcpu_adr_o == operand_a + ex_simm) || (rst == 1));
    end

    // p64: opcode 36 => dcpu_adr_o == operand_a + ex_simm
    always @(posedge clk) begin
        p64: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 36)) || (dcpu_adr_o == operand_a + ex_simm) || (rst == 1));
    end

    // p65: opcode 37 => dcpu_adr_o == operand_a + ex_simm
    always @(posedge clk) begin
        p65: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 37)) || (dcpu_adr_o == operand_a + ex_simm) || (rst == 1));
    end

    // p66: opcode 38 => dcpu_adr_o == operand_a + ex_simm
    always @(posedge clk) begin
        p66: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 38)) || (dcpu_adr_o == operand_a + ex_simm) || (rst == 1));
    end

    // p67: opcode 37 => mem2reg_regdata upper 16 bits == 0
    always @(posedge clk) begin
        p67: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 37)) || ((mem2reg_regdata & 32'hFFFF0000) == 0) || (rst == 1));
    end

    // p68: opcode 53 => reg2mem lower 16 bits match
    always @(posedge clk) begin
        p68: assert ((~(((ctrl_ex_insn & 32'hFC000000) >> 26) == 53)) || ((reg2mem_memdata & 32'hFFFF) == (reg2mem_regdata & 32'hFFFF)) || (rst == 1));
    end

    // p69: LSU data input should match memory-to-register data
    always @(posedge clk) begin
        p69: assert ((lsu_dcpu_dat_i == mem2reg_memdata) || (rst == 1));
    end

    // p70: rf_we==1 and rf_addrw==0 => rf_dataw==0
    always @(posedge clk) begin
        p70: assert ((~((rf_we == 1) && (rf_rf_addrw == 0))) || (rf_rf_dataw == 0) || (rst == 1));
    end

    // p71: rotate-right insn => rf_dataw matches rotation result
    always @(posedge clk) begin
        p71: assert ((~((ctrl_ex_insn & 32'hFC0003CF) == 32'hE00000C8)) || (((operand_a << (6'd32 - {1'b0, operand_b[4:0]})) | (operand_a >> operand_b[4:0])) == rf_rf_dataw) || (rf_rf_dataw == 0) || (rst == 1));
    end

endmodule
