// tb_top.v
// 仿真测试文件：4位动态数码管顶层模块测试

`timescale 1ns / 1ps

module tb_top;

    reg        clk;
    reg        rst_n;
    reg [15:0] data;

    wire [3:0] sel;
    wire [6:0] seg;

    // 实例化顶层模块
    top u_top (
        .clk   (clk),
        .rst_n (rst_n),
        .data  (data),
        .sel   (sel),
        .seg   (seg)
    );

    // 时钟生成：50MHz（周期20ns）
    initial clk = 0;
    always #10 clk = ~clk;

    // 测试激励
    initial begin
        rst_n = 0;
        data  = 16'h0000;
        #100;
        rst_n = 1;

        // 显示 1234
        data = 16'h4321; // data[15:12]=4, [11:8]=3, [7:4]=2, [3:0]=1
        #5000000;

        // 显示 5678
        data = 16'h8765;
        #5000000;

        // 显示 0000
        data = 16'h0000;
        #5000000;

        $finish;
    end

    // 波形输出
    initial begin
        $dumpfile("tb_top.vcd");
        $dumpvars(0, tb_top);
    end

endmodule
