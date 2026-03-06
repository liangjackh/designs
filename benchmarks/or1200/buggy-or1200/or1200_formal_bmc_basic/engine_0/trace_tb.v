`ifndef VERILATOR
module testbench;
  reg [4095:0] vcdfile;
  reg clock;
`else
module testbench(input clock, output reg genclock);
  initial genclock = 1;
`endif
  reg genclock = 1;
  reg [31:0] cycle = 0;
  reg [31:0] PI_spr_dat_dmmu;
  reg [31:0] PI_spr_dat_immu;
  reg [3:0] PI_icpu_tag_i;
  reg [0:0] PI_du_stall;
  reg [0:0] PI_du_read;
  reg [31:0] PI_spr_dat_pm;
  reg [0:0] PI_sig_tick;
  reg [0:0] PI_dcpu_rty_i;
  reg [0:0] PI_icpu_err_i;
  reg [0:0] PI_du_hwbkpt_ls_r;
  reg [0:0] PI_immu_uxe;
  reg [0:0] PI_rst;
  reg [0:0] PI_icpu_ack_i;
  reg [0:0] PI_immu_sxe;
  reg [31:0] PI_spr_dat_du;
  reg [31:0] PI_spr_dat_pic;
  reg [31:0] PI_icpu_adr_i;
  reg [0:0] PI_dcpu_ack_i;
  reg [0:0] PI_du_hwbkpt;
  reg [13:0] PI_du_dsr;
  reg [31:0] PI_du_dat_du;
  reg [24:0] PI_du_dmr1;
  reg [31:0] PI_du_addr;
  reg [31:0] PI_dcpu_dat_i;
  wire [0:0] PI_clk = clock;
  reg [3:0] PI_dcpu_tag_i;
  reg [0:0] PI_icpu_rty_i;
  reg [0:0] PI_du_write;
  reg [0:0] PI_sig_int;
  reg [0:0] PI_dcpu_err_i;
  reg [31:0] PI_icpu_dat_i;
  reg [0:0] PI_boot_adr_sel_i;
  reg [31:0] PI_spr_dat_tt;
  reg [0:0] PI_mtspr_dc_done;
  or1200_cpu UUT (
    .spr_dat_dmmu(PI_spr_dat_dmmu),
    .spr_dat_immu(PI_spr_dat_immu),
    .icpu_tag_i(PI_icpu_tag_i),
    .du_stall(PI_du_stall),
    .du_read(PI_du_read),
    .spr_dat_pm(PI_spr_dat_pm),
    .sig_tick(PI_sig_tick),
    .dcpu_rty_i(PI_dcpu_rty_i),
    .icpu_err_i(PI_icpu_err_i),
    .du_hwbkpt_ls_r(PI_du_hwbkpt_ls_r),
    .immu_uxe(PI_immu_uxe),
    .rst(PI_rst),
    .icpu_ack_i(PI_icpu_ack_i),
    .immu_sxe(PI_immu_sxe),
    .spr_dat_du(PI_spr_dat_du),
    .spr_dat_pic(PI_spr_dat_pic),
    .icpu_adr_i(PI_icpu_adr_i),
    .dcpu_ack_i(PI_dcpu_ack_i),
    .du_hwbkpt(PI_du_hwbkpt),
    .du_dsr(PI_du_dsr),
    .du_dat_du(PI_du_dat_du),
    .du_dmr1(PI_du_dmr1),
    .du_addr(PI_du_addr),
    .dcpu_dat_i(PI_dcpu_dat_i),
    .clk(PI_clk),
    .dcpu_tag_i(PI_dcpu_tag_i),
    .icpu_rty_i(PI_icpu_rty_i),
    .du_write(PI_du_write),
    .sig_int(PI_sig_int),
    .dcpu_err_i(PI_dcpu_err_i),
    .icpu_dat_i(PI_icpu_dat_i),
    .boot_adr_sel_i(PI_boot_adr_sel_i),
    .spr_dat_tt(PI_spr_dat_tt),
    .mtspr_dc_done(PI_mtspr_dc_done)
  );
`ifndef VERILATOR
  initial begin
    if ($value$plusargs("vcd=%s", vcdfile)) begin
      $dumpfile(vcdfile);
      $dumpvars(0, testbench);
    end
    #5 clock = 0;
    while (genclock) begin
      #5 clock = 0;
      #5 clock = 1;
    end
  end
`endif
  initial begin
`ifndef VERILATOR
    #1;
`endif
    UUT.or1200_ctrl._witness_.anyinit_procdff_3183 = 1'b0;
    UUT.or1200_ctrl._witness_.anyinit_procdff_3186 = 1'b0;
    UUT.or1200_ctrl._witness_.anyinit_procdff_3199 = 4'b0000;
    UUT.or1200_ctrl._witness_.anyinit_procdff_3202 = 3'b000;
    UUT.or1200_ctrl._witness_.anyinit_procdff_3205 = 3'b000;
    UUT.or1200_ctrl._witness_.anyinit_procdff_3208 = 4'b0000;
    UUT.or1200_ctrl._witness_.anyinit_procdff_3211 = 3'b000;
    UUT.or1200_ctrl._witness_.anyinit_procdff_3214 = 1'b0;
    UUT.or1200_ctrl._witness_.anyinit_procdff_3217 = 1'b0;
    UUT.or1200_ctrl._witness_.anyinit_procdff_3220 = 4'b0000;
    UUT.or1200_ctrl._witness_.anyinit_procdff_3223 = 5'b00000;
    UUT.or1200_ctrl._witness_.anyinit_procdff_3226 = 1'b0;
    UUT.or1200_ctrl._witness_.anyinit_procdff_3229 = 1'b0;
    UUT.or1200_ctrl._witness_.anyinit_procdff_3232 = 32'b00000000000000000000000000000000;
    UUT.or1200_ctrl._witness_.anyinit_procdff_3235 = 32'b00000000000000000000000000000000;
    UUT.or1200_ctrl._witness_.anyinit_procdff_3238 = 32'b00000000000000000000000000000000;
    UUT.or1200_ctrl._witness_.anyinit_procdff_3241 = 6'b000000;
    UUT.or1200_ctrl._witness_.anyinit_procdff_3244 = 5'b00000;
    UUT.or1200_ctrl._witness_.anyinit_procdff_3247 = 5'b00000;
    UUT.or1200_ctrl._witness_.anyinit_procdff_3250 = 1'b0;
    UUT.or1200_ctrl._witness_.anyinit_procdff_3253 = 30'b000000000000000000000000000000;
    UUT.or1200_ctrl._witness_.anyinit_procdff_3256 = 32'b00000000000000000000000000000000;
    UUT.or1200_ctrl.syscall_prev = 1'b0;
    UUT.or1200_ctrl.syscall_prev_prev = 1'b0;
    UUT.or1200_except._witness_.anyinit_procdff_3039 = 4'b0000;
    UUT.or1200_except._witness_.anyinit_procdff_3042 = 1'b0;
    UUT.or1200_except._witness_.anyinit_procdff_3045 = 32'b00000000000000000000000000000000;
    UUT.or1200_except._witness_.anyinit_procdff_3048 = 32'b00000000000000000000000000000000;
    UUT.or1200_except._witness_.anyinit_procdff_3051 = 17'b00000000000000000;
    UUT.or1200_except._witness_.anyinit_procdff_3054 = 32'b00000000000000000000000000000000;
    UUT.or1200_except._witness_.anyinit_procdff_3057 = 32'b00000000000000000000000000000000;
    UUT.or1200_except._witness_.anyinit_procdff_3060 = 17'b00000000000000000;
    UUT.or1200_except._witness_.anyinit_procdff_3063 = 3'b000;
    UUT.or1200_except._witness_.anyinit_procdff_3069 = 32'b00000000000000000000000000000000;
    UUT.or1200_except._witness_.anyinit_procdff_3072 = 32'b00000000000000000000000000000000;
    UUT.or1200_except._witness_.anyinit_procdff_3075 = 32'b00000000000000000000000000000000;
    UUT.or1200_except._witness_.anyinit_procdff_3078 = 1'b0;
    UUT.or1200_except._witness_.anyinit_procdff_3081 = 3'b000;
    UUT.or1200_except._witness_.anyinit_procdff_3084 = 1'b0;
    UUT.or1200_except._witness_.anyinit_procdff_3087 = 1'b0;
    UUT.or1200_except._witness_.anyinit_procdff_3093 = 3'b000;
    UUT.or1200_except._witness_.anyinit_procdff_3096 = 3'b000;
    UUT.or1200_except._witness_.anyinit_procdff_3099 = 32'b00000000000000000000000000000000;
    UUT.or1200_except._witness_.anyinit_procdff_3102 = 1'b0;
    UUT.or1200_except._witness_.anyinit_procdff_3105 = 3'b000;
    UUT.or1200_except._witness_.anyinit_procdff_3108 = 1'b0;
    UUT.or1200_except._witness_.anyinit_procdff_3111 = 1'b0;
    UUT.or1200_except._witness_.anyinit_procdff_3114 = 1'b0;
    UUT.or1200_except._witness_.anyinit_procdff_3117 = 1'b0;
    UUT.or1200_except._witness_.anyinit_procdff_3120 = 1'b0;
    UUT.or1200_except._witness_.anyinit_procdff_3123 = 1'b0;
    UUT.or1200_except.spr_dat_npc = 32'b00000000000000000000000000000000;
    UUT.or1200_except.spr_dat_ppc = 32'b10000000000000000000000000000000;
    UUT.or1200_freeze._witness_.anyinit_procdff_3030 = 2'b00;
    UUT.or1200_freeze._witness_.anyinit_procdff_3033 = 3'b000;
    UUT.or1200_freeze._witness_.anyinit_procdff_3036 = 1'b0;
    UUT.or1200_genpc._witness_.anyinit_procdff_3156 = 30'b000000000000000000000000000000;
    UUT.or1200_genpc._witness_.anyinit_procdff_3159 = 1'b0;
    UUT.or1200_genpc._witness_.anyinit_procdff_3165 = 1'b0;
    UUT.or1200_if._witness_.anyinit_procdff_3168 = 3'b000;
    UUT.or1200_if._witness_.anyinit_procdff_3171 = 32'b00000000000000000000000000000000;
    UUT.or1200_if._witness_.anyinit_procdff_3174 = 32'b00000000000000000000000000000000;
    UUT.or1200_if._witness_.anyinit_procdff_3177 = 1'b0;
    UUT.or1200_if._witness_.anyinit_procdff_3180 = 1'b0;
    UUT.or1200_lsu._witness_.anyinit_procdff_3348 = 1'b0;
    UUT.or1200_lsu._witness_.anyinit_procdff_3351 = 3'b000;
    UUT.or1200_lsu._witness_.anyinit_procdff_3354 = 4'b0000;
    UUT.or1200_mult_mac._witness_.anyinit_procdff_3282 = 1'b0;
    UUT.or1200_mult_mac._witness_.anyinit_procdff_3285 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    UUT.or1200_mult_mac._witness_.anyinit_procdff_3288 = 6'b000000;
    UUT.or1200_mult_mac._witness_.anyinit_procdff_3291 = 1'b0;
    UUT.or1200_mult_mac._witness_.anyinit_procdff_3294 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    UUT.or1200_mult_mac._witness_.anyinit_procdff_3297 = 3'b000;
    UUT.or1200_mult_mac._witness_.anyinit_procdff_3300 = 3'b000;
    UUT.or1200_mult_mac._witness_.anyinit_procdff_3303 = 3'b000;
    UUT.or1200_mult_mac._witness_.anyinit_procdff_3306 = 2'b00;
    UUT.or1200_mult_mac._witness_.anyinit_procdff_3309 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    UUT.or1200_mult_mac._witness_.anyinit_procdff_3312 = 1'b0;
    UUT.or1200_mult_mac.or1200_gmultp2_32x32._witness_.anyinit_procdff_3146 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    UUT.or1200_mult_mac.or1200_gmultp2_32x32._witness_.anyinit_procdff_3149 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    UUT.or1200_operandmuxes._witness_.anyinit_procdff_3270 = 32'b00000000000000000000000000000000;
    UUT.or1200_operandmuxes._witness_.anyinit_procdff_3273 = 1'b0;
    UUT.or1200_operandmuxes._witness_.anyinit_procdff_3276 = 32'b00000000000000000000000000000000;
    UUT.or1200_operandmuxes._witness_.anyinit_procdff_3279 = 1'b0;
    UUT.or1200_rf._witness_.anyinit_procdff_3265 = 1'b0;
    UUT.or1200_rf.addra_last = 5'b00000;
    UUT.or1200_rf.rf_a.addr_a_reg = 5'b00000;
    UUT.or1200_rf.rf_b.addr_a_reg = 5'b00000;
    UUT.or1200_rf.spr_du_cs = 1'b0;
    UUT.or1200_sprs._witness_.anyinit_procdff_3315 = 1'b0;
    UUT.or1200_sprs._witness_.anyinit_procdff_3318 = 1'b0;
    UUT.or1200_sprs._witness_.anyinit_procdff_3321 = 17'b00000000000000000;
    UUT.or1200_sprs._witness_.anyinit_procdff_3324 = 1'b0;
    UUT.or1200_sprs._witness_.anyinit_procdff_3327 = 32'b00000000000000000000000000000000;
    UUT.or1200_sprs._witness_.anyinit_procdff_3330 = 32'b00000000000000000000000000000000;
    UUT.or1200_sprs._witness_.anyinit_procdff_3333 = 32'b00000000000000000000000000000000;
    UUT.or1200_sprs._witness_.anyinit_procdff_3336 = 32'b00000000000000000000000000000000;
    UUT.or1200_sprs._witness_.anyinit_procdff_3339 = 32'b00000000000000000000000000000000;
    UUT.or1200_sprs._witness_.anyinit_procdff_3342 = 32'b00000000000000000000000000000000;
    UUT.or1200_sprs._witness_.anyinit_procdff_3345 = 32'b00000000000000000000000000000000;
    UUT.or1200_wbmux._witness_.anyinit_procdff_3357 = 32'b00000000000000000000000000000000;
    UUT.or1200_wbmux._witness_.anyinit_procdff_3360 = 1'b0;
    UUT.sp_assertion_violated_reg = 1'b0;
    UUT.sp_assertions_violated_reg = 32'b00000000000000000000000000000000;
    UUT.sp_exception_hold = 1'b0;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3634  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3640  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3646  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3652  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3658  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3664  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3670  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3676  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3682  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3688  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3694  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3700  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3706  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3712  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3718  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3724  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3730  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3736  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3742  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3748  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3754  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3760  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3766  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3772  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3778  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3784  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3790  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3796  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3802  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3808  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3814  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3820  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3826  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3832  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3838  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3844  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3850  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3856  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3862  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3868  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3874  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3880  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3886  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3892  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3898  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3904  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3910  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3916  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3922  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3928  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3934  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3940  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3946  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3952  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3958  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3964  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3970  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3976  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3982  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3988  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$3994  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$4000  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$4006  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$4012  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$4018  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$4024  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$4030  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$4036  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$4042  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$4048  = 1'b1;
    // UUT.u_assertions.$auto$async2sync.\cc:116:execute$4054  = 1'b1;
    UUT.u_assertions.init_done = 1'b0;
    UUT.u_assertions.prev_eear = 32'b10000000000000000000000000000000;
    UUT.u_assertions.prev_epcr = 32'b10000000000000000000000000000000;
    UUT.u_assertions.prev_esr = 17'b10000000000000000;
    UUT.u_assertions.prev_ex_insn = 32'b00000000000000000000000000000000;
    UUT.u_assertions.prev_id_freeze = 1'b0;
    UUT.u_assertions.prev_if_insn = 32'b00000000000000000000000000000000;
    UUT.u_assertions.prev_sr0 = 1'b1;
    UUT.or1200_cfgr.$auto$proc_rom.\cc:155:do_switch$1975 [3'b000] = 32'b00010010000000000000000000001000;
    UUT.or1200_ctrl.$auto$proc_rom.\cc:155:do_switch$1979 [6'b000101] = 4'b0000;
    UUT.or1200_ctrl.$auto$proc_rom.\cc:155:do_switch$1983 [6'b000101] = 1'b0;
    UUT.or1200_lsu.$auto$proc_rom.\cc:155:do_switch$1991 [6'b000000] = 4'b0000;
    UUT.or1200_rf.rf_a.mem[5'b00000] = 32'b00000000000000000000000000000000;
    UUT.or1200_rf.rf_b.mem[5'b00000] = 32'b00000000000000000000000000000000;
    UUT.or1200_sprs.$auto$proc_rom.\cc:155:do_switch$1987 [5'b00000] = 32'b00000000000000000000000000000001;

    // state 0
    PI_spr_dat_dmmu = 32'b00000000000000000000000000000000;
    PI_spr_dat_immu = 32'b00000000000000000000000000000000;
    PI_icpu_tag_i = 4'b0000;
    PI_du_stall = 1'b0;
    PI_du_read = 1'b0;
    PI_spr_dat_pm = 32'b00000000000000000000000000000000;
    PI_sig_tick = 1'b0;
    PI_dcpu_rty_i = 1'b0;
    PI_icpu_err_i = 1'b0;
    PI_du_hwbkpt_ls_r = 1'b0;
    PI_immu_uxe = 1'b0;
    PI_rst = 1'b1;
    PI_icpu_ack_i = 1'b0;
    PI_immu_sxe = 1'b0;
    PI_spr_dat_du = 32'b00000000000000000000000000000000;
    PI_spr_dat_pic = 32'b00000000000000000000000000000000;
    PI_icpu_adr_i = 32'b00000000000000000000000000000000;
    PI_dcpu_ack_i = 1'b0;
    PI_du_hwbkpt = 1'b0;
    PI_du_dsr = 14'b00000000000000;
    PI_du_dat_du = 32'b00000000000000000000000000000000;
    PI_du_dmr1 = 25'b0000000000000000000000000;
    PI_du_addr = 32'b00000000000000000000000000000000;
    PI_dcpu_dat_i = 32'b00000000000000000000000000000000;
    PI_dcpu_tag_i = 4'b0000;
    PI_icpu_rty_i = 1'b0;
    PI_du_write = 1'b0;
    PI_sig_int = 1'b0;
    PI_dcpu_err_i = 1'b0;
    PI_icpu_dat_i = 32'b00000000000000000000000000000000;
    PI_boot_adr_sel_i = 1'b0;
    PI_spr_dat_tt = 32'b00000000000000000000000000000000;
    PI_mtspr_dc_done = 1'b0;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_spr_dat_dmmu <= 32'b00000000000000000000000000000000;
      PI_spr_dat_immu <= 32'b00000000000000000000000000000000;
      PI_icpu_tag_i <= 4'b0000;
      PI_du_stall <= 1'b0;
      PI_du_read <= 1'b0;
      PI_spr_dat_pm <= 32'b00000000000000000000000000000000;
      PI_sig_tick <= 1'b0;
      PI_dcpu_rty_i <= 1'b0;
      PI_icpu_err_i <= 1'b0;
      PI_du_hwbkpt_ls_r <= 1'b0;
      PI_immu_uxe <= 1'b0;
      PI_rst <= 1'b0;
      PI_icpu_ack_i <= 1'b1;
      PI_immu_sxe <= 1'b0;
      PI_spr_dat_du <= 32'b00000000000000000000000000000000;
      PI_spr_dat_pic <= 32'b00000000000000000000000000000000;
      PI_icpu_adr_i <= 32'b00000000000000000000000000000000;
      PI_dcpu_ack_i <= 1'b0;
      PI_du_hwbkpt <= 1'b0;
      PI_du_dsr <= 14'b00000000000000;
      PI_du_dat_du <= 32'b00000000000000000000000000000000;
      PI_du_dmr1 <= 25'b0000000000000000000000000;
      PI_du_addr <= 32'b00000000000000000000000000000000;
      PI_dcpu_dat_i <= 32'b00000000000000000000000000000000;
      PI_dcpu_tag_i <= 4'b0000;
      PI_icpu_rty_i <= 1'b0;
      PI_du_write <= 1'b0;
      PI_sig_int <= 1'b0;
      PI_dcpu_err_i <= 1'b0;
      PI_icpu_dat_i <= 32'b00010100011000010000000000000001;
      PI_boot_adr_sel_i <= 1'b0;
      PI_spr_dat_tt <= 32'b00000000000000000000000000000000;
      PI_mtspr_dc_done <= 1'b0;
    end

    // state 2
    if (cycle == 1) begin
      PI_spr_dat_dmmu <= 32'b00000000000000000000000000000000;
      PI_spr_dat_immu <= 32'b00000000000000000000000000000000;
      PI_icpu_tag_i <= 4'b0000;
      PI_du_stall <= 1'b0;
      PI_du_read <= 1'b0;
      PI_spr_dat_pm <= 32'b00000000000000000000000000000000;
      PI_sig_tick <= 1'b0;
      PI_dcpu_rty_i <= 1'b0;
      PI_icpu_err_i <= 1'b0;
      PI_du_hwbkpt_ls_r <= 1'b0;
      PI_immu_uxe <= 1'b0;
      PI_rst <= 1'b0;
      PI_icpu_ack_i <= 1'b0;
      PI_immu_sxe <= 1'b0;
      PI_spr_dat_du <= 32'b00000000000000000000000000000000;
      PI_spr_dat_pic <= 32'b00000000000000000000000000000000;
      PI_icpu_adr_i <= 32'b00000000000000000000000000000000;
      PI_dcpu_ack_i <= 1'b0;
      PI_du_hwbkpt <= 1'b0;
      PI_du_dsr <= 14'b00000000000000;
      PI_du_dat_du <= 32'b00000000000000000000000000000000;
      PI_du_dmr1 <= 25'b0000000000000000000000000;
      PI_du_addr <= 32'b00000000000000000000000000000000;
      PI_dcpu_dat_i <= 32'b00000000000000000000000000000000;
      PI_dcpu_tag_i <= 4'b0000;
      PI_icpu_rty_i <= 1'b0;
      PI_du_write <= 1'b0;
      PI_sig_int <= 1'b0;
      PI_dcpu_err_i <= 1'b0;
      PI_icpu_dat_i <= 32'b00000000000000000000000000000000;
      PI_boot_adr_sel_i <= 1'b0;
      PI_spr_dat_tt <= 32'b00000000000000000000000000000000;
      PI_mtspr_dc_done <= 1'b0;
    end

    genclock <= cycle < 2;
    cycle <= cycle + 1;
  end
endmodule
