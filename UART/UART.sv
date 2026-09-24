module UART#(
    parameter clk_freq  = 50_000_000,
    parameter baud_rate = 9600
)(UART_if.dut bus);

logic rx_tick;
logic tx_tick;
logic tx_rx; //output of tx module and input of the rx module

baud_rate_generator bg(.clk(bus.clk),.rst(bus.rst),.tx_tick(tx_tick),.rx_tick(rx_tick));
transmitter_block tb(.clk(bus.clk),.rst(bus.rst),.wr_en(bus.wr_en),.tx_tick(tx_tick),.data_in(bus.data_in),.tx(tx_rx),.busy(bus.busy));
receiver_block rb(.clk(bus.clk),.rst(bus.rst),.rx_tick(rx_tick),.rx(tx_rx),.data_out(bus.data_out),.rdy(bus.rdy),.rdy_clr(bus.rdy_clr));

endmodule