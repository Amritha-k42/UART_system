module uart_top (
    input wire clk,
    input wire reset,
    input wire tx_start,
    input wire [7:0] tx_data,
    input wire rx,
    output wire tx,
    output wire [7:0] rx_data,
    output wire rx_ready,
    output wire tx_busy
);

wire baud_tick;

baud_gen bg (
    .clk(clk),
    .reset(reset),
    .tick(baud_tick)
);

uart_tx tx_mod (
    .clk(clk),
    .reset(reset),
    .tx_start(tx_start),
    .baud_tick(baud_tick),
    .data_in(tx_data),
    .tx(tx),
    .busy(tx_busy)
);

uart_rx rx_mod (
    .clk(clk),
    .reset(reset),
    .rx(rx),
    .baud_tick(baud_tick),
    .data_out(rx_data),
    .data_ready(rx_ready)
);

endmodule
