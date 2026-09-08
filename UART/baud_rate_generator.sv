module baud_rate_generator #(
    parameter  clk_freq = 50_000_000, // 50 MHz
    parameter  baud_rate = 9600
) (
    input clk,rstn,
    output logic tx_en,rx_en
);
 
    localparam integer BAUD_COUNTER_MAX_TX = clk_freq / baud_rate;
    localparam integer BAUD_COUNTER_MAX_RX = clk_freq / (baud_rate*16);
    localparam integer BAUD_COUNTER_WIDTH_TX = $clog2(BAUD_COUNTER_MAX_TX);
    localparam integer BAUD_COUNTER_WIDTH_RX = $clog2(BAUD_COUNTER_MAX_RX);

    logic [BAUD_COUNTER_WIDTH_TX-1:0] baud_counter_tx;
    logic [BAUD_COUNTER_WIDTH_RX-1:0] baud_counter_rx;

    always_ff @(posedge clk) begin
        if (!rstn) begin
            baud_counter_tx <= 0;
            tx_en <= 0;
        end else if (baud_counter_tx == BAUD_COUNTER_MAX_TX - 1) begin
            baud_counter_tx <= 0;
            tx_en <= 1;
        end else begin
            baud_counter_tx <= baud_counter_tx + 1;
            tx_en <= 0;
        end
    end

    always_ff @(posedge clk) begin
        if (!rstn) begin
            baud_counter_rx <= 0;
            rx_en <= 0;
        end else begin
            baud_counter_rx <= baud_counter_rx + 1;
        end
        if (baud_counter_rx == BAUD_COUNTER_MAX_RX - 1) begin
            baud_counter_rx <= 0;
            rx_en <= 1;
        end else begin
            baud_counter_rx <= baud_counter_rx + 1;
            rx_en <= 0;
        end
    end 


    
endmodule