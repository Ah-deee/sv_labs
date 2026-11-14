class uart_env extends uvm_env;
    `uvm_component_utils(uart_env)

    uart_agent agent;
    uart_scoreboard scoreboard;

    function new(string name = "uart_env", uvm_component parent);
        super.new(name,parent);
        `uvm_info("Env class","Constructor",UVM_MEDIUM)
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Lower components
        agent = uart_agent::type_id::create("agent",this);
        scoreboard = uart_scoreboard::type_id::create("scoreboard",this);
    endfunction
endclass