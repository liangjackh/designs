// module_c.sv
`include "defines.sv"

module module_c (
    input  wire [`DATA_WIDTH-1:0] in_c,
    output wire [`DATA_WIDTH-1:0] out_c
);
    // 简单的左移逻辑作为示例
    assign out_c = in_c << 1;

endmodule