// --- 子模块 A ---
module sub_a (
    input clk,
    input [7:0] data_in
);
    reg [7:0] internal_reg; // 内部寄存器，无输出端口
    always @(posedge clk) internal_reg <= data_in;
endmodule

// --- 子模块 B ---
module sub_b (
    input clk,
    input [7:0] data_in
);
    reg [7:0] internal_reg; // 内部寄存器，无输出端口
    always @(posedge clk) internal_reg <= data_in;
endmodule

module sub_c(
    input clk,
    input [7:0] data_in
);
    reg [7:0] internal_reg; // 内部寄存器，无输出端口
    always @(posedge clk) internal_reg <= data_in+5;
endmodule

// --- 顶层模块 ---
module top (
    input clk,
    input rst,
    input [7:0] data_in
);
    // 实例化两个子模块
    sub_a u_a (.clk(clk), .data_in(data_in));
    sub_b u_b (.clk(clk), .data_in(data_in));
    sub_c u_c (.clk(clk), .data_in(data_in));

    `ifdef FORMAL
        // 使用标准的 always 块和即时断言，替代 LTL 属性
        always @(posedge clk) begin
            // 等价于 disable iff (rst)
            if (!rst) begin
                // 等价于 (data_in == 8'hFF) |-> (u_a == u_b)
                // 传统的 if 判断在 SMT 求解器中会直接转换为蕴含逻辑
                if (data_in == 8'hFF) begin
                    // 跨模块探针访问：直接读取子模块内部的 reg
                    check_cross_module: assert (u_a.internal_reg == u_b.internal_reg);
                end
            end
        end
    `endif
endmodule