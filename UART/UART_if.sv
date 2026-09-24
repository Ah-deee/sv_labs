interface UART_if(input bit clk);
logic rst,wr_en,rdy_clr,rdy,busy;
logic [7:0] data_in,data_out;

modport dut(input rst,wr_en,rdy_clr, input [7:0] data_in, output [7:0] data_out,output rdy,busy);
modport tb(input [7:0] data_out, input rdy,busy, output rst,wr_en,rdy_clr,output [7:0] data_in);
endinterface
