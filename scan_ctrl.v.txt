// scan_ctrl.v
// 扫描控制模块：产生动态扫描时钟与位选信号
// 扫描频率约为 50MHz / 50000 / 4 ≈ 250Hz（每位约4ms刷新）

module scan_ctrl (
    input  wire       clk,       // 系统时钟（50MHz）
    input  wire       rst_n,     // 异步复位（低有效）
    output reg  [1:0] digit_sel  // 当前扫描位（0~3）
);

    // 分频计数器：50MHz / 50000 = 1kHz扫描时钟
    parameter DIV_CNT = 16'd49999;

    reg [15:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 16'd0;
            digit_sel <= 2'd0;
        end else begin
            if (cnt == DIV_CNT) begin
                cnt       <= 16'd0;
                digit_sel <= digit_sel + 2'd1; // 自动溢出循环 0->1->2->3->0
            end else begin
                cnt <= cnt + 16'd1;
            end
        end
    end

endmodule
