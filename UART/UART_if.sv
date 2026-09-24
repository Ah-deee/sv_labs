interface UART_if(input bit clk);
logic rst,wr_en,rdy_clr,rdy,busy;
logic [7:0] data_in,data_out;

modport dut(input rst,wr_en,rdy_clr,clk, data_in, 
            output data_out,rdy,busy);
modport tb(input data_out,rdy,busy, 
            output rst,wr_en,rdy_clr,data_in,clk);
endinterface
