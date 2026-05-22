// module_a.sv
`include "defines.sv"


module module_a (
    input  wire                   clk,
    input  wire                   rst_n,
    input  wire [`DATA_WIDTH-1:0] in_a,
    output wire [`DATA_WIDTH-1:0] out_a
);
    // 9 级数据流水线
    reg [`DATA_WIDTH-1:0] pipe [0:8];
    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 2; i = i + 1) begin
                pipe[i] <= {`DATA_WIDTH{1'b0}};
            end
        end else begin
            // 第 0 级：简单加法
            pipe[0] <= in_a + 1'b1;
            pipe[1] <= pipe[0];
        end
    end

    // 输出最后一级
    assign out_a = pipe[1];

endmodule

//module module_a (
//    input  wire                   clk,
//    input  wire                   rst_n,
//    input  wire [`DATA_WIDTH-1:0] in_a,
//    output reg  [`DATA_WIDTH-1:0] out_a
//);
//    always @(posedge clk or negedge rst_n) begin
//        if (!rst_n) begin
//            out_a <= {`DATA_WIDTH{1'b0}};
//        end else begin
//            out_a <= in_a + 1'b1; // 简单的加法逻辑
//        end
//    end
//
//endmodule
//