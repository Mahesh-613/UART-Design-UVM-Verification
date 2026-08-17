interface uart_intf(input logic clk,rst);
	logic tx_start,busy,rx_done;
	logic [7:0] data_in,data_out;

	clocking drv_cb@(posedge clk);
		default input #1step output #1step;
		output tx_start;
		output data_in;
		input busy;
		input rx_done;
		input data_out;
	endclocking

	clocking mon_cb @(posedge clk);
		default input #1step;
		input tx_start;
		input data_in;
		input busy;
		input rx_done;
		input data_out;
	endclocking

	modport DRIVER (clocking drv_cb,input clk,rst);
	modport MONITOR (clocking mon_cb,input clk,rst);
endinterface


