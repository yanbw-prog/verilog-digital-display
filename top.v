// top.v
// 顶层模块：4位动态数码管显示系统
// 作者：严博文
// 功能：将16位输入数据显示在4位七段数码管上

module top (
    input  wire        clk,    // 系统时钟（50MHz）
    input  wire        rst_n,  // 异步复位（低有效）
    input  wire [15:0] data,   // 待显示数据（BCD格式，每4位一个十进制位）
    output wire [3:0]  sel,    // 数码管位选（低有效）
    output wire [6:0]  seg     // 段选信号（低有效，abcdefg）
);

    wire [1:0] digit_sel;
    wire [3:0] digit_data;

    // 扫描控制模块
    scan_ctrl u_scan (
        .clk       (clk),
        .rst_n     (rst_n),
        .digit_sel (digit_sel)
    );

    // 数据选择：根据当前扫描位选择对应BCD码
    assign digit_data = (digit_sel == 2'd0) ? data[3:0]   :
                        (digit_sel == 2'd1) ? data[7:4]   :
                        (digit_sel == 2'd2) ? data[11:8]  :
                                              data[15:12] ;

    // 位选译码（低有效）
    assign sel = (digit_sel == 2'd0) ? 4'b1110 :
                 (digit_sel == 2'd1) ? 4'b1101 :
                 (digit_sel == 2'd2) ? 4'b1011 :
                                      4'b0111 ;

    // 段码译码模块
    seg_decoder u_dec (
        .bcd (digit_data),
        .seg (seg)
    );

endmodule
