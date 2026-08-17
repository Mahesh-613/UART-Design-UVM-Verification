`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Mahesh Kumar Sahoo
// 
// Create Date: 18.02.2026 22:30:00
// Design Name: 
// Module Name: top
// Project Name: UART
// Additional Comments:
// This is the top module of UART , this defines the interconnection between different modules.
//////////////////////////////////////////////////////////////////////////////////


module top(
    input clk,rst,tx_start,
    input [7:0] data_in,
    output busy,rx_done,
    output [7:0] data_out
    );
    wire tx_baud_tick,rx_baud_tick;
    wire tx_rx;
    
    baud_rate_generator BAUD(
                    .clk(clk),
                    .rst(rst),
                    .tx_baud_tick(tx_baud_tick),
                    .rx_baud_tick(rx_baud_tick)
                    );
    Transmitter TX (
                    .clk(clk),
                    .rst(rst),
                    .tx_start(tx_start),
                    .baud_tick(tx_baud_tick),
                    .data_in(data_in),
                    .busy(busy),
                    .Tx(tx_rx)
                    );
                    
    Receiver RX(
                .clk(clk),
                .rst(rst),
                .baud_tick(rx_baud_tick),
                .rx_done(rx_done),
                .data_out(data_out),
                .Rx(tx_rx)
                );
                    
                    
    
    

    
endmodule
