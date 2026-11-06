`include "uart_transaction.sv"
class uart_driver;
    uart_transaction t;
    virtual uart_if.drv vif;
    int n_driven = 0;
    mailbox #(uart_transaction) gen2drv;
    //mailbox #(uart_transaction) drv2sb;
    //mailbox #(uart_transaction) drv2rm;

    function new(virtual uart_if.drv vif ,mailbox #(uart_transaction) gen2drv);
        this.vif = vif;
        this.gen2drv = gen2drv;
    endfunction

    task reset();
        vif.drv_cb.rst <=1'b1;
        vif.drv_cb.wr_en <=1'b0;
        vif.drv_cb.rdy_clr <=1'b0;
        vif.drv_cb.data_in <=0;

        repeat(5) @(posedge vif.clk);
        vif.drv_cb.rst <=1'b0;
    endtask

    task run();
        reset();

        forever begin
            gen2drv.get(t);
            drive(t);
            n_driven++;
        end
    endtask

    task drive(uart_transaction t);
        repeat(t.gap) @(posedge vif.clk);
        vif.drv_cb.data_in <= t.data;
        vif.drv_cb.wr_en<=1'b1;
        @(posedge vif.clk);
        vif.drv_cb.wr_en <= 1'b0;

        wait(vif.drv_cb.busy);
        wait(vif.drv_cb.rdy);

        $display("%t %s",$time,t.convert2string());

        vif.drv_cb.rdy_clr <= 1'b1;@(posedge vif.clk)
        vif.drv_cb.rdy_clr <= 1'b0;
    endtask


endclass