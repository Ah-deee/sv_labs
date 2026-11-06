`include "uart_transaction.sv"
class uart_reference_model;
    mailbox #(uart_transaction) mon2ref;
    mailbox #(uart_transaction) ref2sb;

    function new(mailbox #(uart_transaction) mon2ref, mailbox #(uart_transaction) ref2sb);
        this.mon2ref = mon2ref;
        this.ref2sb = ref2sb;
    endfunction

    function bit [9:0] frame(bit [7:0] d);
        return {1'b1,d,1'b0};
    endfunction

    task run();
        uart_transaction in,exp;
        forever begin
            mon2ref.get(in);
            exp = in.copy();
            exp.data_out = in.data;
            ref2sb.put(exp);
            $display("[REF] %0t  in 0x%02h  frame %010b  expect 0x%02h", $time, in.data, frame(in.data), exp.data_out);
        end
    endtask
endclass