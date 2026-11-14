class uart_sequence extends uvm_sequence;
    `uvm_object_utils(uart_sequence)

    function new(string name = "uart_sequence");
        super.new(name);
        `uvm_info("Sequence class","Constructor",UVM_MEDIUM)
    endfunction
endclass