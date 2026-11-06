`include "uart_transaction.sv"
class uart_generator;
    mailbox #(uart_transaction) gen2drv;
    int count;
    uart_transaction t;
    event done;

    function new(mailbox #(uart_transaction) gen2drv, int count);
        this.gen2drv = gen2drv;
        this.count = count;
    endfunction


    task run();
        bit [7:0] corners[] = '{8'h00,8'hFF,8'hAA,8'h55,8'h01,8'h80};
        for(int i=0;i<count;i++)begin
            t=new();
            if(i<corners.size())begin
                if(!t.randomize() with {data == corners[i]; gap == 0;})
                    $fatal(1, "[GEN] randomize failed");
            end else if(!t.randomize())
                    $fatal(1, "[GEN] randomize failed");
            gen2drv.put(t);
            $display("[GEN] %0t %s",$time,t.convert2string());
        end
        ->done;
    endtask
endclass