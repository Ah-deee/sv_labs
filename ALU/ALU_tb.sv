module ALU_tb;
    logic [7:0] a,b;
    logic [3:0] cmd;
    logic oe;
    logic [15:0] dout;

    ALU DUT(.a(a), .b(b), .cmd(cmd), .oe(oe), .dout(dout));

    localparam ADD=4'b0000, INC=4'b0001, SUB=4'b0010, DEC=4'b0011,
               MUL=4'b0100, DIV=4'b0101, RSH=4'b0110, LSH=4'b0111,
               AND=4'b1000, OR=4'b1001,  INV=4'b1010, NAND=4'b1011,
               NOR=4'b1100, XOR=4'b1101, XNOR=4'b1110, BUF=4'b1111;

    task test(input [7:0] ta,tb, input [3:0] tcmd, input string op_name);
        a = ta; b = tb; cmd = tcmd; oe = 1;
        #10;
        $display("%-20s | a=%0d b=%0d | dout=%0d", op_name, a, b, dout);//left align and 20 char wide padding
    endtask

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,ALU_tb);

        $display("%-20s | %-14s | dout", "Operation", "Inputs");
        $display("----------------------------------------------------");

        a = 8'd10; b = 8'd5;

        test(a,b,  ADD,  "Add");
        test(a, b, INC,  "Increment a");
        test(a, b, SUB,  "Subtract");
        test(a, b, DEC,  "Decrement a");
        test(a, b, MUL,  "Multiply");
        test(a, b, DIV,  "Divide");
        test(a, b, RSH,  "Shift right");
        test(a, b, LSH,  "Shift left");
        test(a, b, AND,  "AND");
        test(a, b, OR,   "OR");
        test(a, b, INV,  "Invert a");
        test(a, b, NAND, "NAND");
        test(a, b, NOR,  "NOR");
        test(a, b, XOR,  "XOR");
        test(a, b, XNOR, "XNOR");
        test(a, b, BUF,  "Buffer a");

        $finish;
    end


endmodule