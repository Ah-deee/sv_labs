class uart_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(uart_scoreboard)

    function new(string name = "uart_scoreboard", uvm_component parent);
        super.new(name,parent);
        `uvm_info("scoreboard class","Constructor",UVM_MEDIUM)
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction
endclass