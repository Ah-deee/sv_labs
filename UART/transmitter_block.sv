module transmitter_block(
    input clk,wr_en,tx_en,rst, 
    input logic [7:0] data_in,
    output tx,busy
);
 parameter IDLE = 2'b00,START = 2'b01,DATA = 2'b10, STOP = 2'b11;


 logic [7:0] data_in;
 logic [1:0] state;
 logic [2:0] bit_count;

//Four states: IDLE START DATA STOP

always_ff(posedge clk)begin
    if(rst)begin
        tx = 1'b1;
    end

    begin
        case(state)
            IDLE:begin
                if(wr_en && tx_en)begin
                    state <= START;
                    data <=data_in;
                    bit_count <= 3'b000;
                end
                state <= START;
                data <=data_in;
                bit_count <= 3'b000;
            end

            START:begin

            end
    end
end