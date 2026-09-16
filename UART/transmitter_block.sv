//TODO: Data shifting bug
module transmitter_block(
    input clk,wr_en,tx_tick,rst, 
    input logic [7:0] data_in,
    output logic tx,busy
);
 localparam IDLE = 2'b00,START = 2'b01,DATA = 2'b10, STOP = 2'b11;


 logic [7:0] data;
 logic [1:0] state;
 logic [2:0] bit_count;

//Four states: IDLE START DATA STOP

assign busy = (state != IDLE);

always_ff@(posedge clk)begin
    if(rst)begin
        tx <= 1'b1;
        state <= IDLE;
        bit_count <= 3'b000;
        data <= 8'b0;
    end
    else
    begin
        case(state)
            IDLE:begin
                tx <= 1'b1;
                if(wr_en)begin
                    state <= START;
                    data <=data_in;
                    bit_count <= 3'b000;
                end

                else begin
                    state <= IDLE;
                end
            end

            START:begin
                tx <= 1'b0;
                if(tx_tick)begin
                    state <= DATA;
                    tx <= data[0];
                end
                else begin
                    state <= START;
                end
            end

            DATA:begin
                if(tx_tick)begin
                    tx <= data[1];
                    data <= data>>1;
                    if(bit_count==3'd7)begin
                       state <= STOP;
                       tx <=1'b1; 
                    end
                    else begin
                       bit_count <= bit_count+1;      
                    end
                end
            end

            STOP:begin
                if(tx_tick)begin
                    tx <= 1'b1;
                    state <= IDLE;
                end
            end

            default:begin
                tx <= 1'b1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule