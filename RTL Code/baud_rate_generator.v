`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Mahesh Kumar Sahoo
// 
// Create Date: 16.02.2026 21:14:06
// Module Name: baud_rate_generator
// Project Name: UART
//
// Additional Comments:
// It acts as a synchornizer for both master and slave modules in UART protocol.
// The following baudrate generator ensures both master and slave modules were compatible to operate at 9600 bits/sec.
//////////////////////////////////////////////////////////////////////////////////


module baud_rate_generator #(parameter clk_frq = 100_000_000, parameter baudrate = 9600)(
    input clk,rst,
    output tx_baud_tick, rx_baud_tick
    );
    
    localparam tx_cnt_st = clk_frq / baudrate;
    localparam rx_cnt_st = clk_frq / (baudrate * 16); // 16 times oversampled rx tick

    localparam tx_cnt_size = $clog2(tx_cnt_st);
    localparam rx_cnt_size = $clog2(rx_cnt_st);

    reg [tx_cnt_size-1:0] tx_counter;
    reg [rx_cnt_size-1:0] rx_counter;
    
    always @ (posedge clk)
        begin
            if (rst) begin
                    tx_counter <= 0; // Initialize to 0 on reset
            end
            else begin
                if(tx_counter == tx_cnt_st)
                   tx_counter <= 0;
                else
                   tx_counter <= tx_counter + 1'b1;
            end       
        end
    always @ (posedge clk)
        begin
            if (rst) begin
                    rx_counter <= 0; // Initialize to 0 on reset
            end
            else begin
                if(rx_counter == rx_cnt_st)
                   rx_counter <= 0;
                else
                   rx_counter <= rx_counter + 1'b1;
             end      
        end
    assign tx_baud_tick = (tx_counter == 0) ? 1'b1 : 1'b0;
    assign rx_baud_tick = (rx_counter == 0) ? 1'b1 : 1'b0;
    
endmodule
