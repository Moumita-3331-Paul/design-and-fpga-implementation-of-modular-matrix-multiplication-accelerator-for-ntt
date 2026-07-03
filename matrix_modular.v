`timescale 1ns / 1ps

module matrix_modular(
    input clk,
    input rst,
    input load,
    input start,
    input [7:0] sw_data,
    input [3:0] sel,
    output reg load_done,
    output reg done,
    output reg [23:0] result
);

    integer i;

    reg [4:0] count;

    reg [7:0] mem [0:17];
    reg [23:0] C [0:8];

    // Edge detection
    reg load_d;
    reg start_d;

    wire load_pulse  = load  & ~load_d;
    wire start_pulse = start & ~start_d;

    always @(posedge clk) begin

        load_d  <= load;
        start_d <= start;

        if(rst) begin

            count <= 0;
            load_done <= 0;
            done <= 0;

            for(i=0;i<18;i=i+1)
                mem[i] <= 8'd0;

            for(i=0;i<9;i=i+1)
                C[i] <= 24'd0;

        end
        else begin

            // Load matrix values one-by-one
            if(load_pulse && !load_done) begin

                mem[count] <= sw_data;

                if(count == 5'd17)
                    load_done <= 1'b1;
                else
                    count <= count + 1'b1;
            end

            // Compute matrix multiplication once
            if(start_pulse && load_done) begin

                C[0] <= mem[0]*mem[9]  + mem[1]*mem[12] + mem[2]*mem[15];
                C[1] <= mem[0]*mem[10] + mem[1]*mem[13] + mem[2]*mem[16];
                C[2] <= mem[0]*mem[11] + mem[1]*mem[14] + mem[2]*mem[17];

                C[3] <= mem[3]*mem[9]  + mem[4]*mem[12] + mem[5]*mem[15];
                C[4] <= mem[3]*mem[10] + mem[4]*mem[13] + mem[5]*mem[16];
                C[5] <= mem[3]*mem[11] + mem[4]*mem[14] + mem[5]*mem[17];

                C[6] <= mem[6]*mem[9]  + mem[7]*mem[12] + mem[8]*mem[15];
                C[7] <= mem[6]*mem[10] + mem[7]*mem[13] + mem[8]*mem[16];
                C[8] <= mem[6]*mem[11] + mem[7]*mem[14] + mem[8]*mem[17];

                done <= 1'b1;
            end
        end
    end

    always @(*) begin
        case(sel)
            4'd0: result = C[0];
            4'd1: result = C[1];
            4'd2: result = C[2];
            4'd3: result = C[3];
            4'd4: result = C[4];
            4'd5: result = C[5];
            4'd6: result = C[6];
            4'd7: result = C[7];
            4'd8: result = C[8];
            default: result = 24'd0;
        endcase
    end

endmodule
