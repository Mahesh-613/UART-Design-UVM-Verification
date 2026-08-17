module rx_tb;
	reg clk,rst,baud_tick,rx;
	wire [7:0] data_out;
	wire rx_done;

	Receiver dut(
		.clk(clk),
		.rst(rst),
		.baud_tick(baud_tick),
		.Rx(rx),
		.rx_done(rx_done),
		.data_out(data_out)
	);

	reg [16:0] baudtick_cnt = 0;

	always @(posedge  clk) begin
		if(rst) begin
			baud_tick <= 0;       
			baudtick_cnt <= 0;
		end
		else if (baudtick_cnt == 325) begin
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
		forever #10 clk = ~clk;
	end

	initial begin
		//rst = 1;
		//#20;
		rst = 0;

		$display("[time = %0t] sent 00",$time);
		sent_serial_data(8'h00);

		$display("[time = %0t] sent FF",$time);
		sent_serial_data(8'hFF);

		$display("[time = %0t] sent 00",$time);
		sent_serial_data(8'h00);

		$display("[time = %0t] sent AA",$time);
		sent_serial_data(8'hAA);
		
		#1000;
		$finish;
	end

	// Task to transmit 1 full UART Frame (Start + 8 Data Bits + Stop Bit)
    // 1 Bit Period = 16 * 326 * 20ns = 104,320 ns
    task sent_serial_data(input [7:0] data_ip);
        integer idx;
        begin
            // Start bit
            rx = 1'b0;
            #(326 * 16 * 20);

            // Data bits (LSB First)
            for (idx = 0; idx < 8; idx = idx + 1) begin
                rx = data_ip[idx];
                #(326 * 16 * 20);
            end

            // Stop bit
            rx = 1'b1;
            #(326 * 16 * 20);
        end
    endtask


	initial begin
		$monitor("Time = %0t ns | data_out = %0h",$time,data_out);
	end

	initial begin
		$dumpfile("rx_dump.vcd");
		$dumpvars(0,dut);
	end



endmodule
