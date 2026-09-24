`timescale 1ns/1ps

module UART_tb;

    // Small clk_freq/baud_rate ratio -> few clocks per bit -> fast sim.
    // Keep clk_freq/baud_rate an integer multiple of 16 so the rx 16x tick
    // divides evenly (BAUD_COUNTER_MAX_RX = clk_freq/(baud_rate*16)).
    localparam CLK_FREQ  = 1600;
    localparam BAUD_RATE = 100;   // 16 clks per rx tick, 16 clks per tx tick

    logic clk, rst, wr_en, rdy_clr;
    logic [7:0] data_in;
    logic rdy, busy;
    logic [7:0] data_out;

    int errors = 0;
    int pass_count = 0;

    UART #(
        .clk_freq(CLK_FREQ),
        .baud_rate(BAUD_RATE)
    ) uart_inst (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .data_in(data_in),
        .rdy_clr(rdy_clr),
        .rdy(rdy),
        .busy(busy),
        .data_out(data_out)
    );

    // Clock
    initial clk = 0;
    always #5 clk = ~clk; // 100 MHz-equivalent time units

    // Watchdog so a stuck sim doesn't run forever
    initial begin
        #200000;
        $display("[%0t] TIMEOUT: simulation did not finish in time", $time);
        $finish;
    end

    // Sends one byte, waits for busy to drop, then waits for rdy and checks data_out
    task automatic send_and_check(input [7:0] byte_to_send);
        // drive write
        @(negedge clk);
        data_in = byte_to_send;
        wr_en   = 1;
        @(negedge clk);
        wr_en   = 0;

        // wait for transmitter to finish shifting the byte out
        wait(!busy);

        // wait for receiver to flag data ready
        wait(rdy);

        if (data_out === byte_to_send) begin
            $display("[%0t] PASS: sent 0x%0h, received 0x%0h", $time, byte_to_send, data_out);
            pass_count++;
        end else begin
            $display("[%0t] FAIL: sent 0x%0h, received 0x%0h", $time, byte_to_send, data_out);
            errors++;
        end

        // clear rdy before next byte
        @(negedge clk);
        rdy_clr = 1;
        @(negedge clk);
        rdy_clr = 0;

        if (rdy !== 0) begin
            $display("[%0t] FAIL: rdy did not clear after rdy_clr pulse", $time);
            errors++;
        end
    endtask

    initial begin
        // Init / reset
        rst      = 1;
        wr_en    = 0;
        rdy_clr  = 0;
        data_in  = 8'h00;

        repeat (3) @(negedge clk);
        rst = 0;
        repeat (2) @(negedge clk);

        // Sanity: nothing should be ready/busy out of reset
        if (busy !== 0 || rdy !== 0) begin
            $display("[%0t] FAIL: busy/rdy not clear after reset (busy=%0b rdy=%0b)", $time, busy, rdy);
            errors++;
        end

        // Directed test bytes: all-zero, all-one, alternating patterns, a couple of arbitrary values
        send_and_check(8'h00);
        send_and_check(8'hFF);
        send_and_check(8'hA5);
        send_and_check(8'h5A);
        send_and_check(8'h01);
        send_and_check(8'h80);

        // Random bytes
        for (int i = 0; i < 5; i++) begin
            send_and_check($urandom_range(0, 255));
        end

        if (errors == 0)
            $display("\n=== ALL %0d TESTS PASSED ===", pass_count);
        else
            $display("\n=== %0d PASSED, %0d FAILED ===", pass_count, errors);

        $finish;
    end

endmodule