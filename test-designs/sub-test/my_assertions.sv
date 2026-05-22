// my_assertions.sv
`include "defines.sv"

module my_assertions (
    input wire                   clk,
    input wire                   rst_n,
    
    input wire [`DATA_WIDTH-1:0] top_in_a,
    input wire [`DATA_WIDTH-1:0] a_out,
    input wire [`DATA_WIDTH-1:0] b_out
);

    //==========================================================================
    // 1. 历史状态记录器: 深度为 3
    //==========================================================================
    reg [`DATA_WIDTH-1:0] in_a_history [0:2];

    // 新增：有效信号延迟管道 (Pipeline Valid Tracker)
    // 用于确保复位后等待 3 个周期再开始进行断言检查
    reg [2:0] valid_pipe;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            in_a_history[0] <= {`DATA_WIDTH{1'b0}};
            in_a_history[1] <= {`DATA_WIDTH{1'b0}};
            in_a_history[2] <= {`DATA_WIDTH{1'b0}};
            
            // 复位时，有效信号清零
            valid_pipe <= 3'b000;
        end else begin
            in_a_history[0] <= top_in_a;
            in_a_history[1] <= in_a_history[0];
            in_a_history[2] <= in_a_history[1];
            
            // 每一个周期推入一个 1，经过 3 拍后 valid_pipe[2] 才会变成 1
            valid_pipe <= {valid_pipe[1:0], 1'b1};
        end
    end

    wire [`DATA_WIDTH-1:0] past_3_in_a = in_a_history[2];
    wire check_en = valid_pipe[2]; // 断言使能信号

    //==========================================================================
    // 2. 基础的即时断言
    //==========================================================================
    always @(posedge clk) begin
        // 只有当复位释放 且 流水线已经填满数据 (check_en == 1) 时，才执行检查
        if (rst_n && check_en) begin
            
            if (past_3_in_a <= `BRANCH_THRESHOLD) begin
                p_noshift_bug: assert (b_out == (past_3_in_a + 1));
            end
            
            //if (past_3_in_a > `BRANCH_THRESHOLD) begin
            //    p_shift_bug: assert (b_out == ((past_3_in_a + 1) << 1));
            //end
            
        end
    end

endmodule

//module my_assertions (
//    input wire                   clk,
//    input wire                   rst_n,
//    
//    input wire [`DATA_WIDTH-1:0] top_in_a,
//    input wire [`DATA_WIDTH-1:0] a_out,
//    input wire [`DATA_WIDTH-1:0] b_out
//);
//
//    //==========================================================================
//    // 历史状态记录器: 深度为 3
//    // 用来记住 3 个周期前的 top_in_a
//    //==========================================================================
//    reg [`DATA_WIDTH-1:0] in_a_history [0:2];
//
//    always @(posedge clk or negedge rst_n) begin
//        if (!rst_n) begin
//            in_a_history[0] <= {`DATA_WIDTH{1'b0}};
//            in_a_history[1] <= {`DATA_WIDTH{1'b0}};
//            in_a_history[2] <= {`DATA_WIDTH{1'b0}};
//        end else begin
//            in_a_history[0] <= top_in_a;
//            in_a_history[1] <= in_a_history[0];
//            in_a_history[2] <= in_a_history[1];
//        end
//    end
//
//    // past_3_in_a 就是 3 个时钟周期前的输入
//    wire [`DATA_WIDTH-1:0] past_3_in_a = in_a_history[2];
//
//    //==========================================================================
//    // 基础的即时断言 (对标 or1200_assertions.sv)
//    //==========================================================================
//    always @(posedge clk) begin
//        if (rst_n) begin
//            // 场景A: 如果 3 个周期前的输入 <= 阈值，那么当前的 b_out 应该不移位
//            if (past_3_in_a <= `BRANCH_THRESHOLD) begin
//                p_noshift_bug: assert (b_out == (past_3_in_a + 1));
//            end
//            
//            // 场景B: 如果 3 个周期前的输入 > 阈值，那么当前的 b_out 应该左移 1 位
//            //if (past_3_in_a > `BRANCH_THRESHOLD) begin
//            //    p_shift_bug: assert (b_out == ((past_3_in_a + 1) << 1));
//            //end
//        end
//    end
//
//endmodule
//

//module my_assertions (
//    input wire                   clk,
//    input wire                   rst_n,
//    
//    input wire [`DATA_WIDTH-1:0] top_in_a,
//    input wire [`DATA_WIDTH-1:0] a_out,
//    input wire [`DATA_WIDTH-1:0] b_out
//);
//
//    //==========================================================================
//    // 1. 历史状态记录器 (History Tracker)
//    // 为了代替 SVA 的 $past(top_in_a, 10)，我们手动构建一个 10 级深度的寄存器
//    // 用来记住 10 个周期前的 top_in_a 是多少。
//    //==========================================================================
//    reg [`DATA_WIDTH-1:0] in_a_history [0:9];
//    integer i;
//
//    always @(posedge clk or negedge rst_n) begin
//        if (!rst_n) begin
//            for (i = 0; i < 10; i = i + 1) begin
//                in_a_history[i] <= {`DATA_WIDTH{1'b0}};
//            end
//        end else begin
//            // 数据移位入队
//            in_a_history[0] <= top_in_a;
//            for (i = 1; i < 10; i = i + 1) begin
//                in_a_history[i] <= in_a_history[i-1];
//            end
//        end
//    end
//
//    // past_10_in_a 就是 10 个时钟周期前输入的 top_in_a
//    wire [`DATA_WIDTH-1:0] past_10_in_a = in_a_history[9];
//
//    //==========================================================================
//    // 2. 基础的即时断言 (Immediate Assertions)
//    // 格式完全对标你附件里的 or1200_assertions.sv ( pXX: assert (...); )
//    //==========================================================================
//    always @(posedge clk) begin
//        if (rst_n) begin
//            // 场景A: 如果 10 个周期前的输入 <= 阈值，那么当前的 b_out 应该不移位
//            if (past_10_in_a <= `BRANCH_THRESHOLD) begin
//                p_noshift_bug: assert (b_out == (past_10_in_a + 1));
//            end
//            
//            // 场景B: 如果 10 个周期前的输入 > 阈值，那么当前的 b_out 应该左移 1 位
//            //if (past_10_in_a > `BRANCH_THRESHOLD) begin
//            //    p_shift_bug: assert (b_out == ((past_10_in_a + 1) << 1));
//            //end
//        end
//    end
//
//    //==========================================================================
//    // 附：纯粹的 Verilog-2001 写法 (如果不使用 assert 关键字)
//    // 如果编译器连即时 assert 都不支持，可以直接用 $display + $error 打印
//    //==========================================================================
//    /*
//    always @(posedge clk) begin
//        if (rst_n) begin
//            if ((past_10_in_a <= `BRANCH_THRESHOLD) && (b_out != (past_10_in_a + 1))) begin
//                $display("BUG DETECTED [No-Shift]: Time=%0t, Expected=%0d, Got=%0d", $time, past_10_in_a + 1, b_out);
//            end
//            if ((past_10_in_a > `BRANCH_THRESHOLD) && (b_out != ((past_10_in_a + 1) << 1))) begin
//                $display("BUG DETECTED [Shift]: Time=%0t, Expected=%0d, Got=%0d", $time, (past_10_in_a + 1) << 1, b_out);
//            end
//        end
//    end
//    */
//
//endmodule
//