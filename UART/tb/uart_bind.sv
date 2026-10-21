bind UART uart_sva #(.CLKS_PER_BIT(clk_freq / baud_rate)) u_sva (
  .clk     (bus.clk),
  .rst     (bus.rst),
  .wr_en   (bus.wr_en),
  .rdy_clr (bus.rdy_clr),
  .tx      (tx_rx),
  .busy    (bus.busy),
  .rdy     (bus.rdy),
  .data_out(bus.data_out)
);