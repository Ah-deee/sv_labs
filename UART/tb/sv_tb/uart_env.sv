import uart_pkg::*;
class uart_env;
    virtual uart_if vif;

    mailbox #(uart_transaction) gen2drv, mon2sb, mon2ref, ref2sb;

    uart_generator gen;
    uart_driver drv;
    uart_monitor mon;
    uart_scoreboard sb;
    uart_reference_model rm;

    int count;
    function new(virtual uart_if vif, int count);
        this.vif = vif;
        this.count = count;

        gen2drv = new();
        mon2ref = new();
        mon2sb = new();
        ref2sb = new();

        gen = new(gen2drv,count);
        drv = new(vif.drv,gen2drv);
    endfunction
endclass