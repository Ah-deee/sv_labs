 module receiver_block (
    input logic clk,
    input logic rst,
    input logic rx,
    input logic rx_tick,
    input logic rdy_clr,
    output logic [7:0] data_out,
    output logic rdy
);

typedef enum logic [1:0] {IDLE, START, DATA_OUT, STOP} state_t;
state_t state = IDLE;

logic [3:0] sample = 4'b0;
logic [2:0] index = 3'b0;
logic [7:0] temp = 8'b0;
logic rx_meta,rx_s;

always_ff@(posedge clk)begin
    if(rst)begin
        rx_meta <= 1'b1;
        rx_s <= 1'b1;
    end
    else begin
        rx_meta <= rx;
        rx_s <= rx_meta;
    end
end


always_ff @( posedge clk ) begin
    if(rst)begin
        rdy <= 0;
        data_out <= 0;
        state <= IDLE;
        sample <= 0;
        index <= 0;
        temp <= 0;
    end    
    else begin 
        if(rdy_clr)begin
            rdy<=0;
        end
        if (rx_tick)begin
            case(state)
                IDLE: begin
                    if(!rx_s)begin
                        sample <= 0;
                        state <= START;
                    end
                end
                START: begin
                    if(sample == 7)begin
                        sample <=0;
                        if(rx_s)begin
                            sample <= 0;
                            state <= IDLE;
                        end
                        else begin
                               state <= DATA_OUT;
                               index <= 0;
                               temp <= 0; 
                            end
                            
                        end
                    end
                    else begin
                            sample <= sample + 1;
                end

                DATA_OUT:begin
                    if(sample == 15)begin
                        sample <= 0;
                        temp[index] <= rx_s;
                        index <= index + 1;
                    end

                    if(index == 7)begin
                        state <= STOP;
                    end
                        else
                            index <= index + 1;
                    else
                        sample <= sample+1;
                end
            

                STOP:begin
                    if(sample == 15)begin
                        sample <=0;
                        state <= IDLE;
                        if(rx_s)begin
                            data_out <= temp;
                            rdy <= 1'b1;
                        end
                    end

                    else
                    sample <= sample + 1;
                end
            endcase
        end
    end
end


endmodule


//Changes from the youtube video
//Added two ff sync to eliminate metastable rx pin
//Needs 4 states rather than 3 like suggested in the video
