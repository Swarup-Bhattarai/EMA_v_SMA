module seg7_multiplex (
    input clk,
    input rst,
    input [3:0] digit5, digit4, digit3, digit2, digit1, digit0, // values to show
    output reg [6:0] seg,     // shared segment pins
    output reg [5:0] digit_en // active-low enables for HEX5 to HEX0
);

    reg [2:0] index = 0; // which digit to display (0–5)
    reg [16:0] div_counter = 0; // slow down display rate
    wire tick = (div_counter == 0);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            div_counter <= 0;
        end else begin
            div_counter <= div_counter + 1;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            index <= 0;
        else if (tick)
            index <= index + 1;
    end

    wire [3:0] current_digit;
    assign current_digit =
        (index == 0) ? digit0 :
        (index == 1) ? digit1 :
        (index == 2) ? digit2 :
        (index == 3) ? digit3 :
        (index == 4) ? digit4 :
                       digit5;

    // 7-segment decoding
    always @(*) begin
        case (current_digit)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;
            default: seg = 7'b1111111;
        endcase
    end

    // Enable active digit (active low)
    always @(*) begin
        digit_en = 6'b111111;
        digit_en[index] = 1'b0;
    end

endmodule
