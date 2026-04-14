`include "pulp_soc_defines.sv"
`include "periph_bus_defines.sv"

module jg_properties (
    input clk_top,
    input rstn_top
);

    // 设置默认时钟，对应 JG 里的 clock clk_top -both_edges
    // 注意：SVA 通常仅在一个边沿采样，这里我们默认用 posedge。如果确实需要双边沿采样可以修改。
    default clocking cb @(posedge clk_top); endclocking

    // 定义复位条件
    // JG里指定了: reset -expression ~rstn_top
    // 我们可以将其作为 assume 或在 property 中处理，但在 SBY 中由于没有专门的全局 init，
    // 我们通常让 property 自带前置条件，或者在设计层面处理复位。
    
    // --- Properties ---
    
    //HACKDAC_p1: assert property (
    //    ((`SOC_CTRL_END_ADDR <= `UDMA_START_ADDR) && (`SOC_CTRL_START_ADDR >= `UDMA_END_ADDR))
    //);
    
    HACKDAC_p2: assert property (
        ~(((top_wrapper.soc_interconnect.TCDM_data_gnt_DEM_TO_XBAR) >> 1) &&
        ((top_wrapper.soc_interconnect.TCDM_data_add_DEM_TO_XBAR >= 32'h1C00_0000) &&
         (top_wrapper.soc_interconnect.TCDM_data_add_DEM_TO_XBAR <= 32'h1C08_0000)))
    );
    HACKDAC_p2: assert property (
        ~((soc_interconnect.TCDM_data_gnt_DEM_TO_XBAR) >> 1) && 
        ((soc_interconnect.TCDM_data_add_DEM_TO_XBAR >= 32'h1C00_0000) && 
        (soc_interconnect.TCDM_data_add_DEM_TO_XBAR <= 32'h1C08_0000))
     );
    
    HACKDAC_p3: assert property (
        (~((top_wrapper.riscv_core.cs_registers_i.priv_lvl_n == 2'b11) &&
           (top_wrapper.riscv_core.cs_registers_i.mstatus_n.mpp == 2'b00)))
    );
    
    HACKDAC_p4: assert property (
        ~((top_wrapper.apb_gpio.PWDATA == 32'h1234_5678) && 
          ((top_wrapper.apb_gpio.s_apb_addr == 5'b10010) && 
           (top_wrapper.apb_gpio.r_gpio_lock == 32'h1234_5678)))
    );
    
    HACKDAC_p5: cover property (
        ~((top_wrapper.apb_gpio.HRESETn) || (top_wrapper.apb_gpio.r_gpio_lock == 0))
    );
    
    HACKDAC_p6: assert property (
        (`GPIO_START_ADDR == 32'h1A10_1000) && (`GPIO_END_ADDR == 32'h1A10_1FFF)
    );
    
    HACKDAC_p7: assert property (
        ((top_wrapper.axi_address_decoder_AR.outstanding_trans_i) && 
         (top_wrapper.axi_address_decoder_AR.CS == top_wrapper.axi_address_decoder_AR.NS))
    );
    
    HACKDAC_p8: assert property (
        (((`GPIO_END_ADDR <= `UDMA_START_ADDR) && (`GPIO_START_ADDR >= `UDMA_END_ADDR)) && 
         ((`SOC_CTRL_END_ADDR <= `UDMA_START_ADDR) && (`SOC_CTRL_START_ADDR >= `UDMA_END_ADDR)) && 
         ((`SOC_CTRL_END_ADDR <= `GPIO_START_ADDR) && (`SOC_CTRL_START_ADDR >= `GPIO_END_ADDR)))
    );
    
    HACKDAC_p9: assert property (
        ~((top_wrapper.adbg_tap_top.passchk == 1) && ~(top_wrapper.adbg_tap_top.bitindex == 32))
    );
    
    HACKDAC_p10: assert property (
        (top_wrapper.adbg_tap_top.passchk == 1) |-> (top_wrapper.adbg_tap_top.bitindex == 32)
    );
    
    HACKDAC_p11: assert property (
        (~((top_wrapper.riscv_core.debug_unit_i.dbg_halt != 1) &&
           (top_wrapper.riscv_core.debug_unit_i.rdata_sel_n == 3'b100)))  // RD_DBGS = 3'b100 (5th value in enum)
    );
    
    HACKDAC_p12: assert property (
        (~(top_wrapper.adbg_tap_top.passchk == 1) && (top_wrapper.adbg_tap_top.correct <= 31))
    );
    
    HACKDAC_p13: assert property (
        (top_wrapper.riscv_core.id_stage_i.controller_i.ctrl_fsm_ns == top_wrapper.riscv_core.id_stage_i.controller_i.DECODE) |=> 
        (top_wrapper.riscv_core.id_stage_i.controller_i.ctrl_fsm_ns != top_wrapper.riscv_core.id_stage_i.controller_i.DECODE)
    );
    
    HACKDAC_p14: assert property (
        (((top_wrapper.riscv_core.ex_stage_i.alu_i.vector_mode_i == 2'b10) ||  // VEC_MODE16 = 2'b10
          (top_wrapper.riscv_core.ex_stage_i.alu_i.vector_mode_i == 2'b11)) |->  // VEC_MODE8 = 2'b11
         (top_wrapper.riscv_core.ex_stage_i.alu_i.adder_in_a[18] == 1'b0))
    );
    
    HACKDAC_p15: assert property (
        (top_wrapper.rtc_clock.r_seconds < 8'h59)
    );
    
    HACKDAC_p16: assert property (
        (top_wrapper.adbg_tap_top.trstn_pad_i) || (top_wrapper.adbg_tap_top.correct == 0)
    );
    
    HACKDAC_p21: assert property (
        (~(top_wrapper.mux_func.c == top_wrapper.mux_func.temperature_out))
    );
    
    HACKDAC_p27: assert property (
        top_wrapper.riscv_core.cs_registers_i.csr_we_int |-> top_wrapper.riscv_core.cs_registers_i.PULP_SECURE
    );
    
    HACKDAC_p28: assert property (
        ((top_wrapper.jtag_tap_top.td_i == 1 || top_wrapper.jtag_tap_top.td_i == 0))
    );
    
     HACKDAC_p29: Commented out - aes_out and c are internal signals in mux_func, not in top_wrapper
     HACKDAC_p29: assert property (
         !rstn_top |-> (top_wrapper.aes_out == 0 && top_wrapper.c == 0)
     );

endmodule

// 使用 bind 语句将上面的属性模块绑定到 top_wrapper 内部
bind top_wrapper jg_properties jg_bind_inst (
    .clk_top(clk_top),
    .rstn_top(rstn_top)
);
