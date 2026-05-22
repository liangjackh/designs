module jg_properties (
    input logic clk_i,
    input logic rst_ni
);

    default clocking cb @(posedge clk_i); endclocking
    default disable iff (!rst_ni);

    // p1: Processor access to CLINT grants it access to PLIC regardless of PLIC access configuration
    // Bug 1, CWE-1220
    HACKDAC_p1: assert property (
        ~( (formal_top.dut.axi_node_intf_wrap_i.i_connectivity_map.runtime_j == 6) &&
            formal_top.dut.axi_node_intf_wrap_i.i_connectivity_map.access_ctrl_i
                [formal_top.dut.axi_node_intf_wrap_i.i_connectivity_map.runtime_i]
                [7]
                [formal_top.dut.axi_node_intf_wrap_i.i_connectivity_map.priv_lvl_i] )
    );

    // p5: Incorrect access control setting leaving debug enabled
    // Bug 5, CWE-1244
    HACKDAC_p5: assert property (
        ~(formal_top.dut.ariane_i.csr_regfile_i.debug_mode_q &&
          formal_top.dut.ariane_i.csr_regfile_i.umode_i)
        || (riscv::PRIV_LVL_M)
    );

    // p9: Execute machine level instructions from user mode
    // Bug 9, CWE-1262
    HACKDAC_p9: assert property (
        ((formal_top.dut.ariane_i.csr_regfile_i.csr_we ||
          formal_top.dut.ariane_i.csr_regfile_i.csr_read) &&
         (formal_top.dut.ariane_i.csr_regfile_i.csr_addr.address == riscv::CSR_MEPC))
        |-> formal_top.dut.ariane_i.csr_regfile_i.csr_exception_o.valid == 1'b1
    );

    // p21: Receive CSR interrupts when committing atomic instructions
    // Bug 21, CWE-1281
    HACKDAC_p21: assert property (
        formal_top.dut.ariane_i.commit_stage_i.amo_valid_commit_o
        |-> (formal_top.dut.ariane_i.commit_stage_i.exception_o !=
             formal_top.dut.ariane_i.commit_stage_i.csr_exception_i)
    );

    // p22: Commit the second instruction even if the first is atomic instruction
    // Bug 22
    HACKDAC_p22: assert property (
        formal_top.dut.ariane_i.commit_stage_i.amo_valid_commit_o
        |-> ~formal_top.dut.ariane_i.commit_stage_i.commit_ack_o[1]
    );

    // p23: Pipeline not flushed after committing an atomic instruction
    // Bug 23
    HACKDAC_p23: assert property (
        formal_top.dut.ariane_i.amo_valid_commit
        |-> (formal_top.dut.ariane_i.flush_ctrl_if &&
             formal_top.dut.ariane_i.flush_ctrl_id &&
             formal_top.dut.ariane_i.flush_ctrl_ex)
    );

    // p24: SATP register (read) accessible in Supervisor mode even if TVM is enabled
    // Bug 24
    HACKDAC_p24: assert property (
        formal_top.dut.ariane_i.csr_regfile_i.tvm_o
        |-> (formal_top.dut.ariane_i.csr_regfile_i.csr_rdata_o !=
             formal_top.dut.ariane_i.csr_regfile_i.satp_q)
    );

    // p25: SATP register (write) accessible in Supervisor mode even if TVM is enabled
    // Bug 25
    HACKDAC_p25: assert property (
        formal_top.dut.ariane_i.csr_regfile_i.tvm_o
        |-> (formal_top.dut.ariane_i.csr_regfile_i.satp_d !=
             formal_top.dut.ariane_i.csr_regfile_i.csr_wdata_i)
    );

    // p26: Pipeline not flushed after change in virtual address translation mode
    // Bug 26
    HACKDAC_p26: assert property (
        (formal_top.dut.ariane_i.priv_lvl != $past(formal_top.dut.ariane_i.priv_lvl))
        |-> (formal_top.dut.ariane_i.flush_ctrl_if &&
             formal_top.dut.ariane_i.flush_ctrl_id &&
             formal_top.dut.ariane_i.flush_ctrl_ex)
    );

    // p29: Instruction retired counters are updated in non-debug mode
    // Bug 29
    HACKDAC_p29: assert property (
        (formal_top.dut.ariane_i.csr_regfile_i.instret_q !=
         $past(formal_top.dut.ariane_i.csr_regfile_i.instret_q))
        |-> formal_top.dut.ariane_i.csr_regfile_i.debug_mode_q
    );

    // p32: Exception signal is not set at halt
    // Bug 32
    HACKDAC_p32: assert property (
        formal_top.dut.ariane_i.controller_i.halt_o
        |-> formal_top.dut.ariane_i.controller_i.ex_valid_i
    );

endmodule

bind formal_top jg_properties jg_bind_inst (
    .clk_i  (clk_i),
    .rst_ni (rst_ni)
);
