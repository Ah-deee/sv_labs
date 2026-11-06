`include "uart_transaction.sv"
class uart_scoreboard;
    mailbox #(uart_transaction) ref2sb;
    mailbox #(uart_transaction) mon2sb;
    int n_match = 0; int n_mismatch = 0;
    bit [7:0] exp_data;

    covergroup cov;
        coverpoint exp_data{
            bins low_val = {[0:63]};
            bins mid_val = {[64:127]};
            bins hi_val = {[128:255]};}
    endgroup

    function new(mailbox #(uart_transaction) ref2sb,mailbox #(uart_transaction) mon2sb);
        this.mon2sb = mon2sb;
        this.ref2sb = ref2sb;
        cov = new();        
    endfunction


    task run();
    uart_transaction act,exp;
    forever begin
        fork
            mon2sb.get(act);
            ref2sb.get(exp);
        join
        exp_data = exp.data_out;
        if(act.data_out == exp.data_out)begin
            $display("[SB] PASS at %0t Received successfully",$time);
            n_match++;
        end
        else begin
            $display("[SB] FAIL at %0t Received data did not match exp 0x%02h act 0x%02h", $time, exp.data_out, act.data_out);
            n_mismatch++;
        end
        cov.sample();
    end
    endtask

    function void report();
        $display("[SB] Matches = %0d, Mismatches = %0d, Coverage = %0.2f%%",n_match,n_mismatch,cov.get_coverage());
    endfunction
endclass