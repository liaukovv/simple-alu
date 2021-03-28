module alu_tb();
    reg [31:0] a, b, res_expected, vectornum, errors;
    wire [31:0] res;
    reg [3:0] flags_expected;
    reg [3:0] ctrl;
    wire[3:0] flags;
    reg clk, reset;
    reg [103:0] testvectors[10000:0]; 


    alu dut(
        .a(a),
        .b(b),
        .ctrl(ctrl[1:0]),
        .res(res),
        .flags(flags)
    );

    always begin
        clk = 1; #5; clk = 0; #5;
    end

    initial begin
        $readmemh("vectors.tv", testvectors);
        vectornum = 0; errors = 0;
        reset = 1; #27; reset = 0;
    end

    always @(posedge clk) begin
        #1; {a, b, ctrl, res_expected, flags_expected} = testvectors[vectornum];
    end

    always @(negedge clk) begin
        if(~reset) begin
            if({res, flags} != {res_expected, flags_expected}) begin
                $display("Error on vec. %d: inputs=%b", vectornum, {a,b,ctrl});
                $display("outputs = %b (%b expected)", 
                            {res, flags}, {res_expected, flags_expected});
                errors = errors + 1;
            end
            vectornum = vectornum + 1;
            if(testvectors[vectornum] === 104'bx) begin
                $display("%d tests completed with %d errors", vectornum, errors);
                $stop;
            end
        end
    end

endmodule