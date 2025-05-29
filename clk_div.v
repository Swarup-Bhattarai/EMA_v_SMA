module clk_div #(
    parameter COUNT = 50_000_000  // 1 second tick at 50 MHz
)(
    input clk,
    input rst,
    output reg tick
);
    reg [25:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            tick <= 0;
        end else if (counter == COUNT - 1) begin
            counter <= 0;
            tick <= 1;
        end else begin
            counter <= counter + 1;
            tick <= 0;
        end
    end
endmodule
