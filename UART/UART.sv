module UART#(
    parameter clk_freq  = 50_000_000,
    parameter baud_rate = 9600
)(
    input logic rst,
    input logic clk, 
    input logic wr_en, 
    input logic [7:0] data_in, 
    
    input logic rdy_clr,

    output rdy,busy,
    output logic [7:0] data_out
);

logic rx_tick;
logic tx_tick;
logic tx_rx; //output of tx module and input of the rx module

baud_rate_generator bg(.clk(clk),.rst(rst),.tx_tick(tx_tick),.rx_tick(rx_tick));
transmitter_block tb(.clk(clk),.rst(rst),.wr_en(wr_en),.tx_tick(tx_tick),.data_in(data_in),.tx(tx_rx),.busy(busy));
receiver_block rb(.clk(clk),.rst(rst),.rx_tick(rx_tick),.rx(tx_rx),.data_out(data_out),.rdy(rdy),.rdy_clr(rdy_clr));

endmodule