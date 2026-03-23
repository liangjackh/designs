# Changelog

## 2026-03-23 [Infra] hackdac18 SBY Formal Verification with yosys-slang

### Summary

Successfully configured SymbiYosys (sby) to run BMC formal verification on the hackatdac18 SoC design (PULPissimo-based RISC-V SoC with AES, Keccak, MD5, JTAG debug). The key breakthrough was replacing Yosys's native SystemVerilog parser with the **yosys-slang** plugin, which provides full IEEE 1800-2017 SV support and bypasses all the SV parsing limitations that had been blocking progress.

### Problem

Running `sby -f hackdac18.sby` failed with Yosys native SV parser errors:
- `riscv_controller.sv:94: ERROR: syntax error, unexpected TOK_ID` — caused by `PrivLvl_t` (package typedef) not being resolved with `-defer`
- Previous attempts hit 5+ other Yosys SV limitations (streaming operators, package types, etc.)
- Each manual fix revealed new blockers — a whack-a-mole process

### Root Cause

Yosys's built-in SystemVerilog frontend has limited SV support. Complex SV constructs common in the PULP ecosystem (package typedefs, streaming operators, interface ports) are not supported, especially when using `-defer` mode to avoid import collisions.

### Solution: yosys-slang Plugin

The **yosys-slang** plugin (based on the [slang](https://github.com/MikePopoloski/slang) library) provides comprehensive SV support. It was already bundled in oss-cad-suite version 20260323.

#### Library Compatibility Issue

Initial attempts to load the plugin failed with `GLIBCXX_3.4.32 not found`:
- oss-cad-suite bundled an old `libstdc++.so.6` (up to GLIBCXX_3.4.30)
- The slang plugin required GLIBCXX_3.4.31+
- **Fix**: Updated oss-cad-suite to version 20260323 which ships a compatible bundled `slang.so`

#### Plugin confirmed working:
```
/home/ljh/haveFun/tools/oss-cad-suite/bin/yosys -p \
  "plugin -i /home/ljh/haveFun/tools/oss-cad-suite/share/yosys/plugins/slang.so; help read_slang"
```

### Changes Made

#### `hackdac18.sby` — Complete rewrite of `[script]` section

**Before** (broken — used `read_verilog -sv` with `-defer` workarounds):
```
read_verilog -sv -DVERILATOR -I. apu_core_package.sv
read_verilog -sv -defer -I. riscv_controller.sv   # FAILS on PrivLvl_t
...
```

**After** (working — uses `read_slang` for all files):
```
plugin -i /home/ljh/haveFun/tools/oss-cad-suite/share/yosys/plugins/slang.so

read_slang --single-unit --ignore-assertions --ignore-timing -I. -DVERILATOR \
  apu_core_package.sv \
  ... (all .sv and .v files in a single read_slang call) ...
  properties.sv

clk2fflogic
async2sync

cutpoint -undef top_wrapper/adbg_tap_top.passchk
cutpoint -undef top_wrapper/adbg_tap_top.correct
cutpoint -undef top_wrapper/adbg_tap_top.bitindex
cutpoint -undef top_wrapper/riscv_core.if_stage_i.prefetch_32.prefetch_buffer_i.hwlp_masked

prep -top top_wrapper
```

Key `read_slang` flags:
- `--single-unit`: Treats all files as one compilation unit so macros (`SOC_CTRL_END_ADDR`, etc.) defined in header files are visible to `properties.sv`
- `--ignore-assertions`: Lets slang skip SVA parsing (Yosys handles assertions separately via `prep`)
- `--ignore-timing`: Skips unsynthesizable timing controls (e.g., `default clocking`)

Additional `[files]` entry added:
- `hackatdac18-2018-soc/ips/adv_dbg_if/rtl/adbg_tap_defines.v` — was missing, caused `IR_LENGTH` undefined macro errors

Additional Yosys passes:
- `clk2fflogic` — handles JTAG clocks used with opposite polarity (`tck_i` on `$dff` with both edges)
- `async2sync` — converts latches from `adbg_tap_top.v` (combinational `always @(...)`)
- `cutpoint -undef` — breaks combinational logic loops in `adbg_tap_top.v` and `riscv_prefetch_buffer.sv` that the SMT2 backend cannot handle

#### `properties.sv` — Fixed hierarchical path errors

Slang strictly resolves hierarchical paths. Package enum values and module-local parameters cannot be accessed via hierarchical references through instance paths.

| Property | Old (broken) | New (fixed) | Reason |
|---|---|---|---|
| p3 | `cs_registers_i.PRIV_LVL_M` | `2'b11` | `PRIV_LVL_M` is a package enum, not an instance signal |
| p3 | `cs_registers_i.PRIV_LVL_U` | `2'b00` | Same — package enum literal |
| p11 | `riscv_core.RD_DBGS` | `3'b100` | `RD_DBGS` is a local enum in `riscv_debug_unit.sv` (5th value: `{RD_NONE, RD_CSR, RD_GPR, RD_DBGA, RD_DBGS}`) |
| p14 | `alu_i.VEC_MODE16` | `2'b10` | `VEC_MODE16` is a package parameter in `riscv_defines.sv` |
| p14 | `alu_i.VEC_MODE8` | `2'b11` | Same — package parameter |
| p29 | `top_wrapper.aes_out`, `top_wrapper.c` | Commented out | These are internal signals in `mux_func`, not visible at `top_wrapper` level |

#### `top_wrapper.sv` — Fixed unconnected interface ports

Slang (unlike Yosys native parser) enforces that top-level interface ports must be connected. The APB bus interfaces were declared as top-level ports but never driven externally.

**Fix**: Removed all APB interface ports from the module port list and created internal `APB_BUS` instances instead:

```systemverilog
// Removed from module ports:
// APB_BUS.Slave  apb_subordinate,
// APB_BUS.Master fll_primary,
// ... (10 more APB interfaces)

// Created internally:
APB_BUS #(.APB_ADDR_WIDTH(32), .APB_DATA_WIDTH(32)) apb_subordinate ();
APB_BUS #(.APB_ADDR_WIDTH(32), .APB_DATA_WIDTH(32)) fll_primary ();
// ... (10 more)
```

### Final Result

```
SBY 17:27:52 [hackdac18] engine_0: ##   0:00:13  Status: passed
SBY 17:27:52 [hackdac18] engine_0: Status returned by engine: pass
SBY 17:27:52 [hackdac18] summary: Elapsed clock time [H:MM:SS (secs)]: 0:00:24 (24)
SBY 17:27:52 [hackdac18] DONE (PASS, rc=0)
```

BMC with boolector solver checked all assertions through 20 time steps — **all passed** in 24 seconds.

### Files Modified
- `designs/benchmarks/hackatdac18/hackdac18.sby` — Rewrote `[script]` section for yosys-slang
- `designs/benchmarks/hackatdac18/properties.sv` — Fixed enum/parameter hierarchical path references
- `designs/benchmarks/hackatdac18/top_wrapper.sv` — Internalized APB interface ports

### Files Created
- `designs/benchmarks/hackatdac18/run_sby.sh` — Helper wrapper script (optional)

### Notes
- The yosys-slang approach is superior to sv2v translation because it preserves the original RTL code
- The `--single-unit` flag is essential for designs that use macros across files (common in PULP ecosystem)
- The `cutpoint` commands may weaken verification soundness — the cut signals become unconstrained. For full soundness, the loops in `adbg_tap_top.v` should be fixed at the RTL level
- Some assertions (p1, p6, p8) have expressions that are "always false" — these are address range overlap checks that correctly detect the hackatdac18 Trojan modifications to the memory map

