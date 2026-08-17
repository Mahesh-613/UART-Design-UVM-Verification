module Tx_tb;
	reg clk,rst,baud_tick,tx_start;
	reg [7:0] data_in;
	wire busy, Tx;

	Transmitter dut(
		.clk(clk),
		.rst(rst),
		.baud_tick(baud_tick),
		.tx_start(tx_start),
		.data_in(data_in),
		.busy(busy),
		.Tx(Tx)
	);
	
	reg [31:0] baudtick_cnt;

	always @(posedge  clk) begin
		if(rst) begin
			baud_tick <= 0;       
			baudtick_cnt <= 0;
		end
		else if (baudtick_cnt == 10451) begin
			baud_tick <= 1;
			baudtick_cnt <= 0;
		end

		else begin
			baud_tick <= 0;
			baudtick_cnt <= baudtick_cnt + 1;
		end
	end

	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	initial begin
		rst = 1;
		#10;
		rst = 0;

		$display("[time = %0t] sent A3",$time);
		sent_data(8'h00);
		
		$display("[time = %0t] sent AA",$time);
		sent_data(8'hFF);
		

		$display("[time = %0t] sent 00",$time);
		sent_data(8'h00);
		
		$display("[time = %0t] sent FF",$time);
		sent_data(8'hAA);

		$display("[time = %0t] sent 3C",$time);
		sent_data(8'h3C);
		

		#10000;
		$finish;

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

			#1000;
		end
	endtask

	initial begin
		$monitor("Time = %0t ns | State/Tx Line = %b | Busy = %b | Din = %h",$time, Tx, busy, data_in);
	end

	initial begin
		$dumpfile("TX.vcd");
		$dumpvars(0,dut);
	end

	endmodule
