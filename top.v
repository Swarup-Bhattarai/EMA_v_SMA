module top (
    input CLOCK_50,
    input [4:0] SW,         // SW[3:0] = input, SW[4] = scroll/avg toggle
    input [1:0] KEY,        // KEY[0] = reset, KEY[1] = update
    output [9:0] LEDR,      // LEDR[9:8] = signal, LEDR[7:0] = avg
    output [6:0] HEX0,      // SMA ones
    output [6:0] HEX1,      // SMA tens
    output [6:0] HEX2,      // EMA ones
    output [6:0] HEX3,      // EMA tens
    output [6:0] HEX5       // Signal code: 1 = HOLD, 2 = BUY, 3 = SELL
);

    wire clk = CLOCK_50;
    wire rst = ~KEY[0];
    wire key_pressed = ~KEY[1];
    wire [3:0] sw_in = SW[3:0];

    wire [7:0] avg;
    wire [7:0] ema;
    wire [3:0] buffer0, buffer1, buffer2, buffer3;

    // SMA + EMA logic
    moving_avg uut (
        .clk(clk),
        .rst(rst),
        .sw_in(sw_in),
        .key_pressed(key_pressed),
        .avg_out(avg),
        .ema_out(ema),
        .buffer_out0(buffer0),
        .buffer_out1(buffer1),
        .buffer_out2(buffer2),
        .buffer_out3(buffer3)
    );

    // Signal logic
    reg [1:0] signal;
    always @(*) begin
        if (avg > ema)
            signal = 2'b01; // BUY
        else if (avg < ema)
            signal = 2'b10; // SELL
        else
            signal = 2'b00; // HOLD
    end

    assign LEDR = {signal, avg};

    // SMA/EMA digit splits
    wire [3:0] avg_ones = (avg % 10 >= 10) ? 4'd9 : (avg % 10);
    wire [3:0] avg_tens = (avg / 10 >= 10) ? 4'd9 : (avg / 10);
    wire [3:0] ema_ones = (ema % 10 >= 10) ? 4'd9 : (ema % 10);
    wire [3:0] ema_tens = (ema / 10 >= 10) ? 4'd9 : (ema / 10);

    seg7_decoder d_avg_ones (.bin(avg_ones), .seg(HEX0));
    seg7_decoder d_avg_tens (.bin(avg_tens), .seg(HEX1));
    seg7_decoder d_ema_ones (.bin(ema_ones), .seg(HEX2));
    seg7_decoder d_ema_tens (.bin(ema_tens), .seg(HEX3));

    // HEX5: Signal code display (1 = HOLD, 2 = BUY, 3 = SELL)
    reg [3:0] signal_code;
    always @(*) begin
        case (signal)
            2'b00: signal_code = 4'd1; // HOLD
            2'b01: signal_code = 4'd2; // BUY
            2'b10: signal_code = 4'd3; // SELL
            default: signal_code = 4'd1;
        endcase
    end

    seg7_decoder signal_disp (.bin(signal_code), .seg(HEX5));

endmodule
