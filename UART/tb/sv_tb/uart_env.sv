class uart_env;
    virtual uart_if vif;

    mailbox #(uart_transaction) gen2drv, mon2sb, mon2ref, ref2sb;

    uart_generator gen;
    uart_driver drv;
    uart_monitor mon;
    uart_scoreboard sb;
    uart_reference_model rm;

    int count;
    int clks_per_bit;
    
    function new(virtual uart_if vif, int count, int clks_per_bit);
        this.vif = vif;
        this.count = count;
        this.clks_per_bit = clks_per_bit;

        gen2drv = new();
        mon2ref = new();
        mon2sb = new();
        ref2sb = new();

        gen = new(gen2drv,count);
        drv = new(vif.drv,gen2drv);
        mon = new(vif.mon,mon2sb,mon2ref);
        sb = new(ref2sb,mon2sb);
        rm = new(mon2ref,ref2sb);
    endfunction

    task run();
        fork
            gen.run();
            drv.run();
            mon.run();
            rm.run();
            sb.run();
        join_none


        //watchdog
        fork begin
            fork
                wait (sb.n_checked() == count);

                begin
                repeat (count * (12 * clks_per_bit + 250)) @(posedge vif.clk);
                $error("[ENV] timeout: checked %0d of %0d", sb.n_checked(), count);
                end

            join_any
            disable fork;
        end join

        repeat (clks_per_bit) @(posedge vif.clk);   
        report();
    endtask


    function void report();
        $display("--------------------------------------------------");
        $display("[ENV] driven=%0d predicted=%0d", drv.n_driven, rm.n_pred);
        sb.report();
        if(sb.n_mismatch == 0 && sb.n_match == count && ref2sb.num()==0)
            $display("[ENV] TEST PASSED");
        else
            $display("[ENV] TEST FAILED");
        $display("--------------------------------------------------");
    endfunction
endclass