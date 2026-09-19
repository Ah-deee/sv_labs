module UART(
    input logic rst,
    input logic wr_en, 
    input logic [7:0] data_in, 
    input logic clk, 
    input logic rdy_clr,
    output rdy,busy,
    output logic [7:0] data_out
);

logic rx_tick;
logic tx_tick;
logic tx_temp;//output of tx module

baud_rate_generator bg(.rstn(rst),.*);
transmitter_block tb(.*);
receiver_block rb(.*);