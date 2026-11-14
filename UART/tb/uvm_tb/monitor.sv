class uart_monitor extends uvm_monitor;
    `uvm_component_utils(uart_monitor)

    function new(string name = "uart_monitor", uvm_component parent);
        super.new(name,parent);
        `uvm_info("monitor class","Constructor",UVM_MEDIUM)
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction
endclass