// Bind or1200_assertions into or1200_cpu using internal wires.
// This mirrors the hackatdac18 pattern: bind <target_module> <assertions_module> <inst_name> (.ports)
//
// Signal mapping:
//   or1200_assertions port     <- or1200_cpu internal wire/port
//   except_wb_pc               <- wb_pc          (output port)
//   except_epcr                <- epcr            (internal wire)
//   except_eear                <- eear            (internal wire)
//   except_esr                 <- esr             (internal wire)
//   except_lsu_addr            <- dcpu_adr_o      (lsu_addr connects to dcpu_adr_o)
//   except_spr_dat_npc         <- spr_dat_npc     (internal wire)
//   sprs_spr_dat_ppc           <- spr_dat_ppc     (internal wire)
//   sprs_spr_dat_npc           <- spr_dat_npc     (internal wire)
//   sprs_sr                    <- sr              (internal wire)
//   sprs_to_sr                 <- to_sr           (internal wire)
//   sprs_spr_dat_o             <- spr_dat_cpu     (output port, or1200_sprs.spr_dat_o)
//   ctrl_ex_insn               <- ex_insn         (output port)
//   ctrl_wb_insn               <- wb_insn         (output port)
//   ctrl_ex_pc                 <- ex_pc           (output port)
//   rf_rf_addrw                <- rf_addrw        (internal wire, pre-attack)
//   rf_addrw                   <- rf_addrw        (internal wire)
//   rf_rf_dataw                <- rf_dataw        (internal wire, wbmux output)
//   rf_we                      <- rfwb_op[0]      (internal wire, ctrl write-enable bit)
//   genpc_pc                   <- icpu_adr_o      (output port, best approximation)
//   operand_a                  <- operand_a       (internal wire)
//   operand_b                  <- operand_b       (internal wire)
//   ex_simm                    <- ex_simm         (internal wire)
//   if_insn                    <- if_insn         (internal wire)
//   if_insn_saved              <- 32'b0           (or1200_if.insn_saved not exposed)
//   lsu_dcpu_dat_i             <- dcpu_dat_i      (input port)
//   mem2reg_regdata            <- rf_dataw        (wbmux output = data written to RF)
//   mem2reg_memdata            <- dcpu_dat_i      (data from data cache)
//   reg2mem_memdata            <- dcpu_dat_o      (data to data cache)
//   reg2mem_regdata            <- operand_b       (lsu_datain = operand_b)
//   icpu_dat_i                 <- icpu_dat_i      (input port)
//   dcpu_adr_o                 <- dcpu_adr_o      (output port)
//   dcpu_dat_o                 <- dcpu_dat_o      (output port)
//   id_insn                    <- id_insn         (output port)
//   id_freeze                  <- id_freeze       (internal wire)

bind or1200_cpu or1200_assertions u_assertions (
    .clk            (clk),
    .rst            (rst),

    // From or1200_except
    .except_wb_pc       (wb_pc),
    .except_epcr        (epcr),
    .except_eear        (eear),
    .except_esr         (esr),
    .except_lsu_addr    (dcpu_adr_o),
    .except_spr_dat_npc (spr_dat_npc),

    // From or1200_sprs
    .sprs_spr_dat_ppc   (spr_dat_ppc),
    .sprs_spr_dat_npc   (spr_dat_npc),
    .sprs_sr            (sr),
    .sprs_to_sr         (to_sr),
    .sprs_spr_dat_o     (spr_dat_cpu),

    // From or1200_ctrl
    .ctrl_ex_insn       (ex_insn),
    .ctrl_wb_insn       (wb_insn),
    .ctrl_ex_pc         (ex_pc),

    // From or1200_rf
    .rf_rf_addrw        (rf_addrw),
    .rf_addrw           (rf_addrw),
    .rf_rf_dataw        (rf_dataw),
    .rf_we              (rfwb_op[0]),

    // From or1200_genpc
    .genpc_pc           (icpu_adr_o),

    // From or1200_cpu (operand muxes)
    .operand_a          (operand_a),
    .operand_b          (operand_b),
    .ex_simm            (ex_simm),

    // From or1200_if
    .if_insn            (if_insn),
    .if_insn_saved      (32'b0),

    // From or1200_lsu
    .lsu_dcpu_dat_i     (dcpu_dat_i),
    .mem2reg_regdata    (rf_dataw),
    .mem2reg_memdata    (dcpu_dat_i),
    .reg2mem_memdata    (dcpu_dat_o),
    .reg2mem_regdata    (operand_b),

    // External bus signals
    .icpu_dat_i         (icpu_dat_i),
    .dcpu_adr_o         (dcpu_adr_o),
    .dcpu_dat_o         (dcpu_dat_o),

    // Pipeline control
    .id_insn            (id_insn),
    .id_freeze          (id_freeze)
);
