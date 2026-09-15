module mux#(WIDTH = 8)(
    input logic [WIDTH-1:0] a,b,
    input logic sel,
    output logic [WIDTH-1:0] out
);

timeunit 1ns;
timeprecision 100ps;

always_comb begin : blockmux
    unique case(sel)
        1'b0: out = a;
        1'b1: out = b;
        default: out = 'x;
    endcase
end : blockmux
 
endmodule