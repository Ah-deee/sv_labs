module uart_sva #(parameter int CLKS_PER_BIT = 5208) (
  input logic       clk, rst,
  input logic       wr_en, rdy_clr,
  input logic       tx, busy, rdy,
  input logic [7:0] data_out
);

  // RST001 / RST002: reset values (sync reset -> visible next cycle)
  a_rst_values: assert property (@(posedge clk)
      rst |=> (tx == 1'b1 && busy == 1'b0 && rdy == 1'b0 && data_out == 8'h00))
    else $error("a_rst_values failed");

  // rst applied after at least one completed frame
  c_rst_after_traffic: cover property (@(posedge clk)
      $fell(busy) ##[1:$] rst);

  // TXF003: tx idles high whenever busy = 0
  a_tx_idle_high: assert property (@(posedge clk) disable iff (rst)
      !busy |-> tx)
    else $error("a_tx_idle_high failed");
  c_tx_idle_high: cover property (@(posedge clk) disable iff (rst) !busy);

  // TXI005: busy rises the cycle after an accepted wr_en
  a_busy_after_wr_en: assert property (@(posedge clk) disable iff (rst)
      (wr_en && !busy) |=> busy)
    else $error("a_busy_after_wr_en failed");
  c_busy_after_wr_en: cover property (@(posedge clk) disable iff (rst)
      wr_en && !busy);

endmodule