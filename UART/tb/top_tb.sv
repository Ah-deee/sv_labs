module top_tb;
  uart_if bus();
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
  UART #(.clk_freq(50_000_000), .baud_rate(9600)) dut (.bus(bus));

  // 50 MHz clock (bit clk starts at 0)
  always #10 bus.clk = ~bus.clk;

  task automatic do_reset(int n = 5);
    @(negedge bus.clk);
    bus.cb.rst = 1;
    repeat (n) @(negedge bus.clk);
    bus.cb.rst = 0;
  endtask

  // send one byte through TX, loopback receives it, then clear rdy
  task automatic send_byte(input logic [7:0] d);
    @(negedge bus.clk);
    bus.cb.data_in = d;
    bus.cb.wr_en   = 1;
    @(negedge bus.clk);
    bus.cb.wr_en   = 0;
    @(posedge bus.cb.busy);   // frame started
    @(negedge bus.cb.busy);   // stop bit begins
    wait (bus.cb.rdy);        // RX finished (loopback)
    @(negedge bus.clk);
    bus.cb.rdy_clr = 1;
    @(negedge bus.clk);
    bus.cb.rdy_clr = 0;
  endtask

  initial begin
    bus.cb.rst = 0; bus.cb.wr_en = 0; bus.cb.rdy_clr = 0; bus.cb.data_in = 8'h00;

    do_reset();
    send_byte(8'hA5);
    send_byte(8'h3C);
    do_reset();            // reset after a completed frame -> c_rst_after_traffic
    repeat (10) @(negedge bus.clk);
    $finish;
  end
endmodule