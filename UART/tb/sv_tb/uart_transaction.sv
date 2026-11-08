class uart_transaction;
    rand bit [7:0] data;
    rand int unsigned gap; //idle clocks before the wr_en

    bit [7:0] data_out;
    static int next_id = 0;
    int id;

    constraint c_gap{gap dist{ 0:=30,[1:20] :/50,[21:200] :/20};}

    function new();
        id = next_id++;
    endfunction


    function uart_transaction copy();
        copy = new();
        copy.data = data;
        copy.gap = gap;
        copy.data_out = data_out;
        copy.id = id;
    endfunction

    function string convert2string();
        return $sformatf("id=%0d data=0x%02h gap=%0d data_out=0x%02h", id, data, gap, data_out);
    endfunction
endclass
