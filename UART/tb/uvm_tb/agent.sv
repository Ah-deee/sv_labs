class uart_agent extends uvm_agent;
    `uvm_component_utils(uart_agent)

    uart_driver drv;
    uart_monitor mon;
    uart_sequencer seqr;

    function new(string name = "uart_agent", uvm_component parent);
        super.new(name,parent);
        `uvm_info("Agent class","Constructor",UVM_MEDIUM)
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Lower components
        drv = uart_drv::type_id::create("drv",this);
        mon = uart_mon::type_id::create("mon",this);
        seqr = uart_seqr::type_id::create("seqr",this);
    endfunction
endclass