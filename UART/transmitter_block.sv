module transmitter_block(
    input clk,wr_en,tx_en,rst, 
    input logic [7:0] data_in,
    output tx,busy
);
 parameter IDLE = 2'b00,START = 2'b01,DATA = 2'b10, STOP = 2'b11;


 reg[7:0]

//Four states: IDLE START DATA STOP

always_ff(posedge clk)begin
    
end