`include "uart_transaction.sv"

class uart_monitor;
    virtual uart_if.mon vif;
    mailbox #(uart_transaction) mon2sb;
    mailbox #(uart_transaction) mon2ref;
    uart_transaction t;

    function new(virtual uart_if.mon vif, mailbox #(uart_transaction) mon2sb, mailbox #(uart_transaction) mon2ref);
        this.vif = vif;
        this.mon2sb = mon2sb;
        this.mon2ref = mon2ref;
    endfunction

    task run();
        logic rdy_q = 0;
        forever begin
            @(posedge vif.mon_cb)
            if(vif.mon_cb.rst)begin
                rdy_q = 0;
                continue;
            end

            //data_in is given to the reference model when TX is idle
            if (vif.mon_cb.wr_en && !vif.mon_cb.busy) begin
                t = new();
                t.data = vif.mon_cb.data_in;
                mon2ref.put(t);
            end

            //When rdy rises, it means new data is in data_out, which is given to the scoreboard
            if(vif.mon_cb.rdy && !rdy_q)begin
                t = new();
                t.data_out = vif.mon_cb.data_out;
                mon2sb.put(t);
                $display("[MON] %0t RX delivered %0h",$time,t.data_out);
            end
            rdy_q = vif.mon_cb.rdy;
        end
    endtask

endclass