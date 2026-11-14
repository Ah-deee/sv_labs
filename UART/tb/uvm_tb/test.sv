class uart_test extends uvm_test;
    `uvm_component_utils(uart_test)

    uart_env env;

    function new(string name = "uart_test", uvm_component parent);
        super.new(name,parent);
        `uvm_info("Test class","Constructor",UVM_MEDIUM)
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Lower components
        env = uart_env::type_id::create("env",this);
    endfunction
endclass