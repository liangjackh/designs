// tb.sv
`timescale 1ns/1ps
`include "defines.sv"

module tb;
    reg  clk;
    reg  rst_n;
    reg  [`DATA_WIDTH-1:0] top_in;
    wire [`DATA_WIDTH-1:0] top_out;

    top u_top (
        .clk(clk), .rst_n(rst_n), .top_in(top_in), .top_out(top_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    initial begin
        rst_n = 0;
        top_in = 0;
        #20;
        rst_n = 1;

        // 步骤 1: 填满 3 级流水线 (正常数据 10)
        top_in <= 32'd10; 
        repeat(4) @(posedge clk); 
        
        // 步骤 2: 制造突变，触发 3 周期后的 Bug
        top_in <= 32'd300; 
        
        // 维持 2 个周期
        repeat(2) @(posedge clk);
        
        // 步骤 3: 恢复正常输入
        top_in <= 32'd10;

        // 等待流水线走完，捕获断言报错
        repeat(5) @(posedge clk);
        $finish;
    end
    
    // 监控输出以便查看
    initial begin
        $monitor("Time=%0t | top_in=%0d | top_out=%0d", $time, top_in, top_out);
    end
endmodule
