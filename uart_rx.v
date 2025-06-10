module uart_rx (
    input wire clk,
    input wire reset,
    input wire rx,
    input wire baud_tick,
    output reg [7:0] data_out,
    output reg data_ready
);

reg [3:0] state;
reg [2:0] bit_index;
reg [7:0] rx_shift;
reg [3:0] sample_count;

localparam IDLE  = 0,
           START = 1,
           DATA  = 2,
           STOP  = 3;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        bit_index <= 0;
        data_ready <= 0;
    end else if (baud_tick) begin
        case (state)
            IDLE: begin
                data_ready <= 0;
                if (~rx) state <= START;  // Start bit detected
            end
            START: begin
                if (~rx) begin
                    state <= DATA;
                    bit_index <= 0;
                end else
                    state <= IDLE;
            end
            DATA: begin
                rx_shift[bit_index] <= rx;
                if (bit_index == 7)
                    state <= STOP;
                else
                    bit_index <= bit_index + 1;
            end
            STOP: begin
                if (rx) begin  // Stop bit should be 1
                    data_out <= rx_shift;
                    data_ready <= 1;
                end
                state <= IDLE;
            end
        endcase
    end
end

endmodule
