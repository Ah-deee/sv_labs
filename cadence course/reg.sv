`timescale 1ns/1ps //yet to debug

module reg(
    input logic rst,logic en, logic clk, logic [7:0] data,
    output logic [7:0] out
);

always_ff @( posedge clk or posedge rst ) begin : blockreg
    if(rst):
    out <=8'b0;
    else if (en):
    out<= data;     
    
end : blockreg


endmodule
