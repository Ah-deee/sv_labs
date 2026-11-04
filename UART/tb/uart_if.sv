interface uart_if;
    bit clk;
    logic rst,wr_en,rdy_clr,rdy,busy;
    logic [7:0] data_in,data_out;

    clocking drv_cb @(posedge clk);
        default input #1step output #2ns;
        output rst,wr_en,rdy_clr,data_in;
        input rdy,busy;
    endclocking

    clocking mon_cb @(posedge clk);
        default input #1step;
        input rst,wr_en,rdy_clr,data_in,data_out,rdy,busy;
    endclocking

    modport dut(input rst,wr_en,rdy_clr,clk, data_in, 
                output data_out,rdy,busy);
    modport drv(clocking drv_cb,input clk);
    modport mon(clocking mon_cb,input clk);

    
                
endinterface
