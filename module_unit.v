module module_unit (
    input  [23:0] dividend,
    input  [7:0]  divisor,
    output reg [7:0] result_mod
);

always @(*) begin
    if(divisor == 8'd0)
        result_mod = 8'd0;
    else
        result_mod = dividend % divisor;
end

endmodule
