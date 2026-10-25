import uvm_pkg::*;
`include "uvm_macros.svh"

module uart_sva #(parameter int CLKS_PER_BIT = 5208, parameter int CLKS_PER_TICK = 325) (
  input logic clk, rst,
  input logic wr_en, rdy_clr,
  input logic tx, busy, rdy,
  input logic [7:0] data_out
);

//ESS-01: Reset and Sanity
  a_rst_values: assert property (@(posedge clk)
      rst |=> (tx == 1'b1 && busy == 1'b0 && rdy == 1'b0 && data_out == 8'h00))
    else `uvm_error("SVA","a_rst_values failed");

  // rst applied after at least one completed frame
  c_rst_after_traffic: cover property (@(posedge clk)
      $fell(busy) ##[1:$] rst);

  a_no_xz: assert property (@(posedge clk) disable iff(rst)
      !$isunknown({tx,busy,data,rdy}))
      else `uvm_error("SVA","a_no_xz failed");

//ESS-02: Baud rate ticks
  a_tx_tick_period: assert property(@(posedge clk)disable iff(rst)
      tx_tick |=> (!tx_tick)[*CLKS_PER_BIT-1] ##1 tx_tick)
      else `uvm_error("SVA","a_tx_tick_period");
  c_tx_tick: cover property(@(posedge clk)disable iff (rst) tx_tick);

  a_rx_tick_period: assert property(@(posedge clk)disable iff(rst)
      rx_tick |=> (!rx_tick)[*CLKS_PER_TICK-1] ##1 rx_tick)
      else `uvm_error("SVA","a_rx_tick_period");
  c_rx_tick: cover property(@(posedge clk)disable iff (rst) rx_tick);



endmodule