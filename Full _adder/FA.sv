module FA(
    input logic a,b,c,
    output logic sum,carry
);
logic w1,w2,w3;

HA ha1(
    .a(a), .b(b),
    .sum(w1), .carry(w2)
);

HA ha2(
    .a(w1), .b(c),
    .sum(sum), .carry(w3)
);

assign carry = w3|w2;

endmodule