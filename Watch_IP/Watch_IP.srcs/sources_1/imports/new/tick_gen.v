module tick_gen(
    clk,
    rst,
    i_en,
    i_tick,
    o_tick_gen,
    o_cnt
);
    // 변수 설정
    parameter P_DELAY_CNT = 2;   // 지연 길이 (클럭 사이클 수)
    parameter P_TIME_BIT = 6;   // 데이터 비트 폭
    parameter P_TIME_CNT = 60; 

    input clk;
    input rst;
    input i_en;
    input i_tick;
    output reg o_tick_gen;
    output  [P_TIME_BIT-1:0] o_cnt;


    reg [P_TIME_BIT-1:0] r_cnt;

    // r_cnt와 o_tick_gen 업데이트
    always @(posedge clk) begin
        if (rst) begin
            r_cnt      <= {P_TIME_BIT{1'b0}};
            o_tick_gen <= 1'b0;
        end else if (i_en & i_tick) begin
            if (r_cnt == P_TIME_CNT - 1) begin
                r_cnt      <= 0;
                o_tick_gen <= 1'b1;
            end else begin
                r_cnt <= r_cnt + 1'b1;
            end
        end else begin
            o_tick_gen <= 1'b0;
        end
    end

    // 지연 회로: P_DELAY_CNT 값에 따라 다르게 동작
    generate
        // P_DELAY_CNT가 2 이상인 경우 (다단계 지연)
        if (P_DELAY_CNT > 1) begin : gen_multiple_stages
            // 각 단계의 값을 저장할 배열 (각 요소의 폭은 P_TIME_BIT)
            reg [P_TIME_BIT-1:0] r_delay_multi [0:P_DELAY_CNT-1];
            integer i;
            
            always @(posedge clk) begin
                if (rst) begin
                    // 모든 단계 초기화
                    for (i = 0; i < P_DELAY_CNT; i = i + 1)
                        r_delay_multi[i] <= {P_TIME_BIT{1'b0}};
                end else begin
                    // 첫 번째 단계에 r_cnt 저장, 이후 단계는 이전 단계의 값을 전달
                    r_delay_multi[0] <= r_cnt;
                    for (i = 1; i < P_DELAY_CNT; i = i + 1)
                        r_delay_multi[i] <= r_delay_multi[i-1];
                end
            end
            
            assign o_cnt = r_delay_multi[P_DELAY_CNT-1];
            
        end
        // P_DELAY_CNT가 1인 경우: 단일 D-플립플롭으로 1 클럭 사이클 지연
        else if (P_DELAY_CNT == 1) begin : gen_single_stage
            reg [P_TIME_BIT-1:0] r_delay_single;
            always @(posedge clk) begin
                if (rst)
                    r_delay_single <= {P_TIME_BIT{1'b0}};
                else
                    r_delay_single <= r_cnt;
            end
            assign o_cnt = r_delay_single;
        end
        // P_DELAY_CNT가 0인 경우: 지연 없이 즉시 전달
        else begin : gen_no_stage
            assign o_cnt = r_cnt;
        end
    endgenerate

endmodule