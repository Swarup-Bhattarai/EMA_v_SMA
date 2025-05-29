module uart_rx (
    input clk,
    input rx,
    output reg [7:0] data_out,
    output reg data_valid
);
    parameter CLK_FREQ = 50000000;  // 50 MHz
    parameter BAUD_RATE = 9600;
    localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

    reg [15:0] clk_count = 0;
    reg [3:0] bit_index = 0;
    reg [7:0] rx_shift = 0;
    reg rx_reg = 1;
    reg rx_sync = 1;
    reg receiving = 0;

    always @(posedge clk) begin
        rx_reg <= rx;
        rx_sync <= rx_reg;
        data_valid <= 0;

        if (!receiving && rx_sync == 0) begin
            // start bit detected
            receiving <= 1;
            clk_count <= CLKS_PER_BIT / 2;  // center sampling
            bit_index <= 0;
        end else if (receiving) begin
            if (clk_count == CLKS_PER_BIT - 1) begin
                clk_count <= 0;

                if (bit_index < 8) begin
                    rx_shift[bit_index] <= rx_sync;
                    bit_index <= bit_index + 1;
                end else begin
                    // stop bit
                    receiving <= 0;
                    data_out <= rx_shift;
                    data_valid <= 1;
                end
            end else begin
                clk_count <= clk_count + 1;
            end
        end
    end
endmodule
