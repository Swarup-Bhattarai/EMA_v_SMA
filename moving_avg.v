module moving_avg #(
    parameter N = 4
)(
    input clk,
    input rst,
    input [3:0] sw_in,
    input key_pressed,
    output reg [7:0] avg_out,
    output reg [7:0] ema_out,
    output [3:0] buffer_out0,
    output [3:0] buffer_out1,
    output [3:0] buffer_out2,
    output [3:0] buffer_out3
);

    reg [3:0] buffer [0:N-1];
    reg [1:0] index;
    reg [7:0] sum;
    reg [2:0] count;
    reg prev_key;
    wire key_rising_edge = key_pressed & ~prev_key;
    reg [7:0] new_sum;

    assign buffer_out0 = buffer[0];
    assign buffer_out1 = buffer[1];
    assign buffer_out2 = buffer[2];
    assign buffer_out3 = buffer[3];

    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < N; i = i + 1)
                buffer[i] <= 0;

            index <= 0;
            sum <= 0;
            count <= 0;
            avg_out <= 0;
            ema_out <= 0;
            prev_key <= 0;

        end else begin
            prev_key <= key_pressed;

            if (key_rising_edge) begin
                new_sum = sum - buffer[index] + sw_in;

                if (count >= N - 1)
                    avg_out <= new_sum / N;
                else
                    avg_out <= 0;

                sum <= new_sum;
                buffer[index] <= sw_in;
                index <= (index == N - 1) ? 0 : index + 1;

                if (count < N)
                    count <= count + 1;

                
					 ema_out <= (ema_out + sw_in) >> 1;
            end
        end
    end
endmodule
