`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Mahesh Kumar Sahoo
// 
// Create Date: 17.02.2026 00:05:25
// Design Name: 
// Module Name: Transmitter
// Project Name: UART
// Additional Comments:
// This defines the working of transmitter module 
//////////////////////////////////////////////////////////////////////////////////


module Transmitter(
    input clk,baud_tick,rst,tx_start,
    input [7:0] data_in,
    output wire busy,
    output reg Tx
    );
    
    parameter idle_state = 2'b00, start_state = 2'b01, data_state = 2'b10, stop_state = 2'b11;
    
    reg [7:0] data;
    reg [2:0] index;
    
    reg [1:0] state = idle_state;
    
    always @(posedge clk)
     begin
        if(rst) begin 
            Tx <= 1'b1;
            state <= idle_state;
        end
        else begin
            case(state)
                idle_state:
                    begin
                        Tx <= 1'b1;
                        if(tx_start)
                            begin
                            state <= start_state;
                            data <= data_in;
                            index <= 3'h0;
                            end
                        else
                            state <= idle_state;
                    end
               start_state:
                    begin
                        if(baud_tick)
                            begin
                            state <= data_state;
                            Tx <= 1'b0;
                            end
                         else
                            state <= start_state;
                    end
               data_state :
                    begin
                        if(baud_tick)
                            begin
                                Tx <= data[index];
                                if(index == 3'd7)
                                    state <= stop_state;
                                else
                                    begin
                                    index <= index + 3'd1;
                                
                                    end
                            end
                    end
               stop_state :
                    begin
                        if(baud_tick)
                            begin
                            Tx <= 1'b1;
                            state <= idle_state;
                            end
                    end
               default : begin
                    state <= idle_state; 
                    Tx <= 1'b1;
               end       
             endcase
        end  
     end
     assign busy = (state != idle_state) ? 1'b1: 1'b0;
endmodule
