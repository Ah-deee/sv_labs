import uvm_pkg::*;
`include "uvm_macros.svh"

module uart_sva #(parameter int CLKS_PER_BIT = 5208, parameter int CLKS_PER_TICK = 325) (
  input logic clk, rst,
  input logic wr_en, rdy_clr,
  input logic tx, busy, rdy,
  input logic tx_tick, rx_tick,
  input logic [7:0] data_out
);

//ESS-01: Reset and Sanity
  a_rst_values: assert property (@(posedge clk)
      rst |=> (tx == 1'b1 && busy == 1'b0 && rdy == 1'b0 && data_out == 8'h00))
    else `uvm_error("SVA","a_rst_values failed")

  // rst applied after at least one completed frame
  c_rst_after_traffic: cover property (@(posedge clk)
      $fell(busy) ##[1:$] rst);

  a_no_xz: assert property (@(posedge clk) disable iff(rst)
      !$isunknown({tx,busy,data_out,rdy}))
      else `uvm_error("SVA","a_no_xz failed")



//ESS-02: Baud rate ticks
  a_tx_tick_period: assert property(@(posedge clk)disable iff(rst)
      tx_tick |=> (!tx_tick)[*CLKS_PER_BIT-1] ##1 tx_tick)
      else `uvm_error("SVA","a_tx_tick_period")
  c_tx_tick: cover property(@(posedge clk)disable iff (rst) tx_tick);

  a_rx_tick_period: assert property(@(posedge clk)disable iff(rst)
      rx_tick |=> (!rx_tick)[*CLKS_PER_TICK-1] ##1 rx_tick)
      else `uvm_error("SVA","a_rx_tick_period")
  c_rx_tick: cover property(@(posedge clk)disable iff (rst) 
      rx_tick);



//ESS-03:TX basic framing
  //tx idles when not busy(since it is active low)

  a_tx_idle_high: assert property(@(posedge clk)disable iff(rst)
      !busy |-> tx)
      else `uvm_error("SVA","a_tx_idle_high")
  c_tx_idle_high: cover property(@(posedge clk)disable iff(rst)
      !busy);

  // start bit: within one bit time of busy rising, tx goes low for a full bit

  a_start_bit: assert property(@(posedge clk) disable iff(rst)
      $rose(busy)|->tx[*1:CLKS_PER_BIT] ##1 (!tx)[*CLKS_PER_BIT])
      //$rose(busy) |-> ##[0:CLKS_PER_BIT] ($fell(tx) ##0 (!tx)[*CLKS_PER_BIT])
      else `uvm_error("SVA","a_start_bit")
  c_start_bit: cover property(@(posedge clk)disable iff(rst)
      $rose(busy) ##[1:CLKS_PER_BIT] $fell(tx));
  
  // tick arrived immediately: tx falls 1 cycle after busy rises
  c_start_min: cover property (@(posedge clk) disable iff (rst)
    $rose(busy) ##1 $fell(tx));

  // tick had just fired: tx falls a full bit time later
  c_start_max: cover property (@(posedge clk) disable iff (rst)
    $rose(busy) ##CLKS_PER_BIT $fell(tx));

  a_stop_bit: assert property (@(posedge clk) disable iff (rst)
    $fell(busy)|->tx[*CLKS_PER_BIT])
    else `uvm_error("SVA","a_stop_bit")

  c_stop_bit: cover property(@(posedge clk) disable iff (rst)
    $fell(busy));



//ESS-04: TX Control and Handshake
  //busy rises a cycle after wr_en is accepted
  a_busy_after_wr_en: assert property(@(posedge clk) disable iff(rst)
    (wr_en && !busy) |=> $rose(busy))
    else `uvm_error("SVA","a_busy_after_wr_en")
  c_valid_wr_en: cover property(@(posedge clk) disable iff(rst)
    (wr_en && !busy));

  //busy covers start bit+ 8 bits + stop bit
  a_busy_length: assert property(@(posedge clk) disable iff(rst)
    $rose(busy) |-> (busy throughout (tx_tick[->10])) ##1 !busy)
    else `uvm_error("SVA","a_busy_length")
  c_busy_ticks: cover property (@(posedge clk) disable iff (rst)
    $rose(busy) ##0 (busy throughout (tx_tick[->10])) ##1 !busy);

  a_wr_en_while_busy_drop: assert property(@(posedge clk) disable iff(rst)
    $rose(busy) |-> $past(wr_en && !busy))
    else `uvm_error("SVA","a_wr_en_while_busy_drop")
  c_wr_en_while_busy: cover property(@(posedge clk) disable iff(rst)
    (wr_en && busy));
    
// ESS-05: one rdy per received frame
  c_rdy_rise: cover property (@(posedge clk) disable iff (rst) $rose(rdy));

//ESS-07: RX handshake
  //rdy stays high until rdy_clr
  a_rdy_high_rdy_clr: assert property(@(posedge clk)  disable iff(rst)
    (rdy && rdy_clr) |=> !rdy)
    else `uvm_error("SVA","a_rdy_high_rdy_clr")
  c_rdy_high_rdy_clr: cover property(@(posedge clk) disable iff(rst)
    rdy && rdy_clr);

  //data_out stable when rx ready(RX not overruned)
  a_data_stable: assert property(@(posedge clk) disable iff(rst)
    (rdy && !rdy_clr) |=> $stable(data_out))
    else `uvm_error("SVA","a_data_stable")

//ESS-06 does not have internal signals exposed
//ESS-08,09 are scoreboard related
//ESS-10,11 loopback for bad stop bit can't be driven
//ESS-12 Baud drift
endmodule