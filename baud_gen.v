`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.06.2025 03:10:50
// Design Name: 
// Module Name: baud_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module baud_gen (
    input wire clk,
    input wire reset,
    output reg tick
);
    parameter CLK_FREQ = 50000000;  // 50 MHz
    parameter BAUD_RATE = 9600;
    localparam COUNT_MAX = CLK_FREQ / BAUD_RATE;

    reg [31:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            tick <= 0;
        end else begin
            if (count >= COUNT_MAX) begin
                count <= 0;
                tick <= 1;
            end else begin
                count <= count + 1;
                tick <= 0;
            end
        end
    end
endmodule
