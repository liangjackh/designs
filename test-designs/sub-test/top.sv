// top.sv
`include "defines.sv"

module top (
    input  wire                   clk,
    input  wire                   rst_n,
    input  wire [`DATA_WIDTH-1:0] top_in,
    output wire [`DATA_WIDTH-1:0] top_out
);

    // top 中的 wire 进行连接
    wire [`DATA_WIDTH-1:0] wire_a_to_b;

    // 实例化 module_a
    module_a u_a (
        .clk   (clk),
        .rst_n (rst_n),
        .in_a  (top_in),
        .out_a (wire_a_to_b)
    );

    // 实例化 module_b
    module_b u_b (
        .clk       (clk),
        .rst_n     (rst_n),
        .in_b      (wire_a_to_b),   // a 的输出是 b 的输入
        .orig_in_a (top_in),        // 将 a 的输入同时引给 b 进行判断
        .out_b     (top_out)
    );

    // 实例化断言模块
    my_assertions u_assert (
        .clk      (clk),
        .rst_n    (rst_n),
        .top_in_a (top_in),
        .a_out    (wire_a_to_b),
        .b_out    (top_out)
    );

endmodule
