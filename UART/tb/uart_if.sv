interface uart_if;
    bit clk;
    logic rst,wr_en,rdy_clr,rdy,busy;
    logic [7:0] data_in,data_out;

    modport dut(input rst,wr_en,rdy_clr,clk, data_in, 
                output data_out,rdy,busy);

    modport tb(input data_out,rdy,busy, 
                output rst,wr_en,rdy_clr,data_in,clk);

    clocking cb @(posedge clk);
        default input #3ns output #2ns;
        input data_out,rdy,busy;
        output rst,wr_en,rdy_clr,data_in;
    endclocking
                
endinterface
