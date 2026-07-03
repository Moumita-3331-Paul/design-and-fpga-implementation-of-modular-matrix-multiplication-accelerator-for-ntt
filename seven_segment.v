module seven_segment (
    input        clk,
    input        rst,
    input  [3:0] digit3,
    input  [3:0] digit2,
    input  [3:0] digit1,
    input  [3:0] digit0,
    output reg [3:0] an,
    output reg [6:0] seg   // {g,f,e,d,c,b,a} active LOW
);
    reg [16:0] clk_cnt;
    reg        clk_1k;
    reg [1:0]  digit_sel;
    reg [3:0]  cur_digit;

    // 100MHz ? 1kHz
    always @(posedge clk or posedge rst) begin
        if (rst) begin clk_cnt<=0; clk_1k<=0; end
        else if (clk_cnt == 17'd49_999) begin clk_cnt<=0; clk_1k<=~clk_1k; end
        else clk_cnt <= clk_cnt + 1;
    end

    always @(posedge clk_1k or posedge rst) begin
        if (rst) digit_sel <= 0;
        else     digit_sel <= digit_sel + 1;
    end

    always @(*) begin
        case (digit_sel)
            2'd0: begin an=4'b1110; cur_digit=digit0; end
            2'd1: begin an=4'b1101; cur_digit=digit1; end
            2'd2: begin an=4'b1011; cur_digit=digit2; end
            2'd3: begin an=4'b0111; cur_digit=digit3; end
        endcase
    end

    always @(*) begin
        case (cur_digit)
            4'd0:  seg = 7'b1000000;
            4'd1:  seg = 7'b1111001;
            4'd2:  seg = 7'b0100100;
            4'd3:  seg = 7'b0110000;
            4'd4:  seg = 7'b0011001;
            4'd5:  seg = 7'b0010010;
            4'd6:  seg = 7'b0000010;
            4'd7:  seg = 7'b1111000;
            4'd8:  seg = 7'b0000000;
            4'd9:  seg = 7'b0010000;
            4'd15: seg = 7'b1111111; // blank
            default: seg = 7'b1111111;
        endcase
    end
endmodule
