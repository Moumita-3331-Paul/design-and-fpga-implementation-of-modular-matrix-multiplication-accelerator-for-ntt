module bin_bcd (
    input  [7:0]  bin,
    output reg [3:0] hund,   // 100s
    output reg [3:0] tens,   // 10s
    output reg [3:0] ones    // 1s
);
    integer i;
    reg [19:0] shift; // [19:12]=3 BCD digits, [7:0]=binary

    always @(*) begin
        shift = 20'd0;
        shift[7:0] = bin;
        for (i = 0; i < 8; i = i + 1) begin
            if (shift[11:8]  >= 4'd5) shift[11:8]  = shift[11:8]  + 4'd3;
            if (shift[15:12] >= 4'd5) shift[15:12] = shift[15:12] + 4'd3;
            if (shift[19:16] >= 4'd5) shift[19:16] = shift[19:16] + 4'd3;
            shift = shift << 1;
        end
        ones = shift[11:8];
        tens = shift[15:12];
        hund = shift[19:16];
    end
endmodule
