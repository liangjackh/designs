module jg_properties (
    input logic clk_i,
    input logic rst_ni
);

    default clocking cb @(posedge clk_i); endclocking
    default disable iff (!rst_ni);

    // p1: JTAG password flag not reset properly
    // Bug 1, CWE-1239
    HACKDAC_p1: assert property (
        ~top_wrapper_dac21.dmi_jtag_i.trst_ni
        |-> top_wrapper_dac21.dmi_jtag_i.pass_check == 1'b0
    );

    // p2: Able to write using JTAG without password
    // Bug 2, CWE-1245
    HACKDAC_p2: assert property (
        (top_wrapper_dac21.dmi_jtag_i.state_q == top_wrapper_dac21.dmi_jtag_i.Idle &&
         top_wrapper_dac21.dmi_jtag_i.state_d == top_wrapper_dac21.dmi_jtag_i.Write)
        |-> top_wrapper_dac21.dmi_jtag_i.pass_check == 1'b1
    );

    // p7: Incorrect access control setting leaving debug enabled
    // Bug 7, CWE-1220
    HACKDAC_p7: assert property (
        ~(top_wrapper_dac21.ariane_i.csr_regfile_i.debug_mode_q) || (riscv::PRIV_LVL_M)
    );

    // p14: Counter register in AES CTR mode does not increase
    // Bug 14, CWE-1240
    HACKDAC_p14: assert property (
        (top_wrapper_dac21.aes0_wrapper_i.aes.uut.validCounter - 1) ==
        $past(top_wrapper_dac21.aes0_wrapper_i.aes.uut.validCounter)
    );

    // p18: Access to CSRs from lower privilege level
    // Bug 18, CWE-1262
    HACKDAC_p18: assert property (
        (top_wrapper_dac21.ariane_i.csr_regfile_i.csr_we &&
         top_wrapper_dac21.ariane_i.csr_regfile_i.csr_addr.address == riscv::CSR_SIE)
        |-> top_wrapper_dac21.ariane_i.csr_regfile_i.mie_d ==
            ((top_wrapper_dac21.ariane_i.csr_regfile_i.mie_q &
              ~top_wrapper_dac21.ariane_i.csr_regfile_i.mideleg_q) |
             (top_wrapper_dac21.ariane_i.csr_regfile_i.csr_wdata &
              top_wrapper_dac21.ariane_i.csr_regfile_i.mideleg_q))
    );

    // p30: JTAG key is hardcoded
    // Bug 30, CWE-1329
    HACKDAC_p30: assert property (
        top_wrapper_dac21.dmi_jtag_i.pass_mode
        |-> (top_wrapper_dac21.dmi_jtag_i.pass_data == top_wrapper_dac21.dmi_jtag_i.data_d)
    );

    // p35: Reg locks are disabled by default when reset
    // Bug 35, CWE-1232
    HACKDAC_p35: assert property (
        ~(top_wrapper_dac21.reglk_wrapper_i.rst_ni &&
          ~top_wrapper_dac21.reglk_wrapper_i.jtag_unlock &&
          ~top_wrapper_dac21.reglk_wrapper_i.rst_9)
        |-> (top_wrapper_dac21.reglk_wrapper_i.reglk_mem == 'h0)
    );

    // p36: SHA input data not cleared after HASH computation
    // Bug 36, CWE-1239
    HACKDAC_p36: assert property (
        (top_wrapper_dac21.sha256_wrapper_i.sha256.sha256_ctrl_reg ==
             top_wrapper_dac21.sha256_wrapper_i.sha256.CTRL_IGNORE &&
         top_wrapper_dac21.sha256_wrapper_i.sha256.ignore_input_reg)
        |-> (top_wrapper_dac21.sha256_wrapper_i.data == 0)
    );

    // p39: AES plain text is left uncleared after encryption in peripheral registers
    // Bug 39, CWE-226
    HACKDAC_p39: assert property (
        top_wrapper_dac21.aes0_wrapper_i.ct_valid
        |-> ((top_wrapper_dac21.aes0_wrapper_i.p_c[0] == 0) &&
             (top_wrapper_dac21.aes0_wrapper_i.p_c[1] == 0) &&
             (top_wrapper_dac21.aes0_wrapper_i.p_c[2] == 0) &&
             (top_wrapper_dac21.aes0_wrapper_i.p_c[3] == 0))
    );

    // p42: At reset, the access control values are set to full access
    // Bug 42, CWE-276
    HACKDAC_p42: assert property (
        (top_wrapper_dac21.acct_wrapper_i.rst_ni && top_wrapper_dac21.rst_6) ||
        (top_wrapper_dac21.acct_wrapper_i.acct_mem.read_data_0[0] == 32'h0000_0000)
    );

    // p46: Not disconnecting sensitive data from fuse when in debug mode
    // Bug 46, CWE-1243
    HACKDAC_p46: assert property (
        top_wrapper_dac21.aes0_wrapper_i.debug_mode_i
        |-> ((top_wrapper_dac21.aes0_wrapper_i.key_big == 192'b0) &&
             (top_wrapper_dac21.aes0_wrapper_i.key_big2 == 192'b0))
    );

    // p47: Not clearing one of the AES keys when entering debug mode
    // Bug 47, CWE-1258
    HACKDAC_p47: assert property (
        top_wrapper_dac21.aes0_wrapper_i.debug_mode_i
        |-> ((top_wrapper_dac21.aes0_wrapper_i.key_big == 192'b0) &&
             (top_wrapper_dac21.aes0_wrapper_i.key_big2 == 192'b0))
    );

    // p48: JTAG unlock disables the reglocks
    // Bug 48, CWE-1234
    HACKDAC_p48: assert property (
        ~(top_wrapper_dac21.reglk_wrapper_i.rst_ni && ~top_wrapper_dac21.rst_9)
        |-> ~top_wrapper_dac21.reglk_wrapper_i.jtag_unlock
    );

    // p57: DMA gets stuck in unknown state when abort issued with no active command
    // Bug 57, CWE-1245
    HACKDAC_p57: assert property (
        (top_wrapper_dac21.dma_i.dma_ctrl_reg == top_wrapper_dac21.dma_i.CTRL_ABORT &&
         !top_wrapper_dac21.dma_i.done_i)
        |=> top_wrapper_dac21.dma_i.dma_ctrl_reg != top_wrapper_dac21.dma_i.CTRL_ABORT
    );

    // p84: Unreachable state WaitWriteValid in JTAG
    // Bug 84, CWE-1245
    HACKDAC_p84: assert property (
        (top_wrapper_dac21.dmi_jtag_i.dmi_req_ready &&
         top_wrapper_dac21.dmi_jtag_i.state_q == top_wrapper_dac21.dmi_jtag_i.Write)
        |=> (top_wrapper_dac21.dmi_jtag_i.state_q == top_wrapper_dac21.dmi_jtag_i.WaitWriteValid)
    );

    // p95: Output message on RSA not cleared after soft reset
    // Bug 95, CWE-226
    HACKDAC_p95: assert property (
        ~(top_wrapper_dac21.rsa_wrapper_i.rst_ni && ~top_wrapper_dac21.rsa_wrapper_i.rst_13)
        |-> (top_wrapper_dac21.rsa_wrapper_i.msg_out == 0)
    );

    // p96: ROM module is hardcoded
    // Bug 96, CWE-1310
    HACKDAC_p96_modified: assert property (
        top_wrapper_dac21.riscv_peripherals_i.ariane_boot_sel_i
        |-> top_wrapper_dac21.riscv_peripherals_i.rom_rdata_linux
    );

endmodule

bind top_wrapper_dac21 jg_properties jg_bind_inst (
    .clk_i  (clk_i),
    .rst_ni (rst_ni)
);
