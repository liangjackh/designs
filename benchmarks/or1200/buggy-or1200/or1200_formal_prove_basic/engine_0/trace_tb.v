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
  reg [30:0] PI_pic_ints_i;
  reg [0:0] PI_dbg_stall_i;
  reg [31:0] PI_dwb_dat_i;
  reg [0:0] PI_iwb_rst_i;
  reg [0:0] PI_iwb_err_i;
  reg [0:0] PI_dbg_we_i;
  reg [0:0] PI_dwb_clk_i;
  reg [0:0] PI_rst_i;
  reg [0:0] PI_dwb_rty_i;
  reg [0:0] PI_dbg_stb_i;
  reg [0:0] PI_iwb_clk_i;
  reg [1:0] PI_clmode_i;
  reg [0:0] PI_dwb_rst_i;
  reg [0:0] PI_clk_i;
  reg [0:0] PI_iwb_rty_i;
  reg [0:0] PI_dwb_ack_i;
  reg [0:0] PI_pm_cpustall_i;
  reg [0:0] PI_dbg_ewt_i;
  reg [0:0] PI_iwb_ack_i;
  reg [31:0] PI_iwb_dat_i;
  reg [31:0] PI_dbg_adr_i;
  reg [0:0] PI_dwb_err_i;
  reg [31:0] PI_dbg_dat_i;
  or1200_top UUT (
    .pic_ints_i(PI_pic_ints_i),
    .dbg_stall_i(PI_dbg_stall_i),
    .dwb_dat_i(PI_dwb_dat_i),
    .iwb_rst_i(PI_iwb_rst_i),
    .iwb_err_i(PI_iwb_err_i),
    .dbg_we_i(PI_dbg_we_i),
    .dwb_clk_i(PI_dwb_clk_i),
    .rst_i(PI_rst_i),
    .dwb_rty_i(PI_dwb_rty_i),
    .dbg_stb_i(PI_dbg_stb_i),
    .iwb_clk_i(PI_iwb_clk_i),
    .clmode_i(PI_clmode_i),
    .dwb_rst_i(PI_dwb_rst_i),
    .clk_i(PI_clk_i),
    .iwb_rty_i(PI_iwb_rty_i),
    .dwb_ack_i(PI_dwb_ack_i),
    .pm_cpustall_i(PI_pm_cpustall_i),
    .dbg_ewt_i(PI_dbg_ewt_i),
    .iwb_ack_i(PI_iwb_ack_i),
    .iwb_dat_i(PI_iwb_dat_i),
    .dbg_adr_i(PI_dbg_adr_i),
    .dwb_err_i(PI_dwb_err_i),
    .dbg_dat_i(PI_dbg_dat_i)
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
    UUT.dwb_biu._witness_.anyinit_procdff_5105 = 1'b0;
    UUT.dwb_biu._witness_.anyinit_procdff_5108 = 1'b0;
    UUT.dwb_biu._witness_.anyinit_procdff_5111 = 1'b0;
    UUT.dwb_biu._witness_.anyinit_procdff_5117 = 1'b0;
    UUT.dwb_biu._witness_.anyinit_procdff_5120 = 1'b0;
    UUT.dwb_biu._witness_.anyinit_procdff_5126 = 1'b0;
    UUT.dwb_biu._witness_.anyinit_procdff_5129 = 32'b00000000000000000000000000000000;
    UUT.dwb_biu._witness_.anyinit_procdff_5132 = 1'b0;
    UUT.dwb_biu._witness_.anyinit_procdff_5135 = 1'b0;
    UUT.dwb_biu._witness_.anyinit_procdff_5138 = 4'b0000;
    UUT.dwb_biu._witness_.anyinit_procdff_5141 = 32'b00000000000000000000000000000000;
    UUT.dwb_biu._witness_.anyinit_procdff_5144 = 3'b000;
    UUT.dwb_biu._witness_.anyinit_procdff_5147 = 2'b00;
    UUT.dwb_biu._witness_.anyinit_procdff_5150 = 4'b0000;
    UUT.dwb_biu._witness_.anyinit_procdff_5153 = 2'b00;
    UUT.iwb_biu._witness_.anyinit_procdff_5105 = 1'b0;
    UUT.iwb_biu._witness_.anyinit_procdff_5108 = 1'b0;
    UUT.iwb_biu._witness_.anyinit_procdff_5111 = 1'b0;
    UUT.iwb_biu._witness_.anyinit_procdff_5117 = 1'b0;
    UUT.iwb_biu._witness_.anyinit_procdff_5120 = 1'b0;
    UUT.iwb_biu._witness_.anyinit_procdff_5126 = 1'b0;
    UUT.iwb_biu._witness_.anyinit_procdff_5129 = 32'b00000000000000000000000000000000;
    UUT.iwb_biu._witness_.anyinit_procdff_5132 = 1'b0;
    UUT.iwb_biu._witness_.anyinit_procdff_5135 = 1'b0;
    UUT.iwb_biu._witness_.anyinit_procdff_5138 = 4'b0000;
    UUT.iwb_biu._witness_.anyinit_procdff_5141 = 32'b00000000000000000000000000000000;
    UUT.iwb_biu._witness_.anyinit_procdff_5144 = 3'b000;
    UUT.iwb_biu._witness_.anyinit_procdff_5147 = 2'b00;
    UUT.iwb_biu._witness_.anyinit_procdff_5150 = 4'b0000;
    UUT.iwb_biu._witness_.anyinit_procdff_5153 = 2'b00;
    // UUT.or1200_assertions.$auto$async2sync.\cc:107:execute$5521  = 1'b0;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5525  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5531  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5537  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5543  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5549  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5555  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5561  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5567  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5573  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5579  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5585  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5591  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5597  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5603  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5609  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5615  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5621  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5627  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5633  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5639  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5645  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5651  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5657  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5663  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5669  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5675  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5681  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5687  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5693  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5699  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5705  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5711  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5717  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5723  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5729  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5735  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5741  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5747  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5753  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5759  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5765  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5771  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5777  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5783  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5789  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5795  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5801  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5807  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5813  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5819  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5825  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5831  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5837  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5843  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5849  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5855  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5861  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5867  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5873  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5879  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5885  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5891  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5897  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5903  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5909  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5915  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5921  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5927  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5933  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5939  = 1'b1;
    // UUT.or1200_assertions.$auto$async2sync.\cc:116:execute$5945  = 1'b1;
    UUT.or1200_assertions.prev_eear = 32'b10000000000000000000000000000000;
    UUT.or1200_assertions.prev_epcr = 32'b10000000000000000000000000000000;
    UUT.or1200_assertions.prev_esr = 17'b10000000000000000;
    UUT.or1200_assertions.prev_ex_insn = 32'b00000000000000000000000000000000;
    UUT.or1200_assertions.prev_id_freeze = 1'b0;
    UUT.or1200_assertions.prev_if_insn = 32'b10000000000000000000000000000000;
    UUT.or1200_assertions.prev_sr0 = 1'b1;
    UUT.or1200_cpu.or1200_ctrl._witness_.anyinit_procdff_4806 = 1'b0;
    UUT.or1200_cpu.or1200_ctrl._witness_.anyinit_procdff_4809 = 1'b0;
    UUT.or1200_cpu.or1200_ctrl._witness_.anyinit_procdff_4822 = 4'b0000;
    UUT.or1200_cpu.or1200_ctrl._witness_.anyinit_procdff_4825 = 3'b000;
    UUT.or1200_cpu.or1200_ctrl._witness_.anyinit_procdff_4828 = 3'b110;
    UUT.or1200_cpu.or1200_ctrl._witness_.anyinit_procdff_4831 = 4'b0000;
    UUT.or1200_cpu.or1200_ctrl._witness_.anyinit_procdff_4834 = 3'b100;
    UUT.or1200_cpu.or1200_ctrl._witness_.anyinit_procdff_4837 = 1'b0;
    UUT.or1200_cpu.or1200_ctrl._witness_.anyinit_procdff_4840 = 1'b0;
    UUT.or1200_cpu.or1200_ctrl._witness_.anyinit_procdff_4843 = 4'b0000;
    UUT.or1200_cpu.or1200_ctrl._witness_.anyinit_procdff_4846 = 5'b00000;
    UUT.or1200_cpu.or1200_ctrl._witness_.anyinit_procdff_4849 = 1'b0;
    UUT.or1200_cpu.or1200_ctrl._witness_.anyinit_procdff_4852 = 1'b0;
    UUT.or1200_cpu.or1200_ctrl._witness_.anyinit_procdff_4855 = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_ctrl._witness_.anyinit_procdff_4858 = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_ctrl._witness_.anyinit_procdff_4861 = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_ctrl._witness_.anyinit_procdff_4864 = 6'b000000;
    UUT.or1200_cpu.or1200_ctrl._witness_.anyinit_procdff_4867 = 5'b10000;
    UUT.or1200_cpu.or1200_ctrl._witness_.anyinit_procdff_4870 = 5'b10000;
    UUT.or1200_cpu.or1200_ctrl._witness_.anyinit_procdff_4873 = 1'b0;
    UUT.or1200_cpu.or1200_ctrl._witness_.anyinit_procdff_4876 = 30'b000000000000000000000000000000;
    UUT.or1200_cpu.or1200_ctrl._witness_.anyinit_procdff_4879 = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_ctrl.syscall_prev = 1'b0;
    UUT.or1200_cpu.or1200_ctrl.syscall_prev_prev = 1'b0;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_4995 = 4'b1000;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_4998 = 1'b0;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_5001 = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_5004 = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_5007 = 17'b00000000000000000;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_5010 = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_5013 = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_5016 = 17'b00000000000000000;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_5019 = 3'b100;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_5025 = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_5028 = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_5031 = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_5034 = 1'b0;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_5037 = 3'b000;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_5040 = 1'b0;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_5043 = 1'b0;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_5049 = 3'b000;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_5052 = 3'b000;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_5055 = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_5058 = 1'b0;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_5061 = 3'b000;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_5064 = 1'b0;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_5067 = 1'b0;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_5070 = 1'b0;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_5073 = 1'b0;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_5076 = 1'b0;
    UUT.or1200_cpu.or1200_except._witness_.anyinit_procdff_5079 = 1'b0;
    UUT.or1200_cpu.or1200_except.spr_dat_npc = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_except.spr_dat_ppc = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_freeze._witness_.anyinit_procdff_4986 = 2'b00;
    UUT.or1200_cpu.or1200_freeze._witness_.anyinit_procdff_4989 = 3'b100;
    UUT.or1200_cpu.or1200_freeze._witness_.anyinit_procdff_4992 = 1'b0;
    UUT.or1200_cpu.or1200_genpc._witness_.anyinit_procdff_4779 = 30'b111111111111111111111111111111;
    UUT.or1200_cpu.or1200_genpc._witness_.anyinit_procdff_4782 = 1'b0;
    UUT.or1200_cpu.or1200_genpc._witness_.anyinit_procdff_4788 = 1'b0;
    UUT.or1200_cpu.or1200_if._witness_.anyinit_procdff_4791 = 3'b000;
    UUT.or1200_cpu.or1200_if._witness_.anyinit_procdff_4794 = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_if._witness_.anyinit_procdff_4797 = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_if._witness_.anyinit_procdff_4800 = 1'b0;
    UUT.or1200_cpu.or1200_if._witness_.anyinit_procdff_4803 = 1'b0;
    UUT.or1200_cpu.or1200_lsu._witness_.anyinit_procdff_4971 = 1'b0;
    UUT.or1200_cpu.or1200_lsu._witness_.anyinit_procdff_4974 = 3'b000;
    UUT.or1200_cpu.or1200_lsu._witness_.anyinit_procdff_4977 = 4'b0000;
    UUT.or1200_cpu.or1200_mult_mac._witness_.anyinit_procdff_4905 = 1'b0;
    UUT.or1200_cpu.or1200_mult_mac._witness_.anyinit_procdff_4908 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    UUT.or1200_cpu.or1200_mult_mac._witness_.anyinit_procdff_4911 = 6'b000000;
    UUT.or1200_cpu.or1200_mult_mac._witness_.anyinit_procdff_4914 = 1'b0;
    UUT.or1200_cpu.or1200_mult_mac._witness_.anyinit_procdff_4917 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    UUT.or1200_cpu.or1200_mult_mac._witness_.anyinit_procdff_4920 = 3'b000;
    UUT.or1200_cpu.or1200_mult_mac._witness_.anyinit_procdff_4923 = 3'b000;
    UUT.or1200_cpu.or1200_mult_mac._witness_.anyinit_procdff_4926 = 3'b000;
    UUT.or1200_cpu.or1200_mult_mac._witness_.anyinit_procdff_4929 = 2'b00;
    UUT.or1200_cpu.or1200_mult_mac._witness_.anyinit_procdff_4932 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    UUT.or1200_cpu.or1200_mult_mac._witness_.anyinit_procdff_4935 = 1'b0;
    UUT.or1200_cpu.or1200_mult_mac.or1200_gmultp2_32x32._witness_.anyinit_procdff_4761 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    UUT.or1200_cpu.or1200_mult_mac.or1200_gmultp2_32x32._witness_.anyinit_procdff_4764 = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    UUT.or1200_cpu.or1200_operandmuxes._witness_.anyinit_procdff_4893 = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_operandmuxes._witness_.anyinit_procdff_4896 = 1'b0;
    UUT.or1200_cpu.or1200_operandmuxes._witness_.anyinit_procdff_4899 = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_operandmuxes._witness_.anyinit_procdff_4902 = 1'b0;
    UUT.or1200_cpu.or1200_rf._witness_.anyinit_procdff_4888 = 1'b0;
    UUT.or1200_cpu.or1200_rf.addra_last = 5'b00000;
    UUT.or1200_cpu.or1200_rf.rf_a.addr_a_reg = 5'b00000;
    UUT.or1200_cpu.or1200_rf.rf_b.addr_a_reg = 5'b00000;
    UUT.or1200_cpu.or1200_rf.spr_du_cs = 1'b0;
    UUT.or1200_cpu.or1200_sprs._witness_.anyinit_procdff_4938 = 1'b0;
    UUT.or1200_cpu.or1200_sprs._witness_.anyinit_procdff_4941 = 1'b0;
    UUT.or1200_cpu.or1200_sprs._witness_.anyinit_procdff_4944 = 17'b00000000000000000;
    UUT.or1200_cpu.or1200_sprs._witness_.anyinit_procdff_4947 = 1'b0;
    UUT.or1200_cpu.or1200_sprs._witness_.anyinit_procdff_4950 = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_sprs._witness_.anyinit_procdff_4953 = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_sprs._witness_.anyinit_procdff_4956 = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_sprs._witness_.anyinit_procdff_4959 = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_sprs._witness_.anyinit_procdff_4962 = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_sprs._witness_.anyinit_procdff_4965 = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_sprs._witness_.anyinit_procdff_4968 = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_wbmux._witness_.anyinit_procdff_4980 = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_wbmux._witness_.anyinit_procdff_4983 = 1'b0;
    UUT.or1200_cpu.sp_assertion_violated_reg = 1'b0;
    UUT.or1200_cpu.sp_assertions_violated_reg = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.sp_exception_hold = 1'b0;
    UUT.or1200_dmmu_top._witness_.anyinit_procdff_5193 = 1'b0;
    UUT.or1200_dmmu_top.or1200_dmmu_tlb.dtlb_ram.addr_reg = 6'b000000;
    UUT.or1200_dmmu_top.or1200_dmmu_tlb.dtlb_tr_ram.addr_reg = 6'b000000;
    UUT.or1200_du._witness_.anyinit_procdff_5199 = 14'b00000000000000;
    UUT.or1200_du._witness_.anyinit_procdff_5202 = 14'b00000000000000;
    UUT.or1200_du._witness_.anyinit_procdff_5205 = 25'b0000000000000000000000000;
    UUT.or1200_du._witness_.anyinit_procdff_5208 = 1'b0;
    UUT.or1200_du._witness_.anyinit_procdff_5213 = 1'b0;
    UUT.or1200_du._witness_.anyinit_procdff_5216 = 1'b0;
    UUT.or1200_du._witness_.anyinit_procdff_5219 = 2'b00;
    UUT.or1200_du.dbg_dat_o = 32'b00000000000000000000000000000000;
    UUT.or1200_du.ex_freeze_q = 1'b0;
    UUT.or1200_ic_top.or1200_ic_fsm._witness_.anyinit_procdff_5084 = 32'b00000000000000000000000000000000;
    UUT.or1200_ic_top.or1200_ic_fsm._witness_.anyinit_procdff_5087 = 2'b00;
    UUT.or1200_ic_top.or1200_ic_fsm._witness_.anyinit_procdff_5090 = 5'b00000;
    UUT.or1200_ic_top.or1200_ic_fsm._witness_.anyinit_procdff_5093 = 1'b0;
    UUT.or1200_ic_top.or1200_ic_fsm._witness_.anyinit_procdff_5096 = 1'b0;
    UUT.or1200_ic_top.or1200_ic_fsm._witness_.anyinit_procdff_5099 = 1'b0;
    UUT.or1200_ic_top.or1200_ic_fsm._witness_.anyinit_procdff_5102 = 1'b0;
    UUT.or1200_immu_top._witness_.anyinit_procdff_5156 = 32'b00000000000000000000000000000000;
    UUT.or1200_immu_top._witness_.anyinit_procdff_5159 = 1'b0;
    UUT.or1200_immu_top._witness_.anyinit_procdff_5162 = 1'b0;
    UUT.or1200_immu_top._witness_.anyinit_procdff_5165 = 1'b0;
    UUT.or1200_immu_top._witness_.anyinit_procdff_5168 = 19'b1000000000000000000;
    UUT.or1200_immu_top._witness_.anyinit_procdff_5171 = 32'b00000000000000000000000000000000;
    UUT.or1200_immu_top._witness_.anyinit_procdff_5174 = 1'b0;
    UUT.or1200_immu_top.or1200_immu_tlb.itlb_mr_ram.addr_reg = 6'b000000;
    UUT.or1200_immu_top.or1200_immu_tlb.itlb_tr_ram.addr_reg = 6'b000000;
    UUT.or1200_pic._witness_.anyinit_procdff_4738 = 31'b0000000000000000000000000000000;
    UUT.or1200_pic._witness_.anyinit_procdff_4741 = 29'b00000000000000000000000000000;
    UUT.or1200_tt._witness_.anyinit_procdff_4744 = 32'b00000000000000000000000000000000;
    UUT.or1200_tt._witness_.anyinit_procdff_4747 = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_cfgr.$auto$proc_rom.\cc:155:do_switch$3075 [3'b000] = 32'b00010010000000000000000000001000;
    UUT.or1200_cpu.or1200_ctrl.$auto$proc_rom.\cc:155:do_switch$3059 [6'b000000] = 4'b0000;
    UUT.or1200_cpu.or1200_ctrl.$auto$proc_rom.\cc:155:do_switch$3063 [6'b000101] = 1'b0;
    UUT.or1200_cpu.or1200_lsu.$auto$proc_rom.\cc:155:do_switch$3071 [6'b000000] = 4'b0000;
    UUT.or1200_cpu.or1200_rf.rf_a.mem[5'b00000] = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_rf.rf_b.mem[5'b00000] = 32'b00000000000000000000000000000000;
    UUT.or1200_cpu.or1200_sprs.$auto$proc_rom.\cc:155:do_switch$3067 [5'b00000] = 32'b00000000000000000000000000000001;
    UUT.or1200_dmmu_top.or1200_dmmu_tlb.dtlb_ram.mem[6'b000000] = 14'b00000000000000;
    UUT.or1200_dmmu_top.or1200_dmmu_tlb.dtlb_tr_ram.mem[6'b000000] = 24'b000000000000000000000000;
    UUT.or1200_immu_top.or1200_immu_tlb.itlb_mr_ram.mem[6'b000000] = 14'b00000000000000;
    UUT.or1200_immu_top.or1200_immu_tlb.itlb_tr_ram.mem[6'b000000] = 22'b0000000000000000000000;

    // state 0
    PI_pic_ints_i = 31'b0000000000000000000000000000000;
    PI_dbg_stall_i = 1'b0;
    PI_dwb_dat_i = 32'b00000000000000000000000000000000;
    PI_iwb_rst_i = 1'b0;
    PI_iwb_err_i = 1'b0;
    PI_dbg_we_i = 1'b0;
    PI_dwb_clk_i = 1'b0;
    PI_rst_i = 1'b0;
    PI_dwb_rty_i = 1'b0;
    PI_dbg_stb_i = 1'b0;
    PI_iwb_clk_i = 1'b0;
    PI_clmode_i = 2'b00;
    PI_dwb_rst_i = 1'b0;
    PI_clk_i = 1'b0;
    PI_iwb_rty_i = 1'b0;
    PI_dwb_ack_i = 1'b0;
    PI_pm_cpustall_i = 1'b0;
    PI_dbg_ewt_i = 1'b0;
    PI_iwb_ack_i = 1'b0;
    PI_iwb_dat_i = 32'b00000000000000000000000000000000;
    PI_dbg_adr_i = 32'b00000000000000000000000000000000;
    PI_dwb_err_i = 1'b0;
    PI_dbg_dat_i = 32'b00000000000000000000000000000000;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_pic_ints_i <= 31'b0000000000000000000000000000000;
      PI_dbg_stall_i <= 1'b1;
      PI_dwb_dat_i <= 32'b00000000000000000000000000000000;
      PI_iwb_rst_i <= 1'b0;
      PI_iwb_err_i <= 1'b0;
      PI_dbg_we_i <= 1'b0;
      PI_dwb_clk_i <= 1'b0;
      PI_rst_i <= 1'b0;
      PI_dwb_rty_i <= 1'b0;
      PI_dbg_stb_i <= 1'b0;
      PI_iwb_clk_i <= 1'b0;
      PI_clmode_i <= 2'b00;
      PI_dwb_rst_i <= 1'b0;
      PI_clk_i <= 1'b0;
      PI_iwb_rty_i <= 1'b0;
      PI_dwb_ack_i <= 1'b0;
      PI_pm_cpustall_i <= 1'b0;
      PI_dbg_ewt_i <= 1'b0;
      PI_iwb_ack_i <= 1'b0;
      PI_iwb_dat_i <= 32'b00000000000000000000000000000000;
      PI_dbg_adr_i <= 32'b00000000000000000000000000000000;
      PI_dwb_err_i <= 1'b0;
      PI_dbg_dat_i <= 32'b00000000000000000000000000000000;
    end

    genclock <= cycle < 1;
    cycle <= cycle + 1;
  end
endmodule
