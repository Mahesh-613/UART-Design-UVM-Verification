`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: MAHESH KUMAR SAHOO
// 
// Create Date: 18.02.2026 22:47:02
// Design Name: 
// Module Name: UART_tb
// Project Name: UART
// Test bench for UART module
//////////////////////////////////////////////////////////////////////////////////


module UART_tb();

    reg clk,rst,tx_start;
    reg [7:0] data_in;
    
    wire busy,rx_done;
    wire [7:0] data_out;
    
    top dut (
              .clk(clk),
              .rst(rst),
              .tx_start(tx_start),
              .data_in(data_in),
              .busy(busy),
              .rx_done(rx_done),
              .data_out(data_out)
             );
             
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
             
    task sent_data(input [7:0] data_ip);
             begin
                 @(negedge clk);
                 while (busy) @(negedge clk);
     
                 data_in = data_ip;
                 tx_start = 1;
                 @(negedge clk);
                 tx_start = 0;
     
                 @(negedge clk); //waiting for the previous data to be sent successfully
                 while (busy) @(negedge clk);
             end
         endtask
         
         initial begin
            rst = 1;
            #10;
            rst = 0;
            
            sent_data(8'h55);
            sent_data(8'hAA);
            sent_data(8'h00);
            sent_data(8'hFF);
            sent_data(8'hA5);
            sent_data(8'h3C);
            #1000000;
            $finish;
         end
     
         initial begin
             $monitor("Time = %0t ns | Busy = %b | Data sent  = %h | Data Received = %h",$time, busy, data_in,data_out);
         end

	 initial begin
		 $dumpfile("top_dump.vcd");
		 $dumpvars(0,dut);
	 end
endmodule
