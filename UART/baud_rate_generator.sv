module baud_rate_generator #(
    parameter  clk_freq = 50_000_000, // 50 MHz
    parameter  baud_rate = 9600
) (
    input clk,rst,
    output logic tx_tick,rx_tick
);
 
    localparam integer BAUD_COUNTER_MAX_TX = clk_freq / baud_rate;
    localparam integer BAUD_COUNTER_MAX_RX = clk_freq / (baud_rate*16);
    localparam integer BAUD_COUNTER_WIDTH_TX = $clog2(BAUD_COUNTER_MAX_TX);
    localparam integer BAUD_COUNTER_WIDTH_RX = $clog2(BAUD_COUNTER_MAX_RX);

    logic [BAUD_COUNTER_WIDTH_TX-1:0] baud_counter_tx;
    logic [BAUD_COUNTER_WIDTH_RX-1:0] baud_counter_rx;

    always_ff @(posedge clk) begin
        if (rst) begin
            baud_counter_tx <= 0;
            tx_tick <= 0;
        end else if (baud_counter_tx == BAUD_COUNTER_MAX_TX - 1) begin
            baud_counter_tx <= 0;
            tx_tick <= 1;
        end else begin
            baud_counter_tx <= baud_counter_tx + 1;
            tx_tick <= 0;
        end
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            baud_counter_rx <= 0;
            rx_tick <= 0;
        end 
        else if (baud_counter_rx == BAUD_COUNTER_MAX_RX - 1) begin
            baud_counter_rx <= 0;
            rx_tick <= 1;
        end else begin
            baud_counter_rx <= baud_counter_rx + 1;
            rx_tick <= 0;
        end
    end 


    
endmodule