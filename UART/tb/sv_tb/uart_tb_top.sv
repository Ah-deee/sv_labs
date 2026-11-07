`timescale 1ns/1ps
module uart_tb_top;
    import uart_sv_pkg::*;

    localparam int CLK_FREQ     = 50_000_000; //50 Mhz
    localparam int BAUD_RATE    = 9600;
    localparam int CLKS_PER_BIT = CLK_FREQ/BAUD_RATE;
    localparam real HALF_PERIOD  = 1.0e9/CLK_FREQ/2.0;

    uart_if intf();

    initial intf.clk = 0;
    always #(HALF_PERIOD) intf.clk = ~intf.clk;

    UART #(.clk_freq(CLK_FREQ), .baud_rate(BAUD_RATE)) dut (.bus(intf.dut));

    uart_env env;
    int num_txn = 50;

    initial begin
        intf.wr_en = 0; intf.rdy_clr = 0; intf.data_in = 0;
        intf.rst = 1;
        repeat(5) @(negedge intf.clk);
        intf.rst = 0;

        env = new(intf, num_txn, CLKS_PER_BIT);
        env.run();
        $finish;
    end

endmodule