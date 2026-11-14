class uart_driver extends uvm_driver#(uvm_seq_item);
    `uvm_component_utils(uart_driver)

    function new(string name = "uart_driver", uvm_component parent);
        super.new(name,parent);
        `uvm_info("driver class","Constructor",UVM_MEDIUM)
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    
endclass