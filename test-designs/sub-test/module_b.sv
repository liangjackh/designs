// module_b.sv
`include "defines.sv"

module module_b (
    input  wire                   clk,
    input  wire                   rst_n,
    input  wire [`DATA_WIDTH-1:0] in_b,      // 经过了 2 拍延迟的数据
    input  wire [`DATA_WIDTH-1:0] orig_in_a, // 直接来自顶层，0 延迟的控制信号 (Bug 根源)
    output reg  [`DATA_WIDTH-1:0] out_b
);
    wire [`DATA_WIDTH-1:0] c_out;

    // 实例化 module_c
    module_c u_c (
        .in_c  (in_b),
        .out_c (c_out)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out_b <= {`DATA_WIDTH{1'b0}};
        end else begin
            // Bug: orig_in_a 是当前拍的信号，但 in_b 和 c_out 是两拍前的数据计算来的
            if (orig_in_a > `BRANCH_THRESHOLD) begin
                out_b <= c_out; 
            end else begin
                out_b <= in_b;
            end
        end
    end

endmodule