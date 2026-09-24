interface ports(input bit clk);
logic rst,wr_en,rdy_clr,rdy,busy;
logic [7:0] data_in,data_out;
endinterface
