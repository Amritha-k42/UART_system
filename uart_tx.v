module uart_tx (
    input wire clk,
    input wire reset,
    input wire tx_start,
    input wire baud_tick,
    input wire [7:0] data_in,
    output reg tx,
    output reg busy
);

reg [3:0] state;
reg [2:0] bit_index;
reg [7:0] tx_data;

localparam IDLE  = 0,
           START = 1,
           DATA  = 2,
           STOP  = 3;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        tx <= 1;
        busy <= 0;
        bit_index <= 0;
    end else if (baud_tick) begin
        case (state)
            IDLE: begin
                tx <= 1;
                busy <= 0;
                if (tx_start) begin
                    tx_data <= data_in;
                    state <= START;
                    busy <= 1;
                end
            end
            START: begin
                tx <= 0;
                state <= DATA;
                bit_index <= 0;
            end
            DATA: begin
                tx <= tx_data[bit_index];
                if (bit_index == 7)
                    state <= STOP;
                else
                    bit_index <= bit_index + 1;
            end
            STOP: begin
                tx <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule
