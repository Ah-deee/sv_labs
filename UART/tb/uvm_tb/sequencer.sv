class uart_sequencer extends uvm_sequencer#(uart_seq_item);
    `uvm_component_utils(uart_sequencer)

    function new(string name = "uart_sequencer", uvm_component parent);
        super.new(name,parent);
        `uvm_info("sequencer class","Constructor",UVM_MEDIUM)
    endfunction
endclass