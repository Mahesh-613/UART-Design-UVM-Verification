`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Mahesh Kumar Sahoo
// 
// Create Date: 17.02.2026 19:49:58
// Design Name: 
// Module Name: Receiver
// Project Name: UART 
// Additional Comments:
// This is the receiver module which receives the data from Tx serialy and convert it to parallel output.
// this has a over sampling factor of 16 to ensure the received data is correct.
//////////////////////////////////////////////////////////////////////////////////


module Receiver(
                input clk,rst,Rx,baud_tick,
                output reg rx_done,
                output reg [7:0] data_out
    );
    
    parameter idle_state = 3'b000,start_state = 3'b001, data_state = 3'b011, stop_state = 3'b010, done_state = 3'b110;
    
    reg [2:0] state = idle_state;
    reg [3:0] sample = 0;
    reg [2:0] index = 0;
    reg [7:0] temp_register = 8'b0;
    
    always @(posedge clk) begin
        if(rst) begin
            rx_done <= 0;
            data_out <= 0;
            state <= idle_state;
            sample <= 0;
            index <= 0;
            temp_register <= 0;
        end
        else begin 
                case (state)
                
                    idle_state : begin
                        if(Rx == 1'b0 && baud_tick)begin
                            state <= start_state;
                            sample <= 0;
                        end    
                    end
                    
                    start_state : begin
                        if(baud_tick) begin
                            rx_done <= 0;
                            if(sample == 7 && Rx != 1'b0)begin // handles glitch due to noise or any external factor
                                sample <= 0;
                                state <= idle_state;
                            end
                            else if (sample ==15) begin // goes to next state
                                state <= data_state;
                                sample <= 0;
                                index <= 0;
                                temp_register <= 0;
                            end
                            else begin
                                sample <= sample + 1'b1;
                            end
                        end
                    end        
                    
                    data_state : begin
                        if(baud_tick) begin
                            if (sample == 7) begin
                                temp_register[index] <= Rx;
                                sample <= sample + 1'b1;
                            end
                            else if(sample == 15) begin
                                 sample <= 0;
                                 if(index == 7) state <= stop_state;
                                 else index <= index + 1'b1; 
                            end     
                            else begin
                                sample <= sample + 1'b1;
                            end   
                        end
                    end   
                    
                    stop_state : begin
                        if(baud_tick) begin
                            if(sample == 7 && Rx == 1'b1) begin
                                state <=  done_state;
                                index <= 0;
                                data_out <= temp_register;
                            end
    
                            else begin
                                sample <= sample + 1'b1;
                            end   
                        end
                    end

		    done_state : begin
                if(baud_tick) begin
                        state <= idle_state;
                        rx_done <= 1'b1;
                        sample <= 0;
                end
		    end               

		    default : begin
			    state <= idle_state;
		    end

           endcase  

         end
       
end
endmodule
