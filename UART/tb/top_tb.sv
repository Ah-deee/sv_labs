module top_tb;
  uart_if bus();
  UART #(.clk_freq(50_000_000), .baud_rate(9600)) dut (.bus(bus));

  // 50 MHz clock (bit clk starts at 0)
  always #10 bus.clk = ~bus.clk;

  task automatic do_reset(int n = 5);
    @(negedge bus.clk);
    bus.rst = 1;
    repeat (n) @(negedge bus.clk);
    bus.rst = 0;
  endtask

  // send one byte through TX, loopback receives it, then clear rdy
  task automatic send_byte(input logic [7:0] d);
    @(negedge bus.clk);
    bus.data_in = d;
    bus.wr_en   = 1;
    @(negedge bus.clk);
    bus.wr_en   = 0;
    @(posedge bus.busy);   // frame started
    @(negedge bus.busy);   // stop bit begins
    wait (bus.rdy);        // RX finished (loopback)
    @(negedge bus.clk);
    bus.rdy_clr = 1;
    @(negedge bus.clk);
    bus.rdy_clr = 0;
  endtask

  initial begin
    bus.rst = 0; bus.wr_en = 0; bus.rdy_clr = 0; bus.data_in = 8'h00;

    do_reset();
    send_byte(8'hA5);
    send_byte(8'h3C);
    do_reset();            // reset after a completed frame -> c_rst_after_traffic
    repeat (10) @(negedge bus.clk);
    $finish;
  end
endmodule