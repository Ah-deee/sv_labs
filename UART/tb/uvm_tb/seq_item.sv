class uart_seq_item extends uvm_seq_item;
    `uvm_object_utils(uart_seq_item)

    rand logic [7:0] data;
    rand int unsigned gap;

    constraint c_gap { gap dist { 0 := 5, [1:20] := 3, [21:200] := 1 }; }

    function new(string name = "uart_seq_item");
        super.new(name);
        `uvm_info("Sequence item class","Constructor",UVM_MEDIUM)
    endfunction
endclass