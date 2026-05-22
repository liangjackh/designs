//////////////////////////////////////////////////////////////////////
// OR1200 Security Assertions — Implication Form
// Rewritten from or1200_assertions.sv:
//   ~A || B || (rst==1)  =>  (A && !rst) |-> B
// All assertions use: if (TRIGGER && !rst) assert (CONSEQUENT)
//////////////////////////////////////////////////////////////////////

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on
`include "or1200_defines.v"

module or1200_assertions_imp (
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

    // Previous state registers for temporal properties
    reg [`OR1200_SR_WIDTH-1:0] prev_sr0;
    reg [31:0] prev_epcr;
    reg [31:0] prev_eear;
    reg [`OR1200_SR_WIDTH-1:0] prev_esr;
    reg [31:0] prev_ex_insn;
    reg [31:0] prev_if_insn;
    reg prev_id_freeze;

    always @(posedge clk) begin
        if (rst) begin
            prev_sr0      <= 0;
            prev_epcr     <= 0;
            prev_eear     <= 0;
            prev_esr      <= 0;
            prev_ex_insn  <= 0;
            prev_if_insn  <= 0;
            prev_id_freeze <= 0;
        end else begin
            prev_sr0      <= sprs_sr[0];
            prev_epcr     <= except_epcr;
            prev_eear     <= except_eear;
            prev_esr      <= except_esr;
            prev_ex_insn  <= ctrl_ex_insn;
            prev_if_insn  <= if_insn;
            prev_id_freeze <= id_freeze;
        end
    end

    //==========================================================================
    // Control Flow Assertions (CWE-1281)
    //==========================================================================

    // p1: !rst -> (wb_pc == spr_dat_ppc)
    always @(posedge clk) begin
        p1: assert (!rst |-> (except_wb_pc == sprs_spr_dat_ppc));
    end

    // p2: (ex_insn[31:30]==1 && !rst) -> (ex_pc == spr_dat_npc)
    always @(posedge clk) begin
        p2: assert (!(((ctrl_ex_insn & 32'hC0000000) >> 30) == 1) || rst ||
                    (ctrl_ex_pc == sprs_spr_dat_npc));
    end

    // p3: (ex_insn[31:30]==2 && !rst) -> (ex_pc == spr_dat_npc)
    always @(posedge clk) begin
        p3: assert (!(((ctrl_ex_insn & 32'hC0000000) >> 30) == 2) || rst ||
                    (ctrl_ex_pc == sprs_spr_dat_npc));
    end

    // p4: (ex_insn[31:30]==3 && !rst) -> (ex_pc == spr_dat_npc)
    always @(posedge clk) begin
        p4: assert (!(((ctrl_ex_insn & 32'hC0000000) >> 30) == 3) || rst ||
                    (ctrl_ex_pc == sprs_spr_dat_npc));
    end

    // p5: (opcode==1826 && a>b && !rst) -> (to_sr[9]==1)
    always @(posedge clk) begin
        p5: assert (!(((ctrl_ex_insn & 32'hFFE00000) >> 21) == 1826) ||
                    !(operand_a > operand_b) || rst ||
                    (sprs_to_sr[9] == 1));
    end

    // p6: (opcode==1829 && a<=b && !rst) -> (to_sr[9]==1)
    always @(posedge clk) begin
        p6: assert (!(((ctrl_ex_insn & 32'hFFE00000) >> 21) == 1829) ||
                    !(operand_a <= operand_b) || rst ||
                    (sprs_to_sr[9] == 1));
    end

    // p7: (l.jal && !rst) -> (rf_addrw==9)
    always @(posedge clk) begin
        p7: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 1) || rst ||
                    (rf_rf_addrw == 9));
    end

    // p8: (ex_insn[31:30]==2 && !rst) -> (rf_addrw!=9)
    always @(posedge clk) begin
        p8: assert (!(((ctrl_ex_insn & 32'hC0000000) >> 30) == 2) || rst ||
                    (rf_rf_addrw != 9));
    end

    //==========================================================================
    // Privilege Escalation/De-escalation Assertions (CWE-1198)
    //==========================================================================

    // p9: (ex_insn[31:30]==1 && !rst) -> (sr[0] unchanged)
    always @(posedge clk) begin
        p9: assert (!(((ctrl_ex_insn & 32'hC0000000) >> 30) == 1) || rst ||
                    (sprs_sr[0] == prev_sr0));
    end

    // p10: (ex_insn[31:30]==2 && !rst) -> (sr[0] unchanged)
    always @(posedge clk) begin
        p10: assert (!(((ctrl_ex_insn & 32'hC0000000) >> 30) == 2) || rst ||
                     (sprs_sr[0] == prev_sr0));
    end

    // p11: (ex_insn[31:30]==3 && ex_insn[29:26]!=0 && !rst) -> (sr[0] unchanged)
    always @(posedge clk) begin
        p11: assert (!(((ctrl_ex_insn & 32'hC0000000) >> 30) == 3) ||
                     !((ctrl_ex_insn & 32'h3C000000) != 0) || rst ||
                     (sprs_sr[0] == prev_sr0));
    end

    // p12: (ex_insn[31:30]==1 && !rst) -> (epcr unchanged)
    always @(posedge clk) begin
        p12: assert (!(((ctrl_ex_insn & 32'hC0000000) >> 30) == 1) || rst ||
                     (except_epcr == prev_epcr));
    end

    // p13: (ex_insn[31:30]==2 && !rst) -> (epcr unchanged)
    always @(posedge clk) begin
        p13: assert (!(((ctrl_ex_insn & 32'hC0000000) >> 30) == 2) || rst ||
                     (except_epcr == prev_epcr));
    end

    // p14: (ex_insn[31:30]==3 && !rst) -> (epcr unchanged)
    always @(posedge clk) begin
        p14: assert (!(((ctrl_ex_insn & 32'hC0000000) >> 30) == 3) || rst ||
                     (except_epcr == prev_epcr));
    end

    // p15: (ex_insn[31:30]==1 && !rst) -> (eear unchanged)
    always @(posedge clk) begin
        p15: assert (!(((ctrl_ex_insn & 32'hC0000000) >> 30) == 1) || rst ||
                     (except_eear == prev_eear));
    end

    // p16: (ex_insn[31:30]==2 && !rst) -> (eear unchanged)
    always @(posedge clk) begin
        p16: assert (!(((ctrl_ex_insn & 32'hC0000000) >> 30) == 2) || rst ||
                     (except_eear == prev_eear));
    end

    // p17: (ex_insn[31:30]==3 && !rst) -> (eear unchanged)
    always @(posedge clk) begin
        p17: assert (!(((ctrl_ex_insn & 32'hC0000000) >> 30) == 3) || rst ||
                     (except_eear == prev_eear));
    end

    // p18: (ex_insn[31:30]==1 && !rst) -> (esr unchanged)
    always @(posedge clk) begin
        p18: assert (!(((ctrl_ex_insn & 32'hC0000000) >> 30) == 1) || rst ||
                     (except_esr == prev_esr));
    end

    // p19: (ex_insn[31:30]==2 && !rst) -> (esr unchanged)
    always @(posedge clk) begin
        p19: assert (!(((ctrl_ex_insn & 32'hC0000000) >> 30) == 2) || rst ||
                     (except_esr == prev_esr));
    end

    // p20: (ex_insn[31:30]==3 && ex_insn[29:26]!=0 && !rst) -> (esr unchanged)
    always @(posedge clk) begin
        p20: assert (!(((ctrl_ex_insn & 32'hC0000000) >> 30) == 3) ||
                     !((ctrl_ex_insn & 32'h3C000000) != 0) || rst ||
                     (except_esr == prev_esr));
    end

    // p21: (l.rfe && !rst) -> (eear unchanged)
    always @(posedge clk) begin
        p21: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 9) || rst ||
                     (except_eear == prev_eear));
    end

    // p22: (l.rfe && !rst) -> (epcr unchanged)
    always @(posedge clk) begin
        p22: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 9) || rst ||
                     (except_epcr == prev_epcr));
    end

    // p23: (l.rfe && !rst) -> (esr unchanged)
    always @(posedge clk) begin
        p23: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 9) || rst ||
                     (except_esr == prev_esr));
    end

    // p24: (l.rfe && !rst) -> (pc restored from epcr)
    always @(posedge clk) begin
        p24: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 9) || rst ||
                     (genpc_pc == except_epcr));
    end

    // p25: (l.rfe && !rst) -> (sr restored from esr)
    always @(posedge clk) begin
        p25: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 9) || rst ||
                     (sprs_to_sr == except_esr));
    end

    // p26: (prev_ex was load && cur_ex is not load && !rst) -> (lsu_addr == eear)
    always @(posedge clk) begin
        p26: assert (!(((prev_ex_insn & 32'hFFFF0000) >> 16) == 8192) ||
                     !(((ctrl_ex_insn & 32'hFFFF0000) >> 16) != 8192) || rst ||
                     (except_lsu_addr == except_eear));
    end

    // p27: (prev_ex was load && cur_ex is not load && !rst) -> (spr_dat_npc == epcr)
    always @(posedge clk) begin
        p27: assert (!(((prev_ex_insn & 32'hFFFF0000) >> 16) == 8192) ||
                     !(((ctrl_ex_insn & 32'hFFFF0000) >> 16) != 8192) || rst ||
                     (except_spr_dat_npc == except_epcr));
    end

    // p28: (wb_insn is load && !rst) -> (lsu_addr == eear)
    always @(posedge clk) begin
        p28: assert (!(((ctrl_wb_insn & 32'hFFFF0000) >> 16) == 8192) || rst ||
                     (except_lsu_addr == except_eear));
    end

    // p29: (wb_insn is load && !rst) -> (spr_dat_npc == epcr)
    always @(posedge clk) begin
        p29: assert (!(((ctrl_wb_insn & 32'hFFFF0000) >> 16) == 8192) || rst ||
                     (except_spr_dat_npc == except_epcr));
    end

    // p30: (ex_insn is load && !rst) -> (rf_addrw matches encoding)
    always @(posedge clk) begin
        p30: assert (!(((ctrl_ex_insn & 32'hFFFF0000) >> 16) == 8192) || rst ||
                     (rf_rf_addrw == ((ctrl_ex_insn & 32'h03E00000) >> 21)));
    end

    //==========================================================================
    // Update Registers Assertions (CWE-1262)
    //==========================================================================

    // p31-p45: (store/branch opcode && !rst) -> (rf_we==0)
    always @(posedge clk) begin
        p31: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 47) || rst || (rf_we == 0));
    end
    always @(posedge clk) begin
        p32: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 57) || rst || (rf_we == 0));
    end
    always @(posedge clk) begin
        p33: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 51) || rst || (rf_we == 0));
    end
    always @(posedge clk) begin
        p34: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 52) || rst || (rf_we == 0));
    end
    always @(posedge clk) begin
        p35: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 53) || rst || (rf_we == 0));
    end
    always @(posedge clk) begin
        p36: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 54) || rst || (rf_we == 0));
    end
    always @(posedge clk) begin
        p37: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 55) || rst || (rf_we == 0));
    end
    always @(posedge clk) begin
        p38: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 48) || rst || (rf_we == 0));
    end
    always @(posedge clk) begin
        p39: assert (!(((ctrl_ex_insn & 32'hFF000000) >> 24) == 21) || rst || (rf_we == 0));
    end
    always @(posedge clk) begin
        p40: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 9) || rst || (rf_we == 0));
    end
    always @(posedge clk) begin
        p41: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 17) || rst || (rf_we == 0));
    end
    always @(posedge clk) begin
        p42: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 0) || rst || (rf_we == 0));
    end
    always @(posedge clk) begin
        p43: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 4) || rst || (rf_we == 0));
    end
    always @(posedge clk) begin
        p44: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 3) || rst || (rf_we == 0));
    end
    always @(posedge clk) begin
        p45: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 8) || rst || (rf_we == 0));
    end

    // p46: (l.mtspr) -> (spr_dat_o == operand_b)   [no rst guard in original]
    always @(posedge clk) begin
        p46: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 48) ||
                     (sprs_spr_dat_o == operand_b));
    end

    //==========================================================================
    // Correct Results Assertions (CWE-1221)
    //==========================================================================

    // p47: (ex_insn[31:30]==2 && !rst) -> (rf_addrw matches encoding)
    always @(posedge clk) begin
        p47: assert (!(((ctrl_ex_insn & 32'hC0000000) >> 30) == 2) || rst ||
                     (((ctrl_ex_insn & 32'h03E00000) >> 21) == rf_addrw));
    end

    // p48: (ex_insn[31:30]==3 && !rst) -> (rf_addrw matches encoding)
    always @(posedge clk) begin
        p48: assert (!(((ctrl_ex_insn & 32'hC0000000) >> 30) == 3) || rst ||
                     (((ctrl_ex_insn & 32'h03E00000) >> 21) == rf_addrw));
    end

    //==========================================================================
    // Instruction Executed Assertions (CWE-1281)
    //==========================================================================

    // p49: !rst -> (opcode != 0x1c)
    always @(posedge clk) begin
        p49: assert (rst || (((ctrl_ex_insn & 32'hFC000000) >> 26) != 32'h1c));
    end

    // p50: !rst -> (id_insn is one of the expected values)
    always @(posedge clk) begin
        p50: assert (rst ||
                     (id_insn == 32'h14410000) || (id_insn == 32'h14610000) ||
                     (id_insn == prev_if_insn) || (prev_id_freeze));
    end

    // p51: !rst -> (if_insn is one of the expected values)
    always @(posedge clk) begin
        p51: assert (rst ||
                     (if_insn == 32'h14610000) || (if_insn == 32'h14410000) ||
                     (if_insn == icpu_dat_i)   || (if_insn == 0) ||
                     (if_insn == if_insn_saved));
    end

    //==========================================================================
    // Memory Access Assertions (CWE-1202)
    //==========================================================================

    // p52: !rst -> (operand_b == dcpu_dat_o)
    always @(posedge clk) begin
        p52: assert (rst || (operand_b == dcpu_dat_o));
    end

    // p53-p59: (load opcode && !rst) -> (rf_dataw == dcpu_dat_o)
    always @(posedge clk) begin
        p53: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 32) || rst || (rf_rf_dataw == dcpu_dat_o));
    end
    always @(posedge clk) begin
        p54: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 33) || rst || (rf_rf_dataw == dcpu_dat_o));
    end
    always @(posedge clk) begin
        p55: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 34) || rst || (rf_rf_dataw == dcpu_dat_o));
    end
    always @(posedge clk) begin
        p56: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 35) || rst || (rf_rf_dataw == dcpu_dat_o));
    end
    always @(posedge clk) begin
        p57: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 36) || rst || (rf_rf_dataw == dcpu_dat_o));
    end
    always @(posedge clk) begin
        p58: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 37) || rst || (rf_rf_dataw == dcpu_dat_o));
    end
    always @(posedge clk) begin
        p59: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 38) || rst || (rf_rf_dataw == dcpu_dat_o));
    end

    // p60-p66: (load/store opcode && !rst) -> (dcpu_adr_o == operand_a + ex_simm)
    always @(posedge clk) begin
        p60: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 32) || rst || (dcpu_adr_o == operand_a + ex_simm));
    end
    always @(posedge clk) begin
        p61: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 33) || rst || (dcpu_adr_o == operand_a + ex_simm));
    end
    always @(posedge clk) begin
        p62: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 34) || rst || (dcpu_adr_o == operand_a + ex_simm));
    end
    always @(posedge clk) begin
        p63: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 35) || rst || (dcpu_adr_o == operand_a + ex_simm));
    end
    always @(posedge clk) begin
        p64: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 36) || rst || (dcpu_adr_o == operand_a + ex_simm));
    end
    always @(posedge clk) begin
        p65: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 37) || rst || (dcpu_adr_o == operand_a + ex_simm));
    end
    always @(posedge clk) begin
        p66: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 38) || rst || (dcpu_adr_o == operand_a + ex_simm));
    end

    // p67: (l.lhz && !rst) -> (upper 16 bits of regdata are zero)
    always @(posedge clk) begin
        p67: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 37) || rst ||
                     ((mem2reg_regdata & 32'hFFFF0000) == 0));
    end

    // p68: (l.sh && !rst) -> (lower 16 bits of memdata match regdata)
    always @(posedge clk) begin
        p68: assert (!(((ctrl_ex_insn & 32'hFC000000) >> 26) == 53) || rst ||
                     ((reg2mem_memdata & 16'hFFFF) == (reg2mem_regdata & 16'hFFFF)));
    end

    // p69: !rst -> (dcpu_dat_i == memdata)
    always @(posedge clk) begin
        p69: assert (rst || (lsu_dcpu_dat_i == mem2reg_memdata));
    end

    // p70: (rf_we==1 && rf_addrw==0 && !rst) -> (rf_dataw==0)
    always @(posedge clk) begin
        p70: assert (!((rf_we == 1) && (rf_rf_addrw == 0)) || rst ||
                     (rf_rf_dataw == 0));
    end

    // p71: (ror opcode && !rst) -> (result == rotate_right(a, b[4:0]))
    always @(posedge clk) begin
        p71: assert (!((ctrl_ex_insn & 32'hFC0003CF) == 32'hE00000C8) || rst ||
                     (((operand_a << (32 - {1'b0, operand_b[4:0]})) |
                       (operand_a >> operand_b[4:0])) == rf_rf_dataw) ||
                     (rf_rf_dataw == 0));
    end

endmodule
