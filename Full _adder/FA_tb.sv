module FA_tb;
    
    logic a,b,c;
    logic sum,carry;

    FA DUT(.a(a), .b(b), .c(c), .sum(sum), .carry(carry));


    initial begin
        $dumpfile("wave.vcd");   // output file
        $dumpvars(0, FA_tb);  // dump all signals in TB scope
        $display("a b c | SUM  CARRY");
        $display("------|-----------");
        $monitor("%b %b %b | %b  %b",a,b,c,sum,carry);

        for(int i=0;i<8;i++)begin
            {a,b,c} = i;
            #10;
        end
        $finish;

    end

endmodule