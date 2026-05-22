# Makefile for simulating the 3-cycle pipeline bug counter-example

# 指定仿真工具
IVL = iverilog
VVP = vvp

# 编译选项：-g2012 用于开启 SystemVerilog 语法支持
IVLFLAGS = -g2012

# 列出所有的源文件 (注意依赖顺序，defines.sv 最好放最前面)
SRCS = defines.sv \
       module_c.sv \
       module_a.sv \
       module_b.sv \
       my_assertions.sv \
       top.sv \
       tb.sv

# 编译生成的执行文件名称
OUT = sim.out

# 默认目标：编译并运行
all: run

# 编译阶段
compile: $(SRCS)
	@echo "==> Compiling RTL and Testbench..."
	$(IVL) $(IVLFLAGS) -o $(OUT) $(SRCS)

# 运行阶段
run: compile
	@echo "==> Running Simulation..."
	$(VVP) $(OUT)

# 清理生成的文件
clean:
	@echo "==> Cleaning up..."
	rm -f $(OUT) *.vcd

.PHONY: all compile run clean
