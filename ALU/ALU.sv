module ALU (
    input logic [7:0] a,b,
    input logic [3:0] cmd,
    input logic oe,
    output logic [15:0] dout
);

parameter ADD = 4'b0000,
          INC = 4'b0001,
          SUB = 4'b0010,
          DEC = 4'b0011,
          MUL = 4'b0100,
          DIV = 4'b0101,
          RSH = 4'b0110,
          LSH = 4'b0111,
          AND = 4'b1000,
          OR  = 4'b1001,
          INV  = 4'b1010,
          NAND = 4'b1011,
          NOR  = 4'b1100,
          XOR  = 4'b1101,
          XNOR = 4'b1110,
          BUF  = 4'b1111;

logic [15:0] result;

always_comb begin
    case (cmd)
    ADD: result = a+b;
    INC: result = a+1;
    SUB: result = a-b;
    DEC: result = a-1;
    MUL:  result = a * b;
    DIV:  result = a / b;
    RSH:  result = a >> 1;
    LSH:  result = a << 1;
    AND:  result = a & b;
    OR:   result = a | b;
    INV:  result = ~a;
    NAND: result = ~(a & b);
    NOR:  result = ~(a | b);
    XOR:  result = a ^ b;
    XNOR: result = ~(a ^ b);
    BUF:  result = a;
    default: result = 16'b0;
    endcase
    
end

    assign dout = oe ? result:16'bz;

    
endmodule