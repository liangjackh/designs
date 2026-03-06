// ---------------------------------------------------------
// 子模块 1: 简易加法器 (带溢出位扩展)
// ---------------------------------------------------------
module simple_adder #(parameter W = 8) (
    input  wire [W-1:0] in_a,
    input  wire [W-1:0] in_b,
    output wire [W:0]   out_sum // 扩展1位，防止 255+255 溢出
);
    assign out_sum = in_a + in_b;
endmodule

// ---------------------------------------------------------
// 子模块 2: 乘法器
// ---------------------------------------------------------
module basic_multiplier #(parameter WA = 8, parameter WB = 9) (
    input  wire [WA-1:0] in_a,
    input  wire [WB-1:0] in_b,
    output wire [WA+WB-1:0] out_prod
);
    assign out_prod = in_a * in_b;
endmodule

// ---------------------------------------------------------
// 顶层模块: 实现 A * (B + C) 及其形式化验证
// ---------------------------------------------------------
module dsp_top (
    input  wire       clk,
    input  wire       rst,
    input  wire [7:0] val_a,
    input  wire [7:0] val_b,
    input  wire [7:0] val_c
);
    // 内部寄存器打拍，模拟真实的同步数据通路
    reg [7:0] reg_a, reg_b, reg_c;
    
    always @(posedge clk) begin
        if (rst) begin
            reg_a <= 8'h0; reg_b <= 8'h0; reg_c <= 8'h0;
        end else begin
            reg_a <= val_a; reg_b <= val_b; reg_c <= val_c;
        end
    end

    // 内部连线
    wire [8:0]  sum_bc;         // 8bit + 8bit = 9bit
    wire [16:0] final_result;   // 8bit * 9bit = 17bit

    // 实例化：加法器计算 (B + C)
    simple_adder #(8) u_add (
        .in_a(reg_b),
        .in_b(reg_c),
        .out_sum(sum_bc)
    );

    // 实例化：乘法器计算 A * (B + C)
    basic_multiplier #(8, 9) u_mult (
        .in_a(reg_a),
        .in_b(sum_bc),
        .out_prod(final_result)
    );

    // =========================================================
    // 形式化验证属性 (Formal Properties)
    // =========================================================
    `ifdef FORMAL
        always @(posedge clk) begin
            if (!rst) begin
                // 验证属性 1: 乘法分配律 (结构等效性检查)
                // 检查 RTL 实例化的 A*(B+C) 是否在数学上绝对等于 A*B + A*C
                check_distributive_law: assert (
                    final_result == (reg_a * reg_b) + (reg_a * reg_c)
                );

                // 验证属性 2: 边界保护检查 (防止静默溢出)
                // 验证 17 位的 final_result 绝对不可能超出其理论数学上限
                // 255 * (255 + 255) = 130050, 而 17bit 最大值是 131071
                check_upper_bound: assert (
                    final_result <= 17'd130050
                );
            end
        end
    `endif

endmodule