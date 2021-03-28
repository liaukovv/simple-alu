/*
    00 add A + B       Addition
    01 sub A - B       Subtraction
    10 and A and B     Logical and 
    11 or  A or  B     Logical or
*/

module alu(
    input [31:0] a, b,
    input [1:0] ctrl,
    output [31:0] res,
    output [3:0] flags // 3=negative, 2=zero, 1=carry, 0=overflow
);

wire [31:0] ares, lres;
wire [31:0] sumres, sb;
wire cout;

assign res = ctrl[1] ? lres : ares;

//overflow
assign o1 = ((a[31] == b[31]) & ctrl[0])|((a[31] != b[31]) & (~ctrl[0]));
assign o2 = (ares[31] ^ a[31]);
assign o3 = ~ctrl[1];
assign flags[0] = o1 & o2 & o3;

//carry
assign flags[1] = (~ctrl[1]) & cout;

//zero
assign flags[2] = &(~res);

//negative
assign flags[3] = res[31];

//arithmetic result
assign sb = ctrl[0] ? ~b : b;
assign {cout, ares} = a + sb + ctrl[0];

//logical result
assign lres = (ctrl[1:0] == 2'b10) ? a & b    :
              (ctrl[1:0] == 2'b11) ? a | b    :
                                      32'b0    ;

endmodule